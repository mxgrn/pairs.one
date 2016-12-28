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

        Scoreboard t ->
            case t of
                ThisGame ->
                    "Остання гра:"

                ThisSet ->
                    "Поточний матч:"

        ShareThisUrl ->
            "Поділись лінком з опонентом:"

        ShareThisUrlRandom ->
            "As soon as there is another player available, we'll hook you up! If you don't want to wait, share this URL with anybody you want to play with:"

        StartGameWhenReady ->
            "Гру можна почати відразу після того, як всі підключаться!"
