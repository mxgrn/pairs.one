module Types.Card exposing (..)

import Json.Encode as JE
import Json.Decode as JD exposing (field)


type alias Card =
    { value : Int
    , flipped : Bool
    , cleared : Bool
    , seen : Bool
    }


type alias CardId =
    Int


type alias CardData =
    { cleared : List Int
    , flipped : List Int
    , seen : List Int
    , values : List Int
    }


cardEncoder : Card -> JE.Value
cardEncoder card =
    JE.object
        [ ( "flipped", card.flipped |> JE.bool )
        , ( "cleared", card.cleared |> JE.bool )
        , ( "value", card.value |> JE.int )
        , ( "seen", card.seen |> JE.bool )
        ]


cardDecoder : JD.Decoder Card
cardDecoder =
    JD.map4 Card
        (field "value" JD.int)
        (field "flipped" JD.bool)
        (field "cleared" JD.bool)
        (field "seen" JD.bool)



-- flippedIds : List Card -> List Int
-- flippedIds cards =
--     List.indexedMap (,) cards |> List.filter (Tuple.second >> .flipped) |> List.map Tuple.first
-- cardAt : Int -> List Card -> Maybe Card
-- cardAt index cards =
--     cards |> List.drop index |> List.head
