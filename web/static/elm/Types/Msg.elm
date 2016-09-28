module Types.Msg exposing (..)

import Json.Encode as JE


--

import Phoenix.Socket


type Msg
    = UpdateGame JE.Value
    | ReceiveCompressedGame JE.Value
    | SendCompressedGame JE.Value
    | UpdatePlayer String
    | FlipCard Int
    | ChangeTheme String
    | CopyUrl
    | SelectGameUrlInput
    | Replay
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | HandlePresenceState JE.Value
    | HandlePresenceDiff JE.Value
