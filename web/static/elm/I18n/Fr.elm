module I18n.Fr exposing (..)

import I18n.Translation exposing (..)


translate : Translation -> String
translate t =
    case t of
        WellDone name ->
            "Bien joué, " ++ name ++ " !"

        TryDifferentTheme ->
            "Essayez un thème différent !"

        Players ->
            "Joueurs"

        YourTurn name ->
            "C'est votre tour, " ++ name ++ " !"

        You name ->
            "Vous, " ++ name

        PlayAgain ->
            "Rejouer"

        Accuracy value ->
            "Justesse: " ++ (toString value) ++ "%"

        Scoreboard t ->
            case t of
                ThisGame ->
                    "Ce jeu :"

                ThisSet ->
                    "Cet ensemble :"

        ShareThisUrl ->
            "Partager cet URL avec votre/vos adversaire(s):"

        StartGameWhenReady ->
            "Vous pourrez jouer aussitôt que tout le monde sera présent !"
