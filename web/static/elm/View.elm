module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import String


-- submodules

import ScoreboardView exposing (..)
import ReplayView exposing (..)
import BoardView exposing (..)
import Types.Model exposing (..)
import Types.Msg exposing (..)


view : Model -> Html Msg
view model =
    case List.length (model.game.cards) of
        0 ->
            loading

        _ ->
            game model


loading : Html Msg
loading =
    div [ class "game" ]
        [ h4 [ style [ ( "text-align", "center" ) ] ] [ text "" ] ]


game : Model -> Html Msg
game model =
    if model.isCompleted then
        completedGame model
    else
        boardView model


completedGame : Model -> Html Msg
completedGame model =
    div [ class "game row" ]
        [ div [ class "game--completed" ]
            [ scoreboardView model
            , replayView model
            ]
        ]
