module Types.Player exposing (..)

import Json.Encode as JE
import Json.Decode as JD exposing (field)


type alias PlayerId =
    String


type alias Player =
    { id : PlayerId
    , name : String
    , joined : Bool
    , online : Bool
    , score : Int
    , totalScore : Int
    , turns : Int
    , inaccurateTurns : Int
    }


type alias PlayerPresence =
    { id : PlayerId
    }


playerAt : Int -> List Player -> Maybe Player
playerAt index players =
    players |> List.drop index |> List.head


playerBy : PlayerId -> List Player -> Maybe Player
playerBy id players =
    players
        |> List.foldl
            (\p acc ->
                if p.id == id then
                    Just p
                else
                    acc
            )
            Nothing


playerTurn : PlayerId -> List Player -> Int
playerTurn playerId players =
    players
        |> List.indexedMap (\i { id } -> ( i, id ))
        |> (List.foldl
                (\( i, id ) acc ->
                    if id == playerId then
                        i
                    else
                        acc
                )
                -1
           )


playerEncoder : Player -> JE.Value
playerEncoder player =
    JE.object
        [ ( "id", player.id |> JE.string )
        , ( "name", player.name |> JE.string )
        , ( "joined", player.joined |> JE.bool )
        , ( "online", player.online |> JE.bool )
        , ( "score", player.score |> JE.int )
        , ( "totalScore", player.totalScore |> JE.int )
        , ( "turns", player.turns |> JE.int )
        , ( "inaccurateTurns", player.inaccurateTurns |> JE.int )
        ]


playerDecoder : JD.Decoder Player
playerDecoder =
    JD.map8 Player
        (field "id" JD.string)
        (field "name" JD.string)
        (field "joined" JD.bool)
        (field "online" JD.bool)
        (field "score" JD.int)
        (field "totalScore" JD.int)
        (field "turns" JD.int)
        (field "inaccurateTurns" JD.int)


playerPresenceDecoder : JD.Decoder PlayerPresence
playerPresenceDecoder =
    JD.map PlayerPresence
        (field "id" JD.string)
