module I18n.Translation exposing (..)


type Scoreboard
    = ThisGame
    | ThisSet


type Translation
    = WellDone String
    | Players
    | YourTurn String
    | YourName
    | Chat
    | You String
    | PlayAgain
    | Accuracy Int
    | Score Int
    | TryDifferentTheme
    | Scoreboard Scoreboard
    | ShareThisUrl
    | ShareThisUrlRandom
    | Theme
    | Size
    | Public
    | Private
    | Local
    | PickTheme
    | Difficulty
    | DifficultyEasy
    | DifficultyMedium
    | DifficultyHard
    | SelectGameMode
    | GameModeDescription
    | WillPlayWithStranger
    | WillSelectOpponents
    | WillPlayLocally
    | SelectNumberOfPlayers
    | NumberOfPlayersDescription
    | SelectBoardSize
    | SelectBoardSizeDescription
    | StartGame
    | Waiting
