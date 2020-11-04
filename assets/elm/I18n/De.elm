module I18n.De exposing (..)

import I18n.Translation exposing (..)


translate : Translation -> String
translate t =
    case t of
        WellDone name ->
            "Gut gemacht, " ++ name ++ "!"

        TryDifferentTheme ->
            "Probieren Sie ein anderes Thema aus!"

        Players ->
            "Spieler"

        YourTurn name ->
            "Du bist dran, " ++ name ++ "!"

        YourName ->
            "Dein Name"

        Chat ->
            "Chat"

        You name ->
            "Sie, " ++ name

        PlayAgain ->
            "Nochmal spielen"

        Accuracy value ->
            "Richtigkeit: " ++ toString value ++ "%"

        Score value ->
            "Ergebnis: " ++ toString value

        Scoreboard t ->
            case t of
                ThisGame ->
                    "Dieses Spiel:"

                ThisSet ->
                    "Dieses Set:"

        ShareThisUrl ->
            "Teile diese URL mit deinem Gegner(n):"

        ShareThisUrlRandom ->
            "Wir suchen einen Gegner für Sie! Geben Sie uns eine Sekunde oder teilen Sie diese URL mit allen, die gerade mit Ihnen spielen möchten:"

        Theme ->
            "Thema"

        Size ->
            "Brettgröße"

        Public ->
            "Öffentlich"

        Private ->
            "Privat"

        Local ->
            "Lokal"

        PickTheme ->
            "Wählen Sie ein Thema"

        Difficulty ->
            "Schwierigkeit"

        DifficultyEasy ->
            "einfach"

        DifficultyMedium ->
            "mittler"

        DifficultyHard ->
            "schwer"

        SelectGameMode ->
            "Mit wem möchten Sie spielen??"

        GameModeDescription ->
            "In einem 'öffentlichen' Spiel kann sich jemand Ihnen anschließen, wenn Sie einen zufälligen Spieler zum Spielen auswählen. Wenn Sie nur mit jemandem spielen möchten, an den Sie den Link senden, wählen Sie 'Privat'. Wenn Sie einen Freund direkt neben sich haben und auf demselben Gerät spielen möchten, wählen Sie 'lokal'."

        WillPlayWithStranger ->
            "Ich möchte, dass ein Fremder zu mir kommt!"

        WillSelectOpponents ->
            "Ich werde meine Gegner(n) selbst einladen"

        WillPlayLocally ->
            "Ich werde mit jemandem vor Ort spielen"

        SelectNumberOfPlayers ->
            "Wählen Sie die Anzahl der Spieler"

        NumberOfPlayersDescription ->
            "Wenn Sie 1 auswählen, können Sie alleine spielen. Es macht jedoch viel mehr Spaß, mit jemandem online zu spielen!"

        SelectBoardSize ->
            "Wählen Sie das Spielbrett"

        SelectBoardSizeDescription ->
            "Je größer das Brett, desto mehr Karten gibt es zu merken"

        StartGame ->
            "Spiel starten"

        Waiting ->
            "Wartend"
