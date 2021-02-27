module I18n.Es exposing (..)

import I18n.Translation exposing (..)


translate : Translation -> String
translate t =
    case t of
        WellDone name ->
            "¡Bien hecho " ++ name ++ "!"

        TryDifferentTheme ->
            "Prueba un tema diferente!"

        Players ->
            "Jugadores"

        YourTurn name ->
            "Tu turno " ++ name ++ "!"

        YourName ->
            "Tu nombre"

        Chat ->
            "Chat"

        You name ->
            "Tú, " ++ name

        PlayAgain ->
            "Juega de nuevo"

        Accuracy value ->
            "Exactitud: " ++ toString value ++ "%"

        Score value ->
            "Puntuación: " ++ toString value

        Scoreboard t ->
            case t of
                ThisGame ->
                    "Este juego:"

                ThisSet ->
                    "Este partido:"

        ShareThisUrl ->
            "Comparte esta URL con tu oponente(s):"

        ShareThisUrlRandom ->
            "¡Estamos buscando un oponente para ti! Danos un segundo o comparte esta URL con cualquiera que quiera jugar contigo ahora mismo:"

        HelpMeKeepItAdFree ->
            "Ayúdame a mantener Pairs One sin publicidad donando en "

        Theme ->
            "Tema"

        Size ->
            "Tamaño"

        Public ->
            "Publico"

        Private ->
            "Privado"

        Local ->
            "Local"

        PickTheme ->
            "Elige un tema"

        Difficulty ->
            "Dificultad"

        DifficultyEasy ->
            "fácil"

        DifficultyMedium ->
            "medio"

        DifficultyHard ->
            "duro"

        SelectGameMode ->
            "¿Con quién te gustaría jugar?"

        GameModeDescription ->
            "En un juego 'público', alguien puede unirse a ti al elegir un jugador aleatorio con quien jugar. Si solo quieres jugar con alguien a quien le enviarás el enlace, elige 'privado'. Si tienes un amigo junto a ti y quieres jugar en el mismo dispositivo, elige 'local'."

        WillPlayWithStranger ->
            "¡Me gustaría que un extraño se uniera a mí!"

        WillSelectOpponents ->
            "Invitaré a mi(s) oponente(s) yo mismo"

        WillPlayLocally ->
            "Jugaré con alguien localmente"

        SelectNumberOfPlayers ->
            "Seleccionar número de jugadores"

        NumberOfPlayersDescription ->
            "Si selecciona 1, podrá jugar solo. Sin embargo, ¡es mucho más divertido jugar con alguien online!"

        SelectBoardSize ->
            "Seleccione el tamaño"

        SelectBoardSizeDescription ->
            "Cuanto más grande sea el tablero, más cartas habrá para recordar"

        StartGame ->
            "Empezar juego"

        Waiting ->
            "Esperando"
