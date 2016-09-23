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
    | TryDifferentTheme
    | Scoreboard Scoreboard
