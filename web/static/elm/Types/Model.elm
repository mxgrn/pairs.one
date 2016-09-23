module Types.Model exposing (..)

--

import Types.Game exposing (..)
import Types.Player exposing (..)
import Types.Card exposing (..)
import Types.Theme exposing (..)
import Types.Msg exposing (..)
import Phoenix.Socket
import Phoenix.Channel


type alias Model =
    { game : Game
    , playerId : PlayerId
    , playerTurn : Int
    , flippedIds : List CardId
    , themes : List Theme
    , host : String
    , isCompleted : Bool
    , locale : String
    , phxSocket : Phoenix.Socket.Socket Msg
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
