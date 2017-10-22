module PlayersView exposing (playersView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import String


--

import Types.Model exposing (..)
import Types.Msg exposing (..)
import I18n exposing (..)
import I18n.Translation exposing (..)


playersView : Model -> Html Msg
playersView model =
    let
        t =
            I18n.translate model.locale
    in
        div [ class "players-bar" ]
            (List.map (player model) (List.range 0 (List.length model.game.players - 1)))


player : Model -> Int -> Html Msg
player model index =
    let
        player =
            model.game.players |> List.drop (index) |> List.head

        t =
            I18n.translate model.locale
    in
        case player of
            Just player ->
                let
                    name =
                        if String.isEmpty (player.name) then
                            "Player " ++ toString (index + 1)
                        else
                            player.name

                    name_ =
                        if model.playerId == player.id then
                            t <| You <| name
                        else
                            name

                    accuracy =
                        if player.turns == 0 then
                            100
                        else
                            (toFloat player.turns - toFloat player.inaccurateTurns) / toFloat player.turns * 100 |> truncate

                    isMultiplayer =
                        (List.length model.game.players) > 1
                in
                    case player.joined of
                        False ->
                            pendingPlayer model name_

                        True ->
                            let
                                playerNameHtml =
                                    if isMultiplayer then
                                        div
                                            [ class "player__name" ]
                                            [ text name_ ]
                                    else
                                        text ""
                            in
                                div
                                    [ classList
                                        [ ( "active", index == model.game.turn && player.online && isMultiplayer )
                                        , ( "player", True )
                                        , ( "player-turn", index == model.playerTurn && isMultiplayer )
                                        , ( "offline", not player.online )
                                        , ( "multiplayer", isMultiplayer )
                                        ]
                                    ]
                                    [ playerNameHtml
                                    , div [ class "row player-score" ]
                                        [ div [ class "col-xs-6 player__score" ]
                                            [ text <| t <| Score player.score ]
                                        , div [ class "col-xs-6 score__accuracy" ]
                                            [ text <| t <| Accuracy accuracy ]
                                        ]
                                    ]

            Nothing ->
                text "Should never happen"


pendingPlayer : Model -> String -> Html Msg
pendingPlayer model name =
    let
        t =
            I18n.translate model.locale
    in
        div [ class "player multiplayer not-joined" ]
            [ div [ class "player__name" ]
                [ text name
                ]
            , div [ class "row player-score" ]
                [ div [ class "col-xs-6 player__score" ] [ text <| t <| Waiting, text "..." ]
                ]
            ]
