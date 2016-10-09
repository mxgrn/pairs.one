module GameList exposing (..)

-- Dependencies

import Html.App
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket
import String
import Phoenix.Socket
import Phoenix.Channel
import Json.Encode as JE
import Json.Decode as JD exposing ((:=))
import Dict exposing (Dict)


-- Submodules


type Msg
    = AddGame JE.Value
    | RemoveGame JE.Value
    | ListGames JE.Value
    | AddActiveGame JE.Value
    | RemoveActiveGame JE.Value
    | ListActiveGames JE.Value
    | Update JE.Value
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
    { pendingGames : List Game
    , activeGames : List Game
    , phxSocket : Phoenix.Socket.Socket Msg
    }


main : Program (Params)
main =
    Html.App.programWithFlags
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
init { host } =
    let
        payload =
            JE.object []

        channel =
            Phoenix.Channel.init "game-list"
                |> Phoenix.Channel.withPayload payload

        socketInit =
            Phoenix.Socket.init ("ws://" ++ host ++ "/socket/websocket")
                |> Phoenix.Socket.on "list_games" "game-list" ListGames
                |> Phoenix.Socket.on "add_game" "game-list" AddGame
                |> Phoenix.Socket.on "remove_game" "game-list" RemoveGame
                |> Phoenix.Socket.on "list_active_games" "game-list" ListActiveGames
                |> Phoenix.Socket.on "add_active_game" "game-list" AddActiveGame
                |> Phoenix.Socket.on "remove_active_game" "game-list" RemoveActiveGame
                |> Phoenix.Socket.on "update" "game-list" Update

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.join channel socketInit
    in
        ( { pendingGames = [], activeGames = [], phxSocket = socketInit }, Cmd.map PhoenixMsg phxCmd )


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Игры, ожидающие твоего участия" ]
        , div [ class "clearfix" ] (games model.pendingGames)
        ]


games : List Game -> List (Html Msg)
games games' =
    games'
        |> List.map
            (\game ->
                div [ class "game-list__game" ]
                    ([ div [ class "game__visual" ]
                        [ img [ src "/images/animals/1.svg" ] []
                        , div []
                            [ strong [] [ text game.size ]
                            ]
                        ]
                     ]
                        ++ players (game.players)
                        ++ [ br [] []
                           , text game.id
                           ]
                    )
            )


players : List Player -> List (Html Msg)
players players' =
    List.concatMap
        (\p ->
            [ span [ class "fa fa-user player-icon" ] []
            , span [ class "player-name" ] [ text p.name ]
            ]
        )
        players'


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update raw ->
            let
                _ =
                    Debug.log "raw" raw
            in
                case JD.decodeValue updateDecoder raw of
                    Ok updateData ->
                        { model | pendingGames = updateData.games } ! []

                    Err error ->
                        decoderError model error

        ListActiveGames raw ->
            case JD.decodeValue updateDecoder raw of
                Ok update ->
                    { model | activeGames = update.games } ! []

                Err error ->
                    decoderError model error

        ListGames raw ->
            case JD.decodeValue updateDecoder raw of
                Ok update ->
                    { model | pendingGames = update.games } ! []

                Err error ->
                    decoderError model error

        AddGame raw ->
            case JD.decodeValue gameDecoder raw of
                Ok game ->
                    let
                        games =
                            game :: model.pendingGames
                    in
                        { model | pendingGames = games } ! []

                Err error ->
                    decoderError model error

        RemoveGame raw ->
            case JD.decodeValue gameDecoder raw of
                Ok game ->
                    let
                        games =
                            List.filter
                                (\g -> g.id /= game.id)
                                model.pendingGames
                    in
                        { model | pendingGames = games } ! []

                Err error ->
                    decoderError model error

        AddActiveGame raw ->
            case JD.decodeValue gameDecoder raw of
                Ok game ->
                    let
                        games =
                            game :: model.activeGames
                    in
                        { model | activeGames = games } ! []

                Err error ->
                    decoderError model error

        RemoveActiveGame raw ->
            case JD.decodeValue gameDecoder raw of
                Ok game ->
                    let
                        games =
                            List.filter
                                (\g -> g.id /= game.id)
                                model.activeGames
                    in
                        { model | activeGames = games } ! []

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
    JD.object1 UpdateData
        ("games" := JD.list gameDecoder)


gameDecoder : JD.Decoder Game
gameDecoder =
    JD.object4 Game
        ("id" := JD.string)
        ("theme" := JD.string)
        ("size" := JD.string)
        ("players" := JD.list playerDecoder)


playerDecoder : JD.Decoder Player
playerDecoder =
    JD.object1 Player
        ("name" := JD.string)


decoderError : Model -> String -> ( Model, Cmd Msg )
decoderError model error =
    let
        _ =
            Debug.log "Decoder error" error
    in
        ( model, Cmd.none )
