module Bool exposing (..)


toInt : Bool -> Int
toInt val =
    if val then
        1
    else
        0
