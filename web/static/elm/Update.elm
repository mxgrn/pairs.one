module Update exposing (update)

import Phoenix.Socket
import Phoenix.Push
import Json.Decode as JD
import Json.Encode as JE
import List.Extra


--

import Bool
import PortsOut exposing (..)
import Types.Model exposing (..)
import Types.Game exposing (..)
import Types.Player exposing (..)
import Types.Card exposing (..)
import Types.Msg exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- UpdateGame with complete state
        UpdateGame raw ->
            case JD.decodeValue gameDecoder raw of
                Ok game ->
                    updateGame model game

                Err error ->
                    decoderError model error

        ReceiveCompressedGame raw ->
            model ! [ decompressAndUpdateGame raw ]

        SendCompressedGame patch ->
            model ! [ sendCompressedGame model patch ]

        UpdatePlayer name ->
            let
                game =
                    updatePlayerName model.game model.playerId name
            in
                ( { model | game = game }, sendGame game )

        FlipCard index ->
            flipCard index model

        ChangeTheme theme ->
            let
                game =
                    model.game

                game' =
                    { game | theme = theme }
            in
                { model | game = game' } ! []

        Replay ->
            replay model

        PhoenixMsg msg ->
            let
                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.update msg model.phxSocket
            in
                ( { model | phxSocket = phxSocket }
                , Cmd.map PhoenixMsg phxCmd
                )


replay : Model -> ( Model, Cmd Msg )
replay model =
    let
        payload =
            gameEncoder model.game

        push =
            Phoenix.Push.init "replay_game" ("game:" ++ model.game.id)
                |> Phoenix.Push.withPayload payload

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.push push model.phxSocket
    in
        { model | isCompleted = False } ! [ Cmd.map PhoenixMsg phxCmd ]


flipCard : Int -> Model -> ( Model, Cmd Msg )
flipCard index model =
    let
        game =
            model.game

        players =
            game.players

        flippedIds =
            model.flippedIds

        flippedIds' =
            if (List.length flippedIds) == game.flips then
                [ index ]
            else
                -- preventing dblclick glitch in Chrome with `unique`
                List.append flippedIds [ index ] |> List.Extra.unique

        ( turn, matched, turnFinished ) =
            if (List.length flippedIds') == game.flips then
                let
                    firstValue =
                        flippedIds' |> List.head |> Maybe.withDefault -1 |> cardValueAt game.cards

                    matched =
                        List.all (\id -> (cardValueAt game.cards id) == firstValue) flippedIds'

                    turn =
                        if matched then
                            game.turn
                        else
                            (game.turn + 1) % List.length players
                in
                    ( turn, matched, True )
            else
                ( game.turn, False, False )

        turn' =
            if allCleared then
                List.Extra.findIndex (\p -> p.score == maxScore) players
                    |> Maybe.withDefault turn
            else
                turn

        updateCard : Int -> Card -> Card
        updateCard i card =
            let
                flipped =
                    (List.any (\id -> i == id) flippedIds')

                cleared =
                    (List.any (\id -> i == id && matched) flippedIds') || card.cleared
            in
                { card | flipped = flipped, cleared = cleared }

        cards =
            List.indexedMap updateCard game.cards

        isInaccurateTurn =
            not matched && (isAnySeen flippedIds' cards)

        cards' =
            if turnFinished then
                List.map (\card -> { card | seen = (card.flipped || card.seen) && not card.cleared }) cards
            else
                cards

        allCleared =
            List.all .cleared cards

        isAnySeen : List Int -> List Card -> Bool
        isAnySeen indices cards =
            let
                seenIndices =
                    List.indexedMap (,) cards |> List.filter (snd >> .seen) |> List.map fst
            in
                List.any (\i -> List.member i seenIndices) indices

        updatePlayer : Player -> Player
        updatePlayer player =
            if player.id == model.playerId then
                let
                    turns =
                        player.turns + 1

                    inaccurateTurns =
                        player.inaccurateTurns + Bool.toInt isInaccurateTurn

                    score =
                        player.score + Bool.toInt matched
                in
                    { player | score = score, turns = turns, inaccurateTurns = inaccurateTurns }
            else
                player

        players' =
            if turnFinished then
                List.map updatePlayer players
            else
                players

        players'' =
            if allCleared then
                let
                    maxScore =
                        players' |> List.map .score |> List.maximum |> Maybe.withDefault 0

                    updatePlayerTotalScore : Int -> Player -> Player
                    updatePlayerTotalScore maxScore player =
                        { player | totalScore = (player.totalScore + Bool.toInt (player.score == maxScore)) }
                in
                    players' |> List.map (updatePlayerTotalScore maxScore)
            else
                players'

        maxScore =
            players' |> List.map .score |> List.maximum |> Maybe.withDefault -1

        game' =
            { game | cards = cards', players = players'', turn = turn' }

        model' =
            { model | game = game', flippedIds = flippedIds', isCompleted = allCleared }
    in
        ( model', sendGame game' )


updateGame : Model -> Game -> ( Model, Cmd Msg )
updateGame model game =
    let
        gameStarting =
            model.game.turn == -1 && game.turn /= -1

        ( cmd, game' ) =
            if gameStarting then
                let
                    game' =
                        { game | turn = 0 }
                in
                    ( playAudio "ready", game' )
            else
                ( Cmd.none, game )

        game'' =
            if List.length (game'.players) == 1 then
                { game' | turn = 0 }
            else
                game'

        isCompleted =
            List.all .cleared game.cards

        flippedIds' =
            flippedIds game.cards

        playerTurn' =
            playerTurn model.playerId game.players
    in
        { model
            | game = game''
            , flippedIds = flippedIds'
            , playerTurn = playerTurn'
            , isCompleted = isCompleted
        }
            ! [ cmd ]


sendGame : Game -> Cmd Msg
sendGame game =
    compressAndSendGame game


sendCompressedGame : Model -> JE.Value -> Cmd Msg
sendCompressedGame model game =
    let
        push =
            Phoenix.Push.init "update_game" ("game:" ++ model.game.id)
                |> Phoenix.Push.withPayload game

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.push push model.phxSocket
    in
        Cmd.map PhoenixMsg phxCmd


decoderError : Model -> String -> ( Model, Cmd Msg )
decoderError model error =
    let
        _ =
            Debug.log "Decoder error" error
    in
        ( model, Cmd.none )
