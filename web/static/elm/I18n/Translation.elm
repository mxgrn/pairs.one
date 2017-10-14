module I18n.Translation exposing (..)


type Scoreboard
    = ThisGame
    | ThisSet


type Translation
    = WellDone String
    | Players
    | YourTurn String
    | You String
    | PlayAgain
    | Accuracy Int
    | Score Int
    | TryDifferentTheme
    | Scoreboard Scoreboard
    | ShareThisUrl
    | ShareThisUrlRandom
    | StartGameWhenReady
