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

        Score value ->
            "Score: " ++ (toString value)

        Scoreboard t ->
            case t of
                ThisGame ->
                    "This game:"

                ThisSet ->
                    "This set:"

        ShareThisUrl ->
            "Share this URL with your opponent(s):"

        ShareThisUrlRandom ->
            "We are looking for an opponent for you! Give us a second, or share this URL with anyone who might want to play with you right now:"
