module GameList exposing (..)

-- Dependencies

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket
import String
import Phoenix.Socket
import Phoenix.Channel
import Json.Encode as JE
import Json.Decode as JD exposing (field)
import Dict exposing (Dict)


-- Submodules


type Msg
    = Update JE.Value
    | PhoenixMsg (Phoenix.Socket.Msg Msg)


type alias Params =
    { host : String
    , locale : String
    }


type alias GameId =
    String


type alias Game =
    { id : GameId
    , theme : String
    , size : String
    , players : List Player
    }


type alias Player =
    { name : String }


type alias UpdateData =
    { games : List Game }


type alias Model =
    { locale : String
    , pendingGames : List Game
    , activeGames : List Game
    , phxSocket : Phoenix.Socket.Socket Msg
    }


main : Program Params Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Phoenix.Socket.listen model.phxSocket PhoenixMsg
        ]


init : Params -> ( Model, Cmd Msg )
init { locale, host } =
    let
        payload =
            JE.object []

        channel =
            Phoenix.Channel.init "game-list"
                |> Phoenix.Channel.withPayload payload

        socketInit =
            Phoenix.Socket.init ("wss://" ++ host ++ "/socket/websocket")
                |> Phoenix.Socket.on "update" "game-list" Update

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.join channel socketInit
    in
        ( { locale = locale, pendingGames = [], activeGames = [], phxSocket = socketInit }, Cmd.map PhoenixMsg phxCmd )


view : Model -> Html Msg
view model =
    div []
        [ div [ class "clearfix" ] (games model)
        ]


games : Model -> List (Html Msg)
games model =
    if List.isEmpty model.pendingGames then
        [ h4 [ style [ ( "text-align", "center" ) ] ] [ img [ src "/images/loading.gif", width 40 ] [] ] ]
    else
        model.pendingGames
            |> List.map
                (\game ->
                    a [ class "game-list__game", href <| "/" ++ model.locale ++ "/games/" ++ game.id ]
                        [ div
                            [ class "game__visual" ]
                            [ img [ src <| "/images/" ++ game.theme ++ "/1.svg" ] []
                            , div []
                                [ strong [] [ text game.size ]
                                ]
                            ]
                        , div [ class "game__players" ] (players game.players)
                        ]
                )


playerHtml : Int -> Player -> Html Msg
playerHtml i player =
    let
        _ =
            Debug.log "player" player

        ( cls, txt ) =
            if player.name == "" then
                ( "game-list__player game-list__player--waiting", "-----" )
            else
                ( "game-list__player", player.name )
    in
        div [ class cls ]
            [ span [ class "player-name" ] [ text <| (toString <| i + 1) ++ ". " ++ txt ]
            ]


players : List Player -> List (Html Msg)
players players_ =
    List.indexedMap playerHtml players_


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update raw ->
            case JD.decodeValue updateDecoder raw of
                Ok updateData ->
                    { model | pendingGames = updateData.games } ! []

                Err error ->
                    decoderError model error

        PhoenixMsg msg ->
            let
                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.update msg model.phxSocket
            in
                ( { model | phxSocket = phxSocket }
                , Cmd.map PhoenixMsg phxCmd
                )


updateDecoder : JD.Decoder UpdateData
updateDecoder =
    JD.map UpdateData
        (field "games" (JD.list gameDecoder))


gameDecoder : JD.Decoder Game
gameDecoder =
    JD.map4 Game
        (field "id" JD.string)
        (field "theme" JD.string)
        (field "size" JD.string)
        (field "players" (JD.list playerDecoder))


playerDecoder : JD.Decoder Player
playerDecoder =
    JD.map Player
        (field "name" JD.string)


decoderError : Model -> String -> ( Model, Cmd Msg )
decoderError model error =
    let
        _ =
            Debug.log "Decoder error" error
    in
        ( model, Cmd.none )
