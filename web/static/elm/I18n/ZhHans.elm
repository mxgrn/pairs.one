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

        You name ->
            "你的数据, " ++ name

        PlayAgain ->
            "再玩一把"

        Accuracy value ->
            "准确度: " ++ (toString value) ++ "%"

        Scoreboard t ->
            case t of
                ThisGame ->
                    "当前战绩:"

                ThisSet ->
                    "总比分:"

        ShareThisUrl ->
            "将此链接分享给你的对手(们)吧:"

        StartGameWhenReady ->
            "当全部玩家准备就绪, 游戏将立即开始!"
