port module GameSettings exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List.Extra
import Char exposing (..)
import Keyboard exposing (..)
import Json.Encode as JE
import I18n exposing (..)
import I18n.Translation exposing (..)


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
    | Local


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


main : Program Params Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Params -> ( Model, Cmd Msg )
init { csrf, locale, themes, theme, size, players, visibility } =
    let
        theme_ =
            -- List.head (themes) |> Maybe.withDefault defaultTheme
            List.Extra.find (\th -> th.name == theme) themes |> Maybe.withDefault defaultTheme
    in
        (Model
            csrf
            locale
            themes
            NullSelector
            theme_
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

                model_ =
                    { model | theme = theme, selector = NullSelector }
            in
                model_ ! [ saveSettings model_ ]

        SelectBoardSize size ->
            let
                model_ =
                    { model | boardSize = size, selector = NullSelector }
            in
                model_ ! [ saveSettings model_ ]

        SelectPlayers n ->
            let
                model_ =
                    { model | players = n, selector = NullSelector }
            in
                model_ ! [ saveSettings model_ ]

        SelectVisibility visibility ->
            let
                model_ =
                    { model | visibility = visibility, selector = NullSelector }
            in
                model_ ! [ saveSettings model_ ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.downs (\code -> Presses code)


modalSelector : Model -> Html Msg
modalSelector model =
    case model.selector of
        ThemeSelector ->
            modal <| themes model

        BoardSizeSelector ->
            modal <| boardSizes model

        PlayersSelector ->
            modal <| players model

        VisibilitySelector ->
            modal <| visibilities model

        NullSelector ->
            text ""


modal : Html Msg -> Html Msg
modal html =
    div []
        [ div [ class "pairs-modal-overlay", onClick CloseModal ]
            [ div [ class "pairs-modal-dialog" ] [ html ]
            ]
        ]


visibilities : Model -> Html Msg
visibilities model =
    let
        t =
            I18n.translate model.locale
    in
        div [ class "pairs-modal-content" ]
            [ h2 []
                [ text <| t <| SelectGameMode
                , modalCloseButton
                ]
            , h4 [] [ text <| t <| GameModeDescription ]
            , div [ class "row" ]
                [ div [ class "col-sm-8 col-sm-offset-2" ]
                    [ div [ class "btn btn-default btn-block btn-lg btn-stackable theme-easy", onClick <| SelectVisibility Public ] [ text <| t <| WillPlayWithStranger ]
                    ]
                ]
            , div [ class "row" ]
                [ div [ class "col-sm-8 col-sm-offset-2" ]
                    [ div [ class "btn btn-default btn-block btn-lg btn-stackable theme-medium", onClick <| SelectVisibility Private ] [ text <| t <| WillSelectOpponents ]
                    ]
                ]
            , div [ class "row" ]
                [ div [ class "col-sm-8 col-sm-offset-2" ]
                    [ div [ class "btn btn-default btn-block btn-lg btn-stackable", onClick <| SelectVisibility Local ] [ text <| t <| WillPlayLocally ]
                    ]
                ]
            ]


players : Model -> Html Msg
players model =
    let
        t =
            I18n.translate model.locale
    in
        div [ class "pairs-modal-content" ]
            [ h2 []
                [ text <| t <| SelectNumberOfPlayers
                , modalCloseButton
                ]
            , h4 [] [ text <| t <| NumberOfPlayersDescription ]
            , div [ class "row" ]
                (List.map
                    (\i ->
                        div [ class "col-xs-3" ]
                            [ div [ class <| "btn btn-default btn-block btn-lg btn-stackable " ++ (levelCls <| i - 2), onClick <| SelectPlayers i ] [ text <| toString <| i ]
                            ]
                    )
                    (List.range 1 4)
                )
            ]


view : Model -> Html Msg
view model =
    let
        t =
            I18n.translate model.locale
    in
        div [ class "new-game-selector" ]
            [ modalSelector model
            , div [ class "row game-settings-form" ]
                [ Html.form [ action <| "/" ++ model.locale ++ "/games", method "post" ]
                    [ input [ type_ "hidden", name "_csrf_token", value model.csrf ] []
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
                        [ div [ class "col-sm-4 col-sm-offset-4 centered-content" ]
                            [ button [ class "btn btn-default", type_ "submit" ] [ text <| t StartGame ]
                            ]
                        ]
                    ]
                ]
            ]


visibilityButton : Model -> Html Msg
visibilityButton model =
    let
        t =
            I18n.translate model.locale

        ( text_, cls ) =
            case model.visibility of
                Public ->
                    ( (t <| I18n.Translation.Public) ++ " ", levelCls 0 )

                Private ->
                    ( (t <| I18n.Translation.Private) ++ " ", levelCls 1 )

                Local ->
                    ( (t <| I18n.Translation.Local) ++ " ", levelCls 3 )
    in
        div []
            [ div [ class <| "btn btn-default btn-lg btn-game-setting " ++ cls, onClick ShowVisibilitySelector ]
                [ span []
                    [ text text_
                    ]
                , i [ class "fa fa-caret-down" ]
                    []
                ]
            , input [ type_ "hidden", name "game[visibility]", value <| visibilityToString model.visibility ] []
            ]


playersButton : Model -> Html Msg
playersButton model =
    let
        t =
            I18n.translate model.locale
    in
        div []
            [ div [ class <| "btn btn-default btn-lg btn-game-setting " ++ (levelCls <| model.players - 2), onClick ShowPlayersSelector ]
                [ span []
                    [ text <| (t Players) ++ ": " ]
                , span [ class "boardsize-icon" ]
                    [ text <| toString model.players, text " " ]
                , i [ class "fa fa-caret-down" ]
                    []
                ]
            , input [ type_ "hidden", name "game[players_number]", value <| toString model.players ] []
            ]


boardSizeButton : Model -> Html Msg
boardSizeButton model =
    let
        t =
            I18n.translate model.locale
    in
        div []
            [ div [ class <| "btn btn-default btn-lg btn-game-setting " ++ (levelCls <| (floor <| (toFloat model.boardSize) / 2 - 2)), onClick ShowBoardSizeSelector ]
                [ span []
                    [ text <| (t Size) ++ ": " ]
                , span [ class "boardsize-icon" ]
                    [ text (toString model.boardSize ++ "x" ++ toString model.boardSize), text " " ]
                , i [ class "fa fa-caret-down" ]
                    []
                ]
            , input [ type_ "hidden", name "game[board_size]", value <| toString model.boardSize ] []
            ]


themeButton : Model -> Html Msg
themeButton model =
    let
        t =
            I18n.translate model.locale
    in
        div []
            [ div [ class <| "btn btn-default btn-lg btn-game-setting " ++ (levelCls model.theme.difficulty), onClick ShowThemeSelector ]
                [ img [ class "theme-icon", src <| "/images/" ++ model.theme.name ++ "/1.svg" ]
                    []
                , i [ class "fa fa-caret-down" ]
                    []
                ]
            , input [ type_ "hidden", name "game[theme]", value model.theme.name ] []
            ]


themes : Model -> Html Msg
themes model =
    let
        t =
            I18n.translate model.locale
    in
        div [ class "pairs-modal-content" ]
            ([ h2 []
                [ text <| t PickTheme
                , modalCloseButton
                ]
             , h4 [ class "level-legend" ]
                [ text <| (t Difficulty) ++ ": "
                , span [ class "level-legend__block theme-easy" ] []
                , text <| " " ++ t DifficultyEasy
                , span [ class "level-legend__block theme-medium" ] []
                , text <| " " ++ t DifficultyMedium
                , span [ class "level-legend__block theme-hard" ] []
                , text <| " " ++ t DifficultyHard
                ]
             , div [ class "theme-list" ] (List.map themeView model.themes)
             ]
            )


boardSizes : Model -> Html Msg
boardSizes model =
    let
        t =
            I18n.translate model.locale
    in
        div [ class "pairs-modal-content" ]
            [ h2 []
                [ text <| t I18n.Translation.SelectBoardSize
                , modalCloseButton
                ]
            , h4 [] [ text <| t SelectBoardSizeDescription ]
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

        "local" ->
            Local

        _ ->
            Public


visibilityToString : Visibility -> String
visibilityToString value =
    case value of
        Public ->
            "public"

        Private ->
            "private"

        Local ->
            "local"


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
