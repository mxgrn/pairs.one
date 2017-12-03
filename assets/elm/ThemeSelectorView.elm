module ThemeSelectorView exposing (themeSelectorView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json


--

import Types.Model exposing (..)
import Types.Theme exposing (..)
import Types.Msg exposing (..)


themeSelectorView : Model -> Html Msg
themeSelectorView model =
    div [ class "theme-selector" ]
        (List.map (themeButton model.game.theme) model.themes)


themeButton : String -> Theme -> Html Msg
themeButton activeTheme theme =
    let
        activeClass =
            if theme.name == activeTheme then
                " active"
            else
                ""

        newBadgeText =
            if theme.new then
                " New"
            else
                ""
    in
        label [ class <| "btn btn-default btn-theme " ++ (levelCls theme.difficulty) ++ activeClass, onClick <| ChangeTheme theme.name ]
            [ img [ src <| "/images/" ++ theme.name ++ "/1.svg", width 50, height 50 ] []
            , div [ class "theme-title" ]
                [ text theme.title
                , sup [ class "text-danger" ] [ text newBadgeText ]
                ]
            ]


levelCls : Int -> String
levelCls level =
    case level of
        0 ->
            "theme-easy"

        1 ->
            "theme-medium"

        2 ->
            "theme-hard"

        _ ->
            ""
