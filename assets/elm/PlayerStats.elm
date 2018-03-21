module PlayerStats exposing (updatePlayer, updatePlayers, maxScore)

import Bool
import Types.Player exposing (..)
import Types.Card exposing (..)


updatePlayer : CardData -> List Int -> Bool -> Player -> Player
updatePlayer cards flippedIndices matched player =
    let
        isInaccurateTurn =
            not matched && (areAllSeen flippedIndices cards)

        turns =
            player.turns + 1

        inaccurateTurns =
            player.inaccurateTurns + Bool.toInt isInaccurateTurn

        score =
            player.score + Bool.toInt matched
    in
        { player | score = score, turns = turns, inaccurateTurns = inaccurateTurns }


areAllSeen : List Int -> CardData -> Bool
areAllSeen indices cards =
    List.all (\i -> List.member i cards.seen) indices


maxScore : List Player -> Int
maxScore players =
    players |> List.map .score |> List.maximum |> Maybe.withDefault 0


updatePlayers : List Player -> List Player
updatePlayers players =
    players |> List.map (updatePlayerTotalScore (maxScore players))


updatePlayerTotalScore : Int -> Player -> Player
updatePlayerTotalScore maxScore player =
    { player | totalScore = (player.totalScore + Bool.toInt (player.score == maxScore)) }
