module I18n.En exposing (..)

import I18n.Translation exposing (..)


translate : Translation -> String
translate t =
    case t of
        WellDone name ->
            "Well done, " ++ name ++ "!"

        TryDifferentTheme ->
            "Try a different theme!"

        Players ->
            "Players"

        YourTurn name ->
            "Your turn, " ++ name ++ "!"

        You name ->
            "You, " ++ name

        PlayAgain ->
            "Play again"

        Accuracy value ->
            "Accuracy: " ++ (toString value) ++ "%"

        Scoreboard t ->
            case t of
                ThisGame ->
                    "This game:"

                ThisSet ->
                    "This set:"

        ShareThisUrl ->
            "Share this URL with your opponent(s):"

        ShareThisUrlRandom ->
            "There's nobody available :( Wait for a bit, or share this URL with anybody you want to play with:"

        StartGameWhenReady ->
            "You may start playing as soon as your opponent visits this URL"
