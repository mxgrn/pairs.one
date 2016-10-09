effect module Keyboard where { subscription = MySub } exposing
  ( KeyCode
  , presses, downs, ups
  )

{-| This library lets you listen to global keyboard events.

# Key Codes
@docs KeyCode

# Subscriptions
@docs presses, downs, ups

-}

import Dict
import Dom.LowLevel as Dom
import Json.Decode as Json exposing ((:=))
import Process
import Task exposing (Task)



-- KEY CODES


{-| Keyboard keys can be represented as integers. These are called *key codes*.
You can use [`toCode`](http://package.elm-lang.org/packages/elm-lang/core/latest/Char#toCode)
and [`fromCode`](http://package.elm-lang.org/packages/elm-lang/core/latest/Char#fromCode)
to convert between key codes and characters.
-}
type alias KeyCode =
  Int


keyCode : Json.Decoder KeyCode
keyCode =
  "keyCode" := Json.int



-- MOUSE EVENTS


{-| Subscribe to all key presses.
-}
presses : (KeyCode -> msg) -> Sub msg
presses tagger =
  subscription (MySub "keypress" tagger)


{-| Subscribe to get codes whenever a key goes down.
-}
downs : (KeyCode -> msg) -> Sub msg
downs tagger =
  subscription (MySub "keydown" tagger)


{-| Subscribe to get codes whenever a key goes up.
-}
ups : (KeyCode -> msg) -> Sub msg
ups tagger =
  subscription (MySub "keyup" tagger)



-- SUBSCRIPTIONS


type MySub msg
  = MySub String (KeyCode -> msg)


subMap : (a -> b) -> MySub a -> MySub b
subMap func (MySub category tagger) =
  MySub category (tagger >> func)



-- EFFECT MANAGER STATE


type alias State msg =
  Dict.Dict String (Watcher msg)


type alias Watcher msg =
  { taggers : List (KeyCode -> msg)
  , pid : Process.Id
  }



-- CATEGORIZE SUBSCRIPTIONS


type alias SubDict msg =
  Dict.Dict String (List (KeyCode -> msg))


categorize : List (MySub msg) -> SubDict msg
categorize subs =
  categorizeHelp subs Dict.empty


categorizeHelp : List (MySub msg) -> SubDict msg -> SubDict msg
categorizeHelp subs subDict =
  case subs of
    [] ->
      subDict

    MySub category tagger :: rest ->
      categorizeHelp rest <|
        Dict.update category (categorizeHelpHelp tagger) subDict


categorizeHelpHelp : a -> Maybe (List a) -> Maybe (List a)
categorizeHelpHelp value maybeValues =
  case maybeValues of
    Nothing ->
      Just [value]

    Just values ->
      Just (value :: values)



-- EFFECT MANAGER


init : Task Never (State msg)
init =
  Task.succeed Dict.empty


type alias Msg =
  { category : String
  , keyCode : KeyCode
  }


(&>) t1 t2 = t1 `Task.andThen` \_ -> t2


onEffects : Platform.Router msg Msg -> List (MySub msg) -> State msg -> Task Never (State msg)
onEffects router newSubs oldState =
  let
    leftStep category {pid} task =
      Process.kill pid &> task

    bothStep category {pid} taggers task =
      task
        `Task.andThen` \state ->

      Task.succeed
        (Dict.insert category (Watcher taggers pid) state)

    rightStep category taggers task =
      task
        `Task.andThen` \state ->

      Process.spawn (Dom.onDocument category keyCode (Platform.sendToSelf router << Msg category))
        `Task.andThen` \pid ->

      Task.succeed
        (Dict.insert category (Watcher taggers pid) state)
  in
    Dict.merge
      leftStep
      bothStep
      rightStep
      oldState
      (categorize newSubs)
      (Task.succeed Dict.empty)


onSelfMsg : Platform.Router msg Msg -> Msg -> State msg -> Task Never (State msg)
onSelfMsg router {category,keyCode} state =
  case Dict.get category state of
    Nothing ->
      Task.succeed state

    Just {taggers} ->
      let
        send tagger =
          Platform.sendToApp router (tagger keyCode)
      in
        Task.sequence (List.map send taggers)
          `Task.andThen` \_ ->

        Task.succeed state

