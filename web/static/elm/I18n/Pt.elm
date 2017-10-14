module I18n.Pt exposing (..)

import I18n.Translation exposing (..)


translate : Translation -> String
translate t =
    case t of
        WellDone name ->
            "Muito bem, " ++ name ++ "!"

        TryDifferentTheme ->
            "Experimente um tema diferente!"

        Players ->
            "Jogadores"

        YourTurn name ->
            "Sua vez, " ++ name ++ "!"

        You name ->
            "Você, " ++ name

        PlayAgain ->
            "Jogar novamente"

        Accuracy value ->
            "Percentual de acerto: " ++ (toString value) ++ "%"

        Score value ->
            "Score: " ++ (toString value)

        Scoreboard t ->
            case t of
                ThisGame ->
                    "Este jogo:"

                ThisSet ->
                    "Este conjunto:"

        ShareThisUrl ->
            "Compartilhe essa URL com seu(s) oponente(s):"

        ShareThisUrlRandom ->
            "As soon as there is another player available, we'll hook you up! If you don't want to wait, share this URL with anybody you want to play with:"

        StartGameWhenReady ->
            "Você pode começar a jogar assim que todos entrarem!"
