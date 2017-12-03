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
    let
        t =
            I18n.translate model.locale
    in
        if model.playerTurn == -1 then
            text ""
        else
            div [ class "chat-area hidden-xs" ]
                [ div [] [ strong [] [ text <| t <| Chat ] ]
                , div [ class "chat-history input-group" ]
                    (messagesView model)
                , div [ class "input-group" ]
                    [ input [ class "form-control", onInput OnInputMessage, onEnter SendMessage, value model.chatMessage ] []
                    , span [ class "input-group-btn" ]
                        [ button [ class "btn btn-default", onClick SendMessage ] [ span [ class "fa fa-paper-plane" ] [] ]
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

                playerName =
                    (Maybe.map
                        (\p ->
                            if p.name == "" then
                                "Player " ++ (toString <| 1 + playerTurn message.playerId model.game.players)
                            else
                                p.name
                        )
                        player
                    )
                        |> Maybe.withDefault ""

                html =
                    if message.playerId == model.playerId then
                        div [ class "chat-message--own" ] [ text message.body ]
                    else
                        div [ class "chat-message--foreign" ] [ strong [] [ text playerName ], text (": " ++ message.body) ]
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
