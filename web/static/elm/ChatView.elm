module ChatView exposing (chatView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json


--

import Types.Model exposing (..)
import Types.Msg exposing (..)
import Types.Player exposing (..)
import Update exposing (..)
import I18n exposing (..)
import I18n.Translation exposing (..)


chatView : Model -> Html Msg
chatView model =
    if model.playerTurn == -1 then
        text ""
    else
        div [ class "chat-area" ]
            [ div [] [ strong [] [ text "Chat" ], a [ class "pull-right" ] [ text "ON" ] ]
            , div [ class "chat-history input-group" ]
                (messagesView model)
            , div [ class "input-group" ]
                [ input [ class "form-control", onInput OnInputMessage, onEnter SendMessage, value model.chatMessage ] []
                , span [ class "input-group-btn" ]
                    [ button [ class "btn btn-default", onClick SendMessage ] [ text "send" ]
                    ]
                ]
            ]


messagesView : Model -> List (Html Msg)
messagesView model =
    let
        messageView : ChatMessage -> Html Msg
        messageView message =
            let
                player =
                    playerBy message.playerId model.game.players

                html =
                    if message.playerId == model.playerId then
                        div [ class "chat-message--own" ] [ text message.body ]
                    else
                        div [ class "chat-message--foreign" ] [ strong [] [ Maybe.map .name player |> Maybe.withDefault "" |> text ], text (": " ++ message.body) ]
            in
                html
    in
        (model.chatMessages
            |> List.map messageView
        )


onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg
            else
                Json.fail "not ENTER"
    in
        on "keydown" (Json.andThen isEnter keyCode)
