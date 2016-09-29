module I18n.En exposing (..)
module I18n.En exposing (..)

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

        Scoreboard t ->
            case t of
                ThisGame ->
                    "Este jogo:"

                ThisSet ->
                    "Este conjunto:"

        ShareThisUrl ->
            "Compartilhe essa URL com seu(s) oponente(s):"

        StartGameWhenReady ->
            "Você pode começar a jogar assim que todos entrarem!"
