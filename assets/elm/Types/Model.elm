module Types.Model exposing (..)

--

import Types.Game exposing (..)
import Types.Player exposing (..)
import Types.Card exposing (..)
import Types.Theme exposing (..)
import Types.Msg exposing (..)
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Presence exposing (PresenceState)


type alias Model =
    { game : Game
    , playerId : PlayerId {- current player's id (blank for local game) -}
    , playerName : String {- current player's (blank for local game) -}
    , playerTurn : Int {- current player's turn (changing for local game) -}
    , flippedIds : List CardId {- indices of cards flipped over during the turn -}
    , themes : List Theme
    , host : String
    , isSsl: Bool
    , isCompleted : Bool {- round completed -}
    , locale : String
    , random : Bool
    , chatMessage : String
    , chatMessages : List ChatMessage
    , phxSocket : Phoenix.Socket.Socket Msg
    , phxPresences : PresenceState PlayerPresence
    , inFocus : Bool
    }


type alias ChatMessage =
    { playerId : PlayerId
    , body : String
    }


playerName : Model -> String
playerName model =
    let
        rawName =
            playerAt model.game.turn model.game.players
                |> Maybe.map .name

        dummyName =
            "Player " ++ (toString <| model.playerTurn + 1)
    in
        case rawName of
            Just "" ->
                dummyName

            Just name ->
                name

            Nothing ->
                dummyName


gameUrl : Model -> String
gameUrl model =
    "https://" ++ model.host ++ "/" ++ model.locale ++ "/games/" ++ model.game.id


gameIsActive : Model -> Bool
gameIsActive model =
    model.game.turn /= -1
