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
            "Seu nome"

        Chat ->
            "Bater papo"

        You name ->
            "Você, " ++ name

        PlayAgain ->
            "Jogar novamente"

        Accuracy value ->
            "Percentual de acerto: " ++ toString value ++ "%"

        Score value ->
            "Pontuação: " ++ toString value

        Scoreboard t ->
            case t of
                ThisGame ->
                    "Este jogo:"

                ThisSet ->
                    "Este conjunto:"

        ShareThisUrl ->
            "Compartilhe essa URL com seu(s) oponente(s):"

        ShareThisUrlRandom ->
            "Assim que houver outro jogador disponível, ligaremos para você! Se você não quiser esperar, compartilhe este URL com quem quiser jogar:"

        HelpMeKeepItAdFree ->
            "Ajude-me a manter o Pairs One sem anúncios, doando no"

        Theme ->
            "Tema"

        Size ->
            "Tamanho"

        Public ->
            "Público"

        Private ->
            "Privado"

        Local ->
            "Local"

        PickTheme ->
            "Escolha um tema"

        Difficulty ->
            "Dificuldade"

        DifficultyEasy ->
            "fácil"

        DifficultyMedium ->
            "média"

        DifficultyHard ->
            "dura"

        SelectGameMode ->
            "Com quem você gostaria de jogar?"

        GameModeDescription ->
            "Em um jogo “público”, alguém pode se juntar a você ao escolher um jogador aleatório para jogar. Se você quiser jogar apenas com alguém para quem enviará o link - escolha 'privado'. Se você tem um amigo próximo a você e deseja jogar no mesmo dispositivo, escolha 'local'."

        WillPlayWithStranger ->
            "Eu gostaria que um estranho se juntasse a mim"

        WillSelectOpponents ->
            "Eu mesmo convidarei meu(s) oponente(s)"

        WillPlayLocally ->
            "Vou brincar com alguém localmente"

        SelectNumberOfPlayers ->
            "Selecione o número de jogadores"

        NumberOfPlayersDescription ->
            "Se você selecionar 1, poderá jogar sozinho. Porém, é muito mais divertido brincar com alguém pela Internet!"

        SelectBoardSize ->
            "Selecione o tamanho"

        SelectBoardSizeDescription ->
            "Quanto maior o tabuleiro, mais cartas haverá para lembrar"

        StartGame ->
            "Começar o jogo"

        Waiting ->
            "Esperando"
