module I18n.ZhHans exposing (..)

import I18n.Translation exposing (..)


translate : Translation -> String
translate t =
    case t of
        WellDone name ->
            "好样的, " ++ name ++ "!"

        TryDifferentTheme ->
            "尝试一下新的主题!"

        Players ->
            "玩家"

        YourTurn name ->
            "轮到你了, " ++ name ++ "!"

        YourName ->
            "Your name"

        Chat ->
            "Chat"

        You name ->
            "你的数据, " ++ name

        PlayAgain ->
            "再玩一把"

        Accuracy value ->
            "准确度: " ++ (toString value) ++ "%"

        Score value ->
            "Score: " ++ (toString value)

        Scoreboard t ->
            case t of
                ThisGame ->
                    "当前战绩:"

                ThisSet ->
                    "总比分:"

        ShareThisUrl ->
            "将此链接分享给你的对手(们)吧:"

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
