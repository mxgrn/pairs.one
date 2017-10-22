module PlayerStats exposing (updatePlayer, updatePlayers, maxScore)

import Bool
import Types.Player exposing (..)
import Types.Card exposing (..)


updatePlayer : List Card -> List Int -> Bool -> Player -> Player
updatePlayer cards flippedIndices matched player =
    let
        isInaccurateTurn =
            not matched && (isAnySeen flippedIndices cards)

        turns =
            player.turns + 1

        inaccurateTurns =
            player.inaccurateTurns + Bool.toInt isInaccurateTurn

        score =
            player.score + Bool.toInt matched
    in
        { player | score = score, turns = turns, inaccurateTurns = inaccurateTurns }


isAnySeen : List Int -> List Card -> Bool
isAnySeen indices cards =
    let
        seenIndices =
            List.indexedMap (,) cards |> List.filter (Tuple.second >> .seen) |> List.map Tuple.first
    in
        List.any (\i -> List.member i seenIndices) indices


maxScore : List Player -> Int
maxScore players =
    players |> List.map .score |> List.maximum |> Maybe.withDefault 0


updatePlayers : List Player -> List Player
updatePlayers players =
    players |> List.map (updatePlayerTotalScore (maxScore players))


updatePlayerTotalScore : Int -> Player -> Player
updatePlayerTotalScore maxScore player =
    { player | totalScore = (player.totalScore + Bool.toInt (player.score == maxScore)) }
