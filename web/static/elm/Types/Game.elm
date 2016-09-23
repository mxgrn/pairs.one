module Types.Game exposing (..)

import Json.Encode as JE
import Json.Decode as JD exposing ((:=))


--

import Types.Player exposing (..)
import Types.Card exposing (..)


type alias GameId =
    String


type alias Game =
    { id : GameId
    , cards : List Card
    , players : List Player
    , flips : Int
    , turn : Int
    , theme : String
    }


gameEncoder : Game -> JE.Value
gameEncoder game =
    JE.object
        [ ( "cards", (List.map cardEncoder game.cards) |> JE.list )
        , ( "players", (List.map playerEncoder game.players) |> JE.list )
        , ( "flips", game.flips |> JE.int )
        , ( "turn", game.turn |> JE.int )
        , ( "theme", game.theme |> JE.string )
        ]


gameDecoder : JD.Decoder Game
gameDecoder =
    JD.object6 Game
        ("id" := JD.string)
        ("cards" := JD.list cardDecoder)
        ("players" := JD.list playerDecoder)
        ("flips" := JD.int)
        ("turn" := JD.int)
        ("theme" := JD.string)


updatePlayerName : Game -> PlayerId -> String -> Game
updatePlayerName game playerId name =
    let
        newPlayers =
            List.map
                (\p ->
                    if p.id == playerId then
                        { p | name = name }
                    else
                        p
                )
                game.players
    in
        { game | players = newPlayers }
