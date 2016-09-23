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
