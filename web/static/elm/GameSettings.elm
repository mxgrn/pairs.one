port module GameSettings exposing (..)

import Html.App
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List.Extra
import Char exposing (..)
import Keyboard exposing (..)
import Json.Encode as JE


--

import Types.Theme exposing (..)


port saveSettingsToLocalStorage : JE.Value -> Cmd msg


type alias ThemeName =
    String


type alias Params =
    { csrf : String
    , locale : String
    , themes : List Theme
    , theme : ThemeName
    , size : Int
    , players : Int
    , visibility : String
    }


type Visibility
    = Public
    | Private


type Selector
    = ThemeSelector
    | BoardSizeSelector
    | PlayersSelector
    | VisibilitySelector
    | NullSelector


type Msg
    = ShowThemeSelector
    | ShowBoardSizeSelector
    | ShowPlayersSelector
    | ShowVisibilitySelector
    | SelectTheme ThemeName
    | SelectBoardSize Int
    | SelectPlayers Int
    | SelectVisibility Visibility
    | CloseModal
    | Presses Int


type alias Model =
    { csrf : String
    , locale : String
    , themes : List Theme
    , selector : Selector
    , theme : Theme
    , boardSize : Int
    , players : Int
    , visibility : Visibility
    }


main : Program (Params)
main =
    Html.App.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Params -> ( Model, Cmd Msg )
init { csrf, locale, themes, theme, size, players, visibility } =
    let
        theme' =
            -- List.head (themes) |> Maybe.withDefault defaultTheme
            List.Extra.find (\th -> th.name == theme) themes |> Maybe.withDefault defaultTheme
    in
        (Model
            csrf
            locale
            themes
            NullSelector
            theme'
            size
            players
            (visibilityFromString visibility)
        )
            ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Presses code ->
            if code == 27 then
                update CloseModal model
            else
                model ! []

        ShowThemeSelector ->
            { model | selector = ThemeSelector } ! []

        ShowBoardSizeSelector ->
            { model | selector = BoardSizeSelector } ! []

        ShowPlayersSelector ->
            { model | selector = PlayersSelector } ! []

        ShowVisibilitySelector ->
            { model | selector = VisibilitySelector } ! []

        CloseModal ->
            { model | selector = NullSelector } ! []

        SelectTheme name ->
            let
                theme =
                    List.Extra.find (\th -> th.name == name) model.themes |> Maybe.withDefault defaultTheme
            in
                { model | theme = theme, selector = NullSelector } ! [ saveSettings model ]

        SelectBoardSize size ->
            { model | boardSize = size, selector = NullSelector } ! [ saveSettings model ]

        SelectPlayers n ->
            { model | players = n, selector = NullSelector } ! [ saveSettings model ]

        SelectVisibility visibility ->
            { model | visibility = visibility, selector = NullSelector } ! [ saveSettings model ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.downs (\code -> Presses code)


modalSelector : Model -> Html Msg
modalSelector model =
    case model.selector of
        ThemeSelector ->
            modal <| themes model

        BoardSizeSelector ->
            modal boardSizes

        PlayersSelector ->
            modal players

        VisibilitySelector ->
            modal visibilities

        NullSelector ->
            text ""


modal : Html Msg -> Html Msg
modal html =
    div []
        [ div [ class "pairs-modal-overlay", onClick CloseModal ]
            [ div [ class "pairs-modal-dialog" ] [ html ]
            ]
        ]


visibilities : Html Msg
visibilities =
    div [ class "pairs-modal-content" ]
        [ h2 []
            [ text "Would you like to play with random users?"
            , modalCloseButton
            ]
        , h4 [] [ text "In a 'public' game, someone may join you when choosing a random player to play with. If you want to only play with someone that you'll send the link to the game to - choose 'private'." ]
        , div [ class "row" ]
            [ div [ class "col-sm-8 col-sm-offset-2" ]
                [ div [ class "btn btn-default btn-block btn-lg btn-stackable theme-easy", onClick <| SelectVisibility Public ] [ text "Yes, I'd like someone to join me!" ]
                ]
            ]
        , div [ class "row" ]
            [ div [ class "col-sm-8 col-sm-offset-2" ]
                [ div [ class "btn btn-default btn-block btn-lg btn-stackable theme-medium", onClick <| SelectVisibility Private ] [ text "No, I'll invite my opponents myself" ]
                ]
            ]
        ]


players : Html Msg
players =
    div [ class "pairs-modal-content" ]
        [ h2 []
            [ text "Pick number of players"
            , modalCloseButton
            ]
        , h4 [] [ text "If you select 1, you'll be able to play alone. However, it's much more fun to play with someone over the Internet!" ]
        , div [ class "row" ]
            (List.map
                (\i ->
                    div [ class "col-xs-3" ]
                        [ div [ class <| "btn btn-default btn-block btn-lg btn-stackable " ++ (levelCls <| i - 2), onClick <| SelectPlayers i ] [ text <| toString <| i ]
                        ]
                )
                [1..4]
            )
        ]


view : Model -> Html Msg
view model =
    div [ class "new-game-selector" ]
        [ modalSelector model
        , div [ class "row game-settings-form" ]
            [ Html.form [ action <| "/" ++ model.locale ++ "/games", method "post" ]
                [ input [ type' "hidden", name "_csrf_token", value model.csrf ] []
                , div [ class "row" ]
                    [ div [ class "col-sm-3" ]
                        [ themeButton model
                        ]
                    , div [ class "col-sm-3" ]
                        [ boardSizeButton model
                        ]
                    , div [ class "col-sm-3" ]
                        [ playersButton model
                        ]
                    , div [ class "col-sm-3" ]
                        [ visibilityButton model
                        ]
                    ]
                , div [ class "row btn-go-wrapper" ]
                    [ div [ class "col-sm-4 col-sm-offset-4" ]
                        [ button [ class "btn btn-lg btn-primary btn-go", type' "submit" ] [ text "Start ", strong [] [ text "new" ], text " game" ]
                        ]
                    ]
                ]
            ]
        ]


visibilityButton : Model -> Html Msg
visibilityButton model =
    let
        ( text', cls ) =
            case model.visibility of
                Public ->
                    ( "Public ", levelCls 0 )

                Private ->
                    ( "Private ", levelCls 1 )
    in
        div []
            [ div [ class <| "btn btn-default btn-lg btn-game-setting " ++ cls, onClick ShowVisibilitySelector ]
                [ span []
                    [ text text'
                    ]
                , i [ class "fa fa-caret-down" ]
                    []
                ]
            , input [ type' "hidden", name "game[visibility]", value <| visibilityToString model.visibility ] []
            ]


playersButton : Model -> Html Msg
playersButton model =
    div []
        [ div [ class <| "btn btn-default btn-lg btn-game-setting " ++ (levelCls <| model.players - 2), onClick ShowPlayersSelector ]
            [ span []
                [ text "Players: " ]
            , span [ class "boardsize-icon" ]
                [ text <| toString model.players ]
            , i [ class "fa fa-caret-down" ]
                []
            ]
        , input [ type' "hidden", name "game[players_number]", value <| toString model.players ] []
        ]


boardSizeButton : Model -> Html Msg
boardSizeButton model =
    div []
        [ div [ class <| "btn btn-default btn-lg btn-game-setting " ++ (levelCls <| (floor <| (toFloat model.boardSize) / 2 - 2)), onClick ShowBoardSizeSelector ]
            [ span []
                [ text "Size: " ]
            , span [ class "boardsize-icon" ]
                [ text (toString model.boardSize ++ "x" ++ toString model.boardSize) ]
            , i [ class "fa fa-caret-down" ]
                []
            ]
        , input [ type' "hidden", name "game[board_size]", value <| toString model.boardSize ] []
        ]


themeButton : Model -> Html Msg
themeButton model =
    div []
        [ div [ class <| "btn btn-default btn-lg btn-game-setting " ++ (levelCls model.theme.difficulty), onClick ShowThemeSelector ]
            [ span []
                [ text "Theme: " ]
            , img [ class "theme-icon", src <| "/images/" ++ model.theme.name ++ "/1.svg" ]
                []
            , i [ class "fa fa-caret-down" ]
                []
            ]
        , input [ type' "hidden", name "game[theme]", value model.theme.name ] []
        ]


themes : Model -> Html Msg
themes model =
    div [ class "pairs-modal-content" ]
        ([ h2 []
            [ text "Pick a theme"
            , modalCloseButton
            ]
         , h4 [ class "level-legend" ]
            [ text "Difficulty:"
            , span [ class "level-legend__block theme-easy" ] []
            , text " - easy"
            , span [ class "level-legend__block theme-medium" ] []
            , text " - medium"
            , span [ class "level-legend__block theme-hard" ] []
            , text " - hard"
            ]
         ]
            ++ (List.map
                    themeView
                    model.themes
               )
        )


boardSizes : Html Msg
boardSizes =
    div [ class "pairs-modal-content" ]
        [ h2 []
            [ text "Select the size"
            , modalCloseButton
            ]
        , h4 [] [ text "The bigger the board - the more cards will there be to remember" ]
        , div [ class "row" ]
            [ div [ class "col-sm-4" ]
                [ div [ class "btn btn-default btn-block btn-lg btn-stackable theme-easy", onClick <| SelectBoardSize 4 ] [ text "4x4" ]
                ]
            , div [ class "col-sm-4" ]
                [ div [ class "btn btn-default btn-block btn-lg btn-stackable theme-medium", onClick <| SelectBoardSize 6 ] [ text "6x6" ]
                ]
            , div [ class "col-sm-4" ]
                [ div [ class "btn btn-default btn-block btn-lg btn-stackable theme-hard", onClick <| SelectBoardSize 8 ] [ text "8x8" ]
                ]
            ]
        ]


modalCloseButton : Html Msg
modalCloseButton =
    div
        [ class "modal__close pull-right"
        , onClick CloseModal
        ]
        [ i [ class "fa fa-close" ] []
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


themeView : Theme -> Html Msg
themeView theme =
    let
        newBadgeText =
            if theme.new then
                " New"
            else
                ""
    in
        label [ class <| "btn btn-default btn-theme " ++ (levelCls theme.difficulty), onClick <| SelectTheme theme.name ]
            [ img [ src <| "/images/" ++ theme.name ++ "/1.svg", width 50, height 50 ] []
            , div [ class "theme-title" ]
                [ text theme.title
                , sup [ class "text-danger" ] [ text newBadgeText ]
                ]
            ]


visibilityFromString : String -> Visibility
visibilityFromString str =
    case str of
        "public" ->
            Public

        "private" ->
            Private

        _ ->
            Public


visibilityToString : Visibility -> String
visibilityToString value =
    case value of
        Public ->
            "public"

        Private ->
            "private"


saveSettings : Model -> Cmd msg
saveSettings model =
    saveSettingsToLocalStorage <| settingsObject model


settingsObject : Model -> JE.Value
settingsObject model =
    (JE.object
        [ ( "theme", JE.string model.theme.name )
        , ( "size", JE.int model.boardSize )
        , ( "players", JE.int model.players )
        , ( "visibility", JE.string <| visibilityToString model.visibility )
        ]
    )
