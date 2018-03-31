module Types.Msg exposing (..)

import Json.Encode as JE


--

import Phoenix.Socket


-- NOTE: Needs to be in its own module (and not, for example, in Update) in order to avoid circular dependencies


type Msg
    = UpdateGame JE.Value
    | ReceiveCompressedGame JE.Value
    | SendCompressedGame JE.Value
      -- | UpdatePlayer String
    | FlipCard Int
    | ChangeTheme String
    | CopyUrl
    | SelectGameUrlInput
    | Replay
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | HandlePresenceState JE.Value
    | HandlePresenceDiff JE.Value
    | ReceiveMessage JE.Value
    | SendMessage
    | OnInputMessage String
    | OnInputPlayerName String
    | SetUserName
    | UpdateFocus JE.Value
