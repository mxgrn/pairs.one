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

        You name ->
            "Ты, " ++ name

        PlayAgain ->
            "Сыграть снова"

        Accuracy value ->
            "Точность: " ++ (toString value) ++ "%"

        Scoreboard t ->
            case t of
                ThisGame ->
                    "Последняя игра:"

                ThisSet ->
                    "Текущий матч:"
