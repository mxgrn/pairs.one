module ScoreboardView exposing (scoreboardView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import List.Extra


--

import I18n exposing (..)
import I18n.Translation exposing (..)
import Types.Model exposing (..)
import Types.Game exposing (..)
import Types.Player exposing (..)
import Types.Msg exposing (..)


{-| Either playerScore or playerTotalScore
-}
type alias ScoreCardFn =
    String -> Player -> Html Msg


scoreboardView : Model -> Html Msg
scoreboardView model =
    let
        t =
            I18n.translate model.locale
    in
        if (model.game.players |> List.length) == 1 then
            div [ class "scoreboard" ]
                [ h3 [ class "score-title" ] [ text <| t <| WellDone <| playerName <| model ]
                , accuracy model
                ]
        else
            div [ class "scoreboard" ]
                [ h3 [ class "score-title" ] [ text "Score" ]
                , div [ class "col-md-6" ]
                    [ h4 [] [ text <| t <| Scoreboard <| ThisGame ]
                    , subboard model playerScore .score
                    ]
                , div [ class "col-md-6" ]
                    [ h4 [] [ text <| t <| Scoreboard <| ThisSet ]
                    , subboard model playerTotalScore .totalScore
                    ]
                ]


accuracy : Model -> Html Msg
accuracy model =
    let
        t =
            I18n.translate model.locale

        turns =
            model.game.players |> List.map .turns |> List.sum

        inaccurateTurns =
            model.game.players |> List.map .inaccurateTurns |> List.sum

        accuracy =
            (toFloat turns - toFloat inaccurateTurns) / toFloat turns * 100 |> truncate
    in
        div [ class "row accuracy" ]
            [ div [ class "col-xs-6" ] [ h4 [] [ text <| t <| Accuracy accuracy ] ]
            ]


subboard : Model -> ScoreCardFn -> (Player -> Int) -> Html Msg
subboard model scoreCardFn scoreFn =
    div [ class "subboard clearfix" ]
        (playerGroupsData model.game scoreFn |> playerGroups scoreCardFn)


playerGroupsData : Game -> (Player -> Int) -> List (List Player)
playerGroupsData game scoreFn =
    game.players
        |> List.indexedMap
            (\i p ->
                { p
                    | name =
                        (if (String.isEmpty p.name) then
                            "Player " ++ (toString (i + 1))
                         else
                            p.name
                        )
                }
            )
        |> (List.sortBy scoreFn)
        |> List.reverse
        |> (List.Extra.groupWhile (\p1 p2 -> scoreFn (p1) == scoreFn (p2)))


playerGroups : ScoreCardFn -> List (List Player) -> List (Html Msg)
playerGroups scoreCardFn groups =
    let
        showTrophies =
            case List.length (groups) of
                1 ->
                    0

                2 ->
                    1

                _ ->
                    2
    in
        groups
            |> (List.indexedMap (playerGroup scoreCardFn showTrophies))
            |> List.concat


playerGroup : ScoreCardFn -> Int -> Int -> List Player -> List (Html Msg)
playerGroup scoreCardFn showTrophies index players =
    List.map (player scoreCardFn index (showTrophies > index)) players


player : ScoreCardFn -> Int -> Bool -> Player -> Html Msg
player scoreCardFn place showTrophy player =
    let
        trophyClasses =
            if showTrophy then
                case place of
                    0 ->
                        "fa-trophy trophy--gold"

                    1 ->
                        "fa-trophy trophy--silver"

                    _ ->
                        ""
            else
                ""
    in
        scoreCardFn trophyClasses player


playerTotalScore : String -> Player -> Html Msg
playerTotalScore trophyClasses player =
    div [ class "player row" ]
        [ div [ class "col-xs-1" ] [ i [ class ("fa " ++ trophyClasses) ] [] ]
        , div [ class "col-xs-6 score__player-name" ] [ div [] [ text player.name ] ]
        , div [ class "col-xs-2" ] [ div [] [ player.totalScore |> toString |> text ] ]
        ]


playerScore : String -> Player -> Html Msg
playerScore trophyClasses player =
    let
        accuracy =
            (toFloat player.turns - toFloat player.inaccurateTurns) / toFloat player.turns * 100 |> truncate
    in
        div [ class "player row" ]
            [ div [ class "col-xs-1" ] [ i [ class ("fa " ++ trophyClasses) ] [] ]
            , div [ class "col-xs-6 score__player-name" ] [ div [] [ text player.name ] ]
            , div [ class "col-xs-1" ] [ div [] [ player.score |> toString |> text ] ]
            , div [ class "col-xs-3 score__accuracy text-muted", title "Accuracy" ] [ div [] [ (toString accuracy ++ "%") |> text ] ]
            ]
