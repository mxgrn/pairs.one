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
import ChatView exposing (..)
import Types.Model exposing (..)
import Types.Game exposing (isLocal)
import Types.Msg exposing (..)
import I18n exposing (..)
import I18n.Translation exposing (..)
import PlayersView exposing (..)


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
        [ h4 [ style [ ( "text-align", "center" ) ] ] [ img [ src "/images/loading.gif", width 40 ] [] ] ]


game : Model -> Html Msg
game model =
    let
        isSinglePlayer =
            (List.length model.game.players) == 1

        chatArea =
            if isLocal model.game || isSinglePlayer then
                []
            else
                [ userName model
                , chatView model
                ]
    in
        if model.isCompleted then
            completedGame model
        else
            div [ class "row" ]
                [ prestartOverlay model
                , div [ class "col-sm-3" ]
                    [ playersView model
                    ]
                , div [ class "col-sm-6" ]
                    [ boardView model
                    ]
                , div [ class "col-sm-3" ] chatArea
                ]


completedGame : Model -> Html Msg
completedGame model =
    div [ class "game" ]
        [ div [ class "game--completed" ]
            [ scoreboardView model
            , replayView model
            ]
        ]


userName : Model -> Html Msg
userName model =
    div [ class "user-name-area" ]
        [ label [] [ text "Your name" ]
        , div [ class "input-group input-group--name" ]
            [ input
                [ class "form-control", onInput OnInputPlayerName, value model.playerName ]
                []
            , span [ class "input-group-btn" ]
                [ button [ class "btn btn-default", onClick SetUserName ] [ text "ok" ]
                ]
            ]
        ]


prestartOverlay : Model -> Html Msg
prestartOverlay model =
    let
        t =
            I18n.translate model.locale

        hint =
            if model.random then
                ShareThisUrlRandom
            else
                ShareThisUrl
    in
        if not <| gameIsActive model then
            div []
                [ div [ class "pairs-overlay" ] []
                , div [ class "pairs-modal" ]
                    [ div [ class "form-group" ]
                        [ label [ class "game-url" ] [ text <| t <| hint ]
                        , div [ class "input-group clipboard-input" ]
                            [ input
                                [ class "form-control game-url"
                                , value (gameUrl model)
                                , onClick SelectGameUrlInput
                                ]
                                []
                            , span [ class "input-group-btn" ]
                                [ button
                                    [ class "btn btn-default clipboard", onClick CopyUrl ]
                                    [ img [ src "/images/clippy.svg", alt "copy to clipboard", width 13 ] []
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
        else
            div [] []
