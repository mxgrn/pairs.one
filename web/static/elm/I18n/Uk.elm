module I18n.Uk exposing (..)

import I18n.Translation exposing (..)


translate : Translation -> String
translate t =
    case t of
        WellDone name ->
            "Чудово, " ++ name ++ "!"

        TryDifferentTheme ->
            "Спробуй інші зображення!"

        Players ->
            "Гравці"

        YourTurn name ->
            "Твій хід, " ++ name ++ "!"

        You name ->
            "Ти, " ++ name

        PlayAgain ->
            "Зіграти знову"

        Accuracy value ->
            "Точність: " ++ (toString value) ++ "%"

        Score value ->
            "Score: " ++ (toString value)

        Scoreboard t ->
            case t of
                ThisGame ->
                    "Остання гра:"

                ThisSet ->
                    "Поточний матч:"

        ShareThisUrl ->
            "Поділись лінком з опонентом:"

        ShareThisUrlRandom ->
            "We are looking for an opponent for you! Give us a second, or share this URL with anyone who might want to play with you right now:"
