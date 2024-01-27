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
            "Точність: " ++ toString value ++ "%"

        Score value ->
            "Оцінка: " ++ toString value

        Scoreboard t ->
            case t of
                ThisGame ->
                    "Остання гра:"

                ThisSet ->
                    "Поточний матч:"

        ShareThisUrl ->
            "Поділись лінком з опонентом:"

        ShareThisUrlRandom ->
            "Шукаємо для вас суперника! Дайте нам секунду або поділіться цією URL-адресою з усіма, хто може захотіти пограти з вами прямо зараз:"

        HelpMeKeepItAdFree ->
            "Допоможіть мені зберегти Pairs One без реклами, пожертвувавши на"

        Theme ->
            "Тема"

        Size ->
            "Розмір"

        Public ->
            "Відкрита"

        Private ->
            "Приватна"

        Local ->
            "Локальна"

        PickTheme ->
            "Обери тему"

        Difficulty ->
            "Складність"

        DifficultyEasy ->
            "легка"

        DifficultyMedium ->
            "середня"

        DifficultyHard ->
            "складна"

        SelectGameMode ->
            "З ким хочеш зіграти?"

        GameModeDescription ->
            "У 'відкритій' грі до тебе може приєднатися випадковий гравець, який зайшов на сайт. Якщо ти хочеш грати тільки з тими, кому ти відішлеш посылання - вибери 'приватна'. Якщо ти хочеш зіграти з одним на одному пристрої, вибери 'локальна'."

        WillPlayWithStranger ->
            "Я зіграю з випадковим гравцем"

        WillSelectOpponents ->
            "Я оберу з ким грати"

        WillPlayLocally ->
            "Я зіграю з кимось на одному пристрої"

        SelectNumberOfPlayers ->
            "Обери кількість гравців"

        NumberOfPlayersDescription ->
            "Якщо ти обереш 1, ти зможеш грати сам. Але набагато цікавіше грати з кимось через інтернет!"

        SelectBoardSize ->
            "Обери розмір"

        SelectBoardSizeDescription ->
            "Чим більша дошка - тим більше карток тобі доведеться запам'ятати"

        StartGame ->
            "Почати гру"

        Waiting ->
            "Очікуємо"
