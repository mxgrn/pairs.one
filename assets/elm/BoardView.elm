module BoardView exposing (boardView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Maybe exposing (withDefault)
import List.Extra


--

import Types.Model exposing (..)
import Types.Card exposing (..)
import Types.Msg exposing (..)
import I18n exposing (..)
import I18n.Translation exposing (..)


boardView : Model -> Html Msg
boardView model =
    let
        cols =
            model.game.cards.values |> List.length |> toFloat |> sqrt |> truncate

        cardAt : CardData -> Int -> Int -> Card
        cardAt cards index value =
            { value = value
            , flipped = List.any (\id -> index == id) cards.flipped
            , cleared = List.any (\id -> index == id) cards.cleared
            , seen = List.any (\id -> index == id) cards.seen
            }

        cards =
            List.indexedMap (cardAt model.game.cards) model.game.cards.values

        cardsWithIds =
            List.indexedMap (,) cards
    in
        div [ class "game row" ]
            [ div [ class "col-md-12 col-lg-12" ]
                [ div
                    [ classList
                        [ ( "active", model.game.turn == model.playerTurn )
                        , ( "memory", True )
                        ]
                    ]
                    ((groupsOf cols cardsWithIds) |> (rows model))
                ]
            ]


rows : Model -> List (List ( Int, Card )) -> List (Html Msg)
rows model cardRows =
    List.indexedMap (row model) cardRows


row : Model -> Int -> List ( Int, Card ) -> Html Msg
row model rowIndex cardsWithIds =
    let
        cols =
            cardsWithIds |> List.length
    in
        div
            [ class "card-row"
            , style
                [ ( "top", (toString (100 / toFloat cols * toFloat rowIndex) ++ "%") )
                , ( "height", (toString (100 / toFloat cols) ++ "%") )
                ]
            ]
            (List.indexedMap
                (card model cols rowIndex)
                cardsWithIds
            )


card : Model -> Int -> Int -> Int -> ( Int, Card ) -> Html Msg
card model dimension row col ( cardId, card ) =
    let
        numberOfPairs =
            toFloat dimension * toFloat dimension / 2 |> truncate

        isClickable =
            model.game.turn == model.playerTurn && not card.flipped && not card.cleared

        classAttrs =
            [ classList
                [ ( "card", True )
                , ( "card--clickable", isClickable )
                , ( "flipped", card.flipped )
                , ( "cleared", card.cleared )
                ]
            ]

        cardAttrs =
            if isClickable then
                classAttrs ++ [ onMouseDown (FlipCard cardId) ]
            else
                classAttrs

        width =
            (100 / toFloat dimension)
    in
        div
            [ class "card-wrapper"
            , style
                [ ( "left", (toString (100 / toFloat dimension * toFloat col)) ++ "%" )
                , ( "width", (toString width ++ "%") )
                ]
            ]
            [ div cardAttrs
                [ div
                    [ class "front" ]
                    [ div [ class "centerer" ] []
                    , img
                        [ src ("/images/owl-blue.svg") ]
                        []
                    ]
                , div
                    [ class "back" ]
                    [ div [ class "centerer" ] []
                    , img
                        [ src ("/images/" ++ model.game.theme ++ "/" ++ (toString card.value) ++ ".svg")
                        ]
                        []
                    ]
                ]
            ]


groupsOf : Int -> List a -> List (List a)
groupsOf size xs =
    let
        group =
            List.take size xs

        xs_ =
            List.drop size xs

        okayLength =
            size == List.length group
    in
        if size > 0 && okayLength then
            group :: groupsOf size xs_
        else
            []
