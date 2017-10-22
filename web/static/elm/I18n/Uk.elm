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

        YourName ->
            "Your name"

        Chat ->
            "Chat"

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
