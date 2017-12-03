module I18n.Ru exposing (..)

import I18n.Translation exposing (..)


translate : Translation -> String
translate t =
    case t of
        WellDone name ->
            "Отлично, " ++ name ++ "!"

        TryDifferentTheme ->
            "Попробуй другие картинки!"

        Players ->
            "Игроки"

        YourTurn name ->
            "Твой ход, " ++ name ++ "!"

        YourName ->
            "Твое имя"

        Chat ->
            "Чат"

        You name ->
            "Ты, " ++ name

        PlayAgain ->
            "Сыграть снова"

        Accuracy value ->
            "Точность: " ++ (toString value) ++ "%"

        Score value ->
            "Счет: " ++ (toString value)

        Scoreboard t ->
            case t of
                ThisGame ->
                    "Последняя игра:"

                ThisSet ->
                    "Текущий матч:"

        ShareThisUrl ->
            "Поделись этой ссылкой с оппонентом:"

        ShareThisUrlRandom ->
            "Мы подыскиваем тебе оппонента! Дай нам минуту - либо поделись вот этой ссылкой с тем, кто непротив сыграть с тобой прямо сейчас:"

        Theme ->
            "Тема"

        Size ->
            "Размер"

        Public ->
            "В открытую"

        Private ->
            "Частная"

        Local ->
            "Локальная"

        PickTheme ->
            "Выбери тему"

        Difficulty ->
            "Сложность"

        DifficultyEasy ->
            "низкая"

        DifficultyMedium ->
            "средняя"

        DifficultyHard ->
            "высокая"

        SelectGameMode ->
            "С кем ты хочешь сыграть?"

        GameModeDescription ->
            "В 'открытой' игре к тебе может присоединиться случайны игрок, зашедший на сайт. Если ты хочешь играть только с теми, кому ты отошлешь линк - выбери 'частная'. Если ты хочешь сыграть с другом на одном устройстве, выбери 'локальная'."

        WillPlayWithStranger ->
            "Сыграю с незнакомцем (открытая)"

        WillSelectOpponents ->
            "Приглашу оппонента (частная)"

        WillPlayLocally ->
            "Сыграем локальную игру"

        SelectNumberOfPlayers ->
            "Выбери число игроков"

        NumberOfPlayersDescription ->
            "Если ты выберешь 1, ты сможешь играть соло. Но намного интереснее играть с кем-то через Интернет!"

        SelectBoardSize ->
            "Выбери размер поля"

        SelectBoardSizeDescription ->
            "Чем больше поле - тем больше будет карточек для запоминания"

        StartGame ->
            "Начать игру"

        Waiting ->
            "Ждем"
