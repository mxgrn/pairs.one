module Types.Game exposing (..)

import Json.Encode as JE
import Json.Decode as JD exposing (field)
import Phoenix.Presence exposing (PresenceState, PresenceStateMetaValue, syncState, syncDiff, presenceStateDecoder, presenceDiffDecoder)
import Dict exposing (Dict)


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
    , random : Bool
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
    JD.map7 Game
        (field "id" JD.string)
        (field "cards" (JD.list cardDecoder))
        (field "players" (JD.list playerDecoder))
        (field "flips" JD.int)
        (field "turn" JD.int)
        (field "theme" JD.string)
        (field "random" JD.bool)


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


updateFromPresenceState : Game -> PresenceState PlayerPresence -> Game
updateFromPresenceState game presenceState =
    let
        onlinePlayerIds =
            Dict.values presenceState
                |> List.map
                    (.metas
                        >> (\wrapper -> (List.head wrapper) |> Maybe.withDefault (PresenceStateMetaValue "" (PlayerPresence "")))
                        >> .payload
                        >> .id
                    )

        players =
            game.players |> List.map (\p -> { p | online = (List.any (\id -> id == p.id) onlinePlayerIds) })
    in
        { game | players = players }
