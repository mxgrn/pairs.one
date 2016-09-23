port module PortsOut exposing (..)

import Types.Game exposing (..)
import Json.Encode as JE


port playAudio : String -> Cmd msg


port compressAndSendGame : Game -> Cmd msg


port decompressAndUpdateGame : JE.Value -> Cmd msg
