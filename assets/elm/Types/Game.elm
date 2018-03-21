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


cardDataEncoder : CardData -> JE.Value
cardDataEncoder cardData =
    JE.object
        [ ( "cleared", (List.map JE.int cardData.cleared) |> JE.list )
        , ( "flipped", (List.map JE.int cardData.flipped) |> JE.list )
        , ( "seen", (List.map JE.int cardData.seen) |> JE.list )
        , ( "values", (List.map JE.int cardData.values) |> JE.list )
        ]


type alias Game =
    { id : GameId
    , cards : CardData
    , players : List Player
    , flips : Int
    , turn : Int
    , theme : String
    , random : Bool
    , visibility : String
    }


gameEncoder : Game -> JE.Value
gameEncoder game =
    JE.object
        [ ( "cards", game.cards |> cardDataEncoder )
        , ( "players", (List.map playerEncoder game.players) |> JE.list )
        , ( "flips", game.flips |> JE.int )
        , ( "turn", game.turn |> JE.int )
        , ( "theme", game.theme |> JE.string )
        ]


gameDecoder : JD.Decoder Game
gameDecoder =
    JD.map8 Game
        (field "id" JD.string)
        (field "cards"
            (JD.map4 CardData
                (field "cleared" (JD.list JD.int))
                (field "flipped" (JD.list JD.int))
                (field "seen" (JD.list JD.int))
                (field "values" (JD.list JD.int))
            )
        )
        (field "players" (JD.list playerDecoder))
        (field "flips" JD.int)
        (field "turn" JD.int)
        (field "theme" JD.string)
        (field "random" JD.bool)
        (field "visibility" JD.string)


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


isLocal : Game -> Bool
isLocal game =
    game.visibility == "local"


isSolo : Game -> Bool
isSolo game =
    List.length (game.players) == 1
