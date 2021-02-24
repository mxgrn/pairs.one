module I18n.It exposing (..)

import I18n.Translation exposing (..)


translate : Translation -> String
translate t =
    case t of
        WellDone name ->
            "Ben fatto, " ++ name ++ "!"

        TryDifferentTheme ->
            "Prova un tema diverso!"

        Players ->
            "Giocatrici"

        YourTurn name ->
            "Tocca a te, " ++ name ++ "!"

        YourName ->
            "Il tuo nome"

        Chat ->
            "Chiacchierare"

        You name ->
            "Voi, " ++ name

        PlayAgain ->
            "Gioca di nuovo"

        Accuracy value ->
            "Precisione: " ++ toString value ++ "%"

        Score value ->
            "Punto: " ++ toString value

        Scoreboard t ->
            case t of
                ThisGame ->
                    "Questo gioco:"

                ThisSet ->
                    "Questo set:"

        ShareThisUrl ->
            "Condividi questo URL con il tuo avversario:"

        ShareThisUrlRandom ->
            "Stiamo cercando un avversario per te! Dacci un secondo o condividi questo URL con chiunque voglia giocare con te in questo momento:"

        Theme ->
            "Tema"

        Size ->
            "Taglia"

        Public ->
            "Pubblico"

        Private ->
            "Privato"

        Local ->
            "Locale"

        PickTheme ->
            "Scegli un tema"

        Difficulty ->
            "Difficoltà"

        DifficultyEasy ->
            "facile"

        DifficultyMedium ->
            "medio"

        DifficultyHard ->
            "difficile"

        SelectGameMode ->
            "Con chi ti piacerebbe giocare?"

        GameModeDescription ->
            "In un gioco 'pubblico', qualcuno potrebbe unirsi a te quando scegli un giocatore casuale con cui giocare. Se vuoi giocare solo con qualcuno a cui invierai il link, scegli 'privato'. Se hai un amico accanto a te e vuoi giocare sullo stesso dispositivo, scegli 'locale'."

        WillPlayWithStranger ->
            "Vorrei che uno sconosciuto si unisse a me!"

        WillSelectOpponents ->
            "Inviterò il mio avversario (è) me stesso"

        WillPlayLocally ->
            "Giocherò con qualcuno a livello locale"

        SelectNumberOfPlayers ->
            "Seleziona il numero di giocatori"

        NumberOfPlayersDescription ->
            "Se selezioni 1, potrai giocare da solo. Tuttavia, è molto più divertente giocare con qualcuno su Internet!"

        SelectBoardSize ->
            "Seleziona la taglia"

        SelectBoardSizeDescription ->
            "Più grande è il tabellone, più carte ci saranno da ricordare"

        StartGame ->
            "Inizia il gioco"

        Waiting ->
            "Aspettando"
