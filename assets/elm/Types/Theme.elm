module Types.Theme exposing (..)


type alias Theme =
    { name : String
    , title : String
    , difficulty : Int
    , new : Bool
    }


defaultTheme : Theme
defaultTheme =
    Theme "eighties" "80's" 0 False
