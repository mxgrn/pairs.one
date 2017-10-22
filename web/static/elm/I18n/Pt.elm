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

        YourName ->
            "Your name"

        Chat ->
            "Chat"

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

        Theme ->
            "Theme"

        Size ->
            "Size"

        Public ->
            "Public"

        Private ->
            "Private"

        Local ->
            "Local"

        PickTheme ->
            "Pick a theme"

        Difficulty ->
            "Difficulty"

        DifficultyEasy ->
            "easy"

        DifficultyMedium ->
            "medium"

        DifficultyHard ->
            "hard"

        SelectGameMode ->
            "With whom would you like to play?"

        GameModeDescription ->
            "In a 'public' game, someone may join you when choosing a random player to play with. If you want to only play with someone that you'll send the link to - choose 'private'. If you have a friend right next to you and you want to play on the same device, choose 'local'."

        WillPlayWithStranger ->
            "I'd like a stranger to join me!"

        WillSelectOpponents ->
            "I'll invite my opponent(s) myself"

        WillPlayLocally ->
            "I'll play with someone locally"

        SelectNumberOfPlayers ->
            "Select number of players"

        NumberOfPlayersDescription ->
            "If you select 1, you'll be able to play alone. However, it's much more fun to play with someone over the Internet!"

        SelectBoardSize ->
            "Select the size"

        SelectBoardSizeDescription ->
            "The bigger the board - the more cards will there be to remember"

        StartGame ->
            "Start game"

        Waiting ->
            "Waiting"
