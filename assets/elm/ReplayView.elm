module ReplayView exposing (replayView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json


--

import Types.Model exposing (..)
import Types.Msg exposing (..)
import I18n exposing (..)
import I18n.Translation exposing (..)


-- submodules

import ThemeSelectorView exposing (..)


replayView : Model -> Html Msg
replayView model =
    let
        t =
            I18n.translate model.locale
    in
        div [ class "play-again" ]
            [ h3 [ class "score-title" ] [ text <| t <| TryDifferentTheme ]
            , themeSelectorView model
            , button [ class "btn btn-lg btn-primary btn-replay", onClick Replay ] [ text <| t <| PlayAgain ]
            ]
