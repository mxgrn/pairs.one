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
themeButton activeTheme { name, title, difficulty, new } =
    let
        activeClass =
            if name == activeTheme then
                " active"
            else
                ""
    in
        label [ class ("btn btn-default btn-theme" ++ activeClass), onMouseDown (ChangeTheme name) ]
            [ img [ src ("/images/" ++ name ++ "/1.svg"), width 50, height 50 ] []
            , div [ class "theme-title" ] [ text title ]
            ]
