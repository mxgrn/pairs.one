module I18n.Pl exposing (..)

import I18n.Translation exposing (..)


translate : Translation -> String
translate t =
    case t of
        WellDone name ->
            "Dobra robota, " ++ name ++ "!"

        TryDifferentTheme ->
            "Wypróbuj inny motyw!"

        Players ->
            "Gracze"

        YourTurn name ->
            "Twoja kolej, " ++ name ++ "!"

        YourName ->
            "Twoje imię"

        Chat ->
            "Czat"

        You name ->
            "Ty, " ++ name

        PlayAgain ->
            "Zagraj ponownie"

        Accuracy value ->
            "Precyzja: " ++ toString value ++ "%"

        Score value ->
            "Wynik: " ++ toString value

        Scoreboard t ->
            case t of
                ThisGame ->
                    "Ta gra:"

                ThisSet ->
                    "Ten zestaw:"

        ShareThisUrl ->
            "Udostępnij ten adres URL swojemu(-im) przeciwnikowi(-om):"

        ShareThisUrlRandom ->
            "Szukamy dla Ciebie przeciwnika! Daj nam chwilę lub udostępnij ten adres URL komuś, kto chciałby teraz z Tobą zagrać:"

        Theme ->
            "Motyw"

        Size ->
            "Rozmiar"

        Public ->
            "publiczna"

        Private ->
            "Prywatna"

        Local ->
            "Lokalna"

        PickTheme ->
            "Pick a theme"

        Difficulty ->
            "Trudność"

        DifficultyEasy ->
            "łatwa"

        DifficultyMedium ->
            "średnia"

        DifficultyHard ->
            "trudna"

        SelectGameMode ->
            "Z kim chciałbyś zagrać?"

        GameModeDescription ->
            "W grze „publicznej” ktoś może dołączyć do ciebie, wybierając losowego gracza do gry. Jeśli chcesz grać tylko z kimś, komu wyślesz link - wybierz „prywatny”. Jeśli masz obok siebie znajomego i chcesz grać na tym samym urządzeniu, wybierz opcję „lokalnie”."

        WillPlayWithStranger ->
            "Chciałbym, żeby dołączył do mnie nieznajomy!"

        WillSelectOpponents ->
            "Sam zaproszę przeciwnika (ów)"

        WillPlayLocally ->
            "Zagram z kimś lokalnie"

        SelectNumberOfPlayers ->
            "Wybierz liczbę graczy"

        NumberOfPlayersDescription ->
            "Jeśli wybierzesz 1, będziesz mógł grać sam. Jednak o wiele fajniej jest grać z kimś przez Internet!"

        SelectBoardSize ->
            "Wybierz rozmiar"

        SelectBoardSizeDescription ->
            "Im większa plansza - tym więcej kart będzie do zapamiętania"

        StartGame ->
            "Rozpocząć grę"

        Waiting ->
            "Czekanie"
