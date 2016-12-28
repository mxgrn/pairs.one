module Update exposing (update)

import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Json.Decode as JD
import Json.Encode as JE
import List.Extra
import Phoenix.Presence exposing (PresenceState, syncState, syncDiff, presenceStateDecoder, presenceDiffDecoder)
import Array


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

        SelectGameUrlInput ->
            model ! [ focus ".game-url" ]

        CopyUrl ->
            model ! [ copyUrl ".game-url" ]

        UpdatePlayer name ->
            let
                game =
                    updatePlayerName model.game model.playerId name
            in
                ( { model | game = game }, sendGame game )

        FlipCard index ->
            -- This check is needed because Chrome seems to process click events asynchrously, which may lead to race
            -- condition due to the fact that a tile gets clicked while it's no longer current player's turn.
            if model.playerTurn == model.game.turn then
                flipCard index model
            else
                model ! []

        ChangeTheme theme ->
            let
                game =
                    model.game

                game_ =
                    { game | theme = theme }
            in
                { model | game = game_ } ! []

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

        HandlePresenceState raw ->
            case JD.decodeValue (presenceStateDecoder playerPresenceDecoder) raw of
                Ok presenceState ->
                    let
                        newPresenceState =
                            model.phxPresences |> syncState presenceState
                    in
                        { model | phxPresences = newPresenceState } ! []

                Err error ->
                    let
                        _ =
                            Debug.log "Error" error
                    in
                        model ! []

        HandlePresenceDiff raw ->
            case JD.decodeValue (presenceDiffDecoder playerPresenceDecoder) raw of
                Ok presenceDiff ->
                    let
                        newPresenceState =
                            model.phxPresences |> syncDiff presenceDiff

                        game =
                            updateFromPresenceState model.game newPresenceState
                    in
                        { model | game = game, phxPresences = newPresenceState } ! []

                Err error ->
                    let
                        _ =
                            Debug.log "Error" error
                    in
                        model ! []


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

        flippedIds_ =
            if model.playerTurn == game.turn then
                if (List.length flippedIds) == game.flips then
                    [ index ]
                else
                    -- preventing dblclick glitch in Chrome with `unique`
                    List.append flippedIds [ index ] |> List.Extra.unique
            else
                flippedIds

        ( turn, matched, turnFinished ) =
            if (List.length flippedIds_) == game.flips then
                let
                    firstValue =
                        flippedIds_ |> List.head |> Maybe.withDefault -1 |> cardValueAt game.cards

                    matched =
                        List.all (\id -> (cardValueAt game.cards id) == firstValue) flippedIds_

                    turn =
                        if matched then
                            game.turn
                        else
                            (game.turn + 1) % List.length players
                in
                    ( turn, matched, True )
            else
                ( game.turn, False, False )

        turn_ =
            if allCleared then
                List.Extra.findIndex (\p -> p.score == maxScore) players
                    |> Maybe.withDefault turn
            else
                turn

        updateCard : Int -> Card -> Card
        updateCard i card =
            let
                flipped =
                    (List.any (\id -> i == id) flippedIds_)

                cleared =
                    (List.any (\id -> i == id && matched) flippedIds_) || card.cleared
            in
                { card | flipped = flipped, cleared = cleared }

        cards =
            List.indexedMap updateCard game.cards

        isInaccurateTurn =
            not matched && (isAnySeen flippedIds_ cards)

        cards_ =
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
                    List.indexedMap (,) cards |> List.filter (Tuple.second >> .seen) |> List.map Tuple.first
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

        players_ =
            if turnFinished then
                List.map updatePlayer players
            else
                players

        players__ =
            if allCleared then
                let
                    maxScore =
                        players_ |> List.map .score |> List.maximum |> Maybe.withDefault 0

                    updatePlayerTotalScore : Int -> Player -> Player
                    updatePlayerTotalScore maxScore player =
                        { player | totalScore = (player.totalScore + Bool.toInt (player.score == maxScore)) }
                in
                    players_ |> List.map (updatePlayerTotalScore maxScore)
            else
                players_

        maxScore =
            players_ |> List.map .score |> List.maximum |> Maybe.withDefault -1

        game_ =
            { game | cards = cards_, players = players__, turn = turn_ }

        model_ =
            { model | game = game_, flippedIds = flippedIds_, isCompleted = allCleared }
    in
        ( model_, Cmd.batch [ sendGame game_ ] )


updateGame : Model -> Game -> ( Model, Cmd Msg )
updateGame model game =
    let
        gameStarting =
            model.game.turn == -1 && game.turn /= -1

        ( cmd, game_ ) =
            if gameStarting then
                let
                    game_ =
                        { game | turn = 0 }
                in
                    ( playAudio "ready", game_ )
            else
                ( Cmd.none, game )

        game__ =
            if List.length (game_.players) == 1 then
                { game_ | turn = 0 }
            else
                game_

        isCompleted =
            List.all .cleared game.cards

        flippedIds_ =
            flippedIds game.cards

        playerTurn_ =
            playerTurn model.playerId game.players
    in
        { model
            | game = game__
            , flippedIds = flippedIds_
            , playerTurn = playerTurn_
            , isCompleted = isCompleted
            , random = game.random
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
