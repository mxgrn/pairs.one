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
import PlayerStats exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnInputPlayerName name ->
            { model | playerName = name } ! []

        SetUserName ->
            let
                push =
                    Phoenix.Push.init "set_player_name" ("game:" ++ model.game.id)
                        |> Phoenix.Push.withPayload
                            (JE.object
                                [ ( "name", JE.string model.playerName )
                                , ( "player_id", JE.string model.playerId )
                                ]
                            )

                ( _, phxCmd ) =
                    Phoenix.Socket.push push model.phxSocket
            in
                model ! [ Cmd.map PhoenixMsg phxCmd, (storeNameLocally model.playerName) ]

        -- Chat
        OnInputMessage msg ->
            { model | chatMessage = msg } ! []

        SendMessage ->
            let
                push =
                    Phoenix.Push.init "new_chat_msg" ("game:" ++ model.game.id)
                        |> Phoenix.Push.withPayload
                            (JE.object
                                [ ( "player_id", JE.string model.playerId )
                                , ( "body", JE.string model.chatMessage )
                                ]
                            )

                ( _, phxCmd ) =
                    Phoenix.Socket.push push model.phxSocket
            in
                { model | chatMessage = "" } ! [ Cmd.map PhoenixMsg phxCmd ]

        ReceiveMessage raw ->
            let
                chatMessageDecoder : JD.Decoder ChatMessage
                chatMessageDecoder =
                    JD.map2 ChatMessage
                        (JD.field "player_id" JD.string)
                        (JD.field "body" JD.string)

                chatMessage =
                    case JD.decodeValue chatMessageDecoder raw of
                        Ok msg ->
                            msg

                        Err error ->
                            ChatMessage "" error

                messages =
                    chatMessage :: model.chatMessages

                cmd =
                    if chatMessage.playerId /= model.playerId then
                        playAudio "chat-msg"
                    else
                        Cmd.none
            in
                { model | chatMessages = messages } ! [ cmd ]

        -- UpdateGame with complete state
        UpdateGame raw ->
            case JD.decodeValue gameDecoder raw of
                Ok game ->
                    updateGame model game

                Err error ->
                    decoderError model error

        UpdateFocus raw ->
            case JD.decodeValue JD.bool raw of
                Ok value ->
                    { model | inFocus = value } ! []

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

        FlipCard index ->
            -- This check is needed because Chrome seems to process click events asynchrously, which may lead to race
            -- condition due to the fact that a tile gets clicked while it's no longer current player's turn.
            if model.playerTurn == model.game.turn || isLocal model.game then
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
                            if isLocal model.game then
                                model.game
                            else
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
            if (List.length game.cards.flipped) == game.flips then
                [ index ]
            else
                index :: game.cards.flipped

        ( newTurn, matched, turnFinished ) =
            if (List.length flippedIds) == game.flips then
                let
                    firstValue =
                        flippedIds |> List.head |> Maybe.withDefault -1 |> cardValueAt game.cards

                    matched =
                        List.all (\id -> (cardValueAt game.cards id) == firstValue) flippedIds

                    newTurn =
                        if matched then
                            game.turn
                        else
                            (game.turn + 1) % List.length players
                in
                    ( newTurn, matched, True )
            else
                ( game.turn, False, False )

        cards =
            game.cards

        newCleared =
            if matched then
                cards.cleared ++ flippedIds
            else
                cards.cleared

        newSeen =
            if matched then
                cards.seen
            else
                cards.seen
                    ++ flippedIds
                    |> List.Extra.unique

        newCards =
            { cards | cleared = newCleared, seen = newSeen, flipped = flippedIds }

        roundFinished =
            List.length newCleared == List.length cards.values

        updatePlayerStatsById : Player -> Player
        updatePlayerStatsById player =
            if player.id == model.playerId then
                player |> PlayerStats.updatePlayer cards flippedIds matched
            else
                player

        updatePlayerStatsByIndex : Int -> Player -> Player
        updatePlayerStatsByIndex i player =
            if model.playerTurn == i then
                player |> PlayerStats.updatePlayer cards flippedIds matched
            else
                player

        players_ =
            if turnFinished then
                if isLocal model.game then
                    List.indexedMap updatePlayerStatsByIndex players
                else
                    List.map updatePlayerStatsById players
            else
                players

        newPlayers =
            if roundFinished then
                PlayerStats.updatePlayers players_
            else
                players_

        newGame =
            { game | cards = newCards, players = newPlayers, turn = newTurn }

        playerTurn =
            if isLocal game && turnFinished && not matched then
                -- Only in case of local game are we overriding playerTurn
                if roundFinished then
                    newTurn
                else
                    (model.playerTurn + 1) % List.length model.game.players
            else
                model.playerTurn

        newModel =
            { model | game = newGame, flippedIds = flippedIds, isCompleted = roundFinished, playerTurn = playerTurn }
    in
        ( newModel, Cmd.batch [ sendGame newGame ] )


updateGame : Model -> Game -> ( Model, Cmd Msg )
updateGame model game =
    let
        gameStarting =
            model.game.turn == -1 && game.turn /= -1

        ( playReadyCmd, game_ ) =
            if gameStarting && not (isLocal game) then
                let
                    game_ =
                        { game | turn = 0 }
                in
                    ( playAudio "ready", game_ )
            else
                ( Cmd.none, game )

        playFlipCmd =
            if game.cards.flipped /= model.game.cards.flipped && model.game.cards.flipped /= [] then
                playAudio "flip"
            else
                Cmd.none

        game__ =
            if isSolo game_ then
                { game_ | turn = 0 }
            else
                game_

        isCompleted =
            List.length game.cards.values == List.length game.cards.cleared

        playerTurn_ =
            if isLocal game then
                game__.turn
            else
                playerTurn model.playerId game.players
    in
        { model
            | game = game__
            , flippedIds = game.cards.flipped
            , playerTurn = playerTurn_
            , isCompleted = isCompleted
            , random = game.random
        }
            ! [ playReadyCmd, playFlipCmd ]


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


cardValueAt : CardData -> Int -> Int
cardValueAt cardData index =
    cardData.values |> List.drop index |> List.head |> Maybe.withDefault -1
