module Types.Params exposing (..)

import Types.Player exposing (..)
import Types.Game exposing (..)
import Types.Theme exposing (..)


type alias Params =
    { id : GameId
    , playerId : PlayerId
    , playerName : String
    , host : String
    , isSsl : Bool
    , themes : List Theme
    , locale : String
    }
