module Chat exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Json.Encode as JE
import Dict exposing (Dict)


type alias Message =
    { body : String
    }


type alias Params =
    { id : String
    , locale : String
    , host : String
    }


type alias Model =
    { id : String
    , locale : String
    , messages : List Message
    , message : String
    , phxSocket : Phoenix.Socket.Socket Msg
    }


type Msg
    = ReceiveMessage JE.Value
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | SendMessage
    | OnMessageInput String


main : Program Params Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Params -> ( Model, Cmd Msg )
init { id, locale, host } =
    let
        channel =
            Phoenix.Channel.init ("chat:" ++ id)
                |> Phoenix.Channel.withPayload (JE.object [])

        socketInit =
            Phoenix.Socket.init ("ws://" ++ host ++ "/socket/websocket")
                |> Phoenix.Socket.on "receive_message" ("chat:" ++ id) ReceiveMessage

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.join channel socketInit
    in
        { id = id
        , locale = locale
        , messages = []
        , message = ""
        , phxSocket = socketInit
        }
            ! [ Cmd.map PhoenixMsg phxCmd ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Phoenix.Socket.listen model.phxSocket PhoenixMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnMessageInput msg ->
            { model | message = msg } ! []

        SendMessage ->
            let
                push =
                    Phoenix.Push.init "new_msg" ("chat:" ++ model.id)
                        |> Phoenix.Push.withPayload (JE.object [ ( "body", JE.string model.message ) ])

                ( _, phxCmd ) =
                    Phoenix.Socket.push push model.phxSocket
            in
                model ! [ Cmd.map PhoenixMsg phxCmd ]

        ReceiveMessage raw ->
            let
                _ =
                    Debug.log "raw" raw
            in
                model ! []

        PhoenixMsg msg ->
            let
                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.update msg model.phxSocket
            in
                ( { model | phxSocket = phxSocket }
                , Cmd.map PhoenixMsg phxCmd
                )


view : Model -> Html Msg
view model =
    div [ class "chat" ]
        [ div [] [ strong [] [ text "Chat" ], a [ class "pull-right" ] [ text "ON" ] ]
        , div [ class "chat-history" ]
            [ messagesView model ]
        , div [ class "input-group" ]
            [ input [ class "form-control", onInput OnMessageInput ] []
            , span [ class "input-group-btn" ]
                [ button [ class "btn btn-default", onClick SendMessage ] [ text "send" ]
                ]
            ]
        ]


messagesView : Model -> Html Msg
messagesView model =
    div [] [ text "Messages" ]
