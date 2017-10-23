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

        YourName ->
            "Your name"

        Chat ->
            "Chat"

        You name ->
            "Vous, " ++ name

        PlayAgain ->
            "Rejouer"

        Accuracy value ->
            "Justesse: " ++ (toString value) ++ "%"

        Score value ->
            "Score: " ++ (toString value)

        Scoreboard t ->
            case t of
                ThisGame ->
                    "Ce jeu :"

                ThisSet ->
                    "Cet ensemble :"

        ShareThisUrl ->
            "Partager cet URL avec votre/vos adversaire(s):"

        ShareThisUrlRandom ->
            "Vous cherchez un adversaire! Donnez-nous une seconde, ou bien partagez cet URL avec quelqu'un qui voudrait jouer avec vous maintenant :"

        Theme ->
            "Thème"

        Size ->
            "Taille"

        Public ->
            "Public"

        Private ->
            "Privé"

        Local ->
            "Local"

        PickTheme ->
            "Choisissez un thème"

        Difficulty ->
            "Difficulté"

        DifficultyEasy ->
            "facile"

        DifficultyMedium ->
            "normal"

        DifficultyHard ->
            "difficile"

        SelectGameMode ->
            "Avec qui souhaitez-vous jouer ?"

        GameModeDescription ->
            "Dans une partie de type 'public', un joueur choisi aléatoirement pourrait vous rejoindre. Si vous souhaitez jouer avec quelqu'un à qui vous enverrez le lien - choisissez 'privé'. Si vous avez un ami à côté de vous et que vous souhaitez partager le même ordinateur, choisissez 'local'."

        WillPlayWithStranger ->
            "Je souhaite qu'un inconnu rejoigne la partie !"

        WillSelectOpponents ->
            "J'invite mon adversaire moi-même"

        WillPlayLocally ->
            "Je souhaite jouer avec quelqu'un en local"

        SelectNumberOfPlayers ->
            "Sélectionnez le nombre de joueurs"

        NumberOfPlayersDescription ->
            "Si vous choisissez 1, vous pourrez joueur seul. Cependant, c'est beaucoup plus fun de jouer avec quelqu'un par Internet !"

        SelectBoardSize ->
            "Choisissez la taille"

        SelectBoardSizeDescription ->
            "Plus le plateau est grand, plus il y aura de cartes à se souvenir"

        StartGame ->
            "Commencer le jeu"

        Waiting ->
            "En attente"
