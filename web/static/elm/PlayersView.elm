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

        html =
            [ (div [ class "row" ]
                [ div [ class "col-sm-12" ]
                    [ div
                        [ classList
                            [ ( "turn-banner", True )
                            , ( "turn-banner--your-turn", model.game.turn == model.playerTurn )
                            ]
                        ]
                        [ text <| t <| YourTurn <| playerName model ]
                    ]
                ]
              )
            ]
    in
        div [ class "players-bar col-md-3 col-lg-4" ]
            ((h4 [ class "player-list-header" ] [ text <| t <| Players ])
                :: (List.map (player model) [0..(List.length model.game.players - 1)])
                ++ html
            )


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

                    name' =
                        if model.playerId == player.id then
                            t <| You <| name
                        else
                            name

                    accuracy =
                        (toFloat player.turns - toFloat player.inaccurateTurns) / toFloat player.turns * 100 |> truncate
                in
                    case player.joined of
                        False ->
                            pendingPlayer name'

                        True ->
                            let
                                playerNameHtml =
                                    div
                                        [ class "col-xs-8 player__name" ]
                                        [ text name' ]
                            in
                                div
                                    [ classList
                                        [ ( "active", index == model.game.turn )
                                        , ( "player-turn", index == model.playerTurn )
                                        , ( "row", True )
                                        ]
                                    ]
                                    [ playerNameHtml
                                    , div [ class "col-xs-2 score__accuracy" ]
                                        [ text (toString accuracy ++ "%") ]
                                    , div [ class "col-xs-2 player__score" ]
                                        [ text (player.score |> toString)
                                        ]
                                    ]

            Nothing ->
                text "Should never happen"


pendingPlayer : String -> Html Msg
pendingPlayer name =
    div
        [ class "not-joined row"
        ]
        [ div [ class "col-xs-6 player__name" ]
            [ text name
            ]
        , div [ class "col-xs-6 player__score" ]
            [ text "(waiting)" ]
        ]
