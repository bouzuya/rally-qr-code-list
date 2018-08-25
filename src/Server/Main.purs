module Server.Main
  (main) where

import Bouzuya.HTTP.Server as Server
import Bouzuya.HTTP.StatusCode (status200)
import Data.ArrayBuffer.ArrayBuffer as ArrayBuffer
import Data.ArrayBuffer.DataView as DataView
import Data.ArrayBuffer.Typed as TypedArray
import Data.ArrayBuffer.Types (Uint8Array)
import Effect (Effect)
import Effect.Class.Console (log)
import Prelude (Unit, discard, pure, (<<<))

stringToUint8Array :: String -> Uint8Array
stringToUint8Array =
  TypedArray.asUint8Array <<< DataView.whole <<< ArrayBuffer.fromString

main :: Effect Unit
main = do
  log "server"
  let
    config = { hostname: "0.0.0.0", port: 8080 }
    handleListen = log "listen http://localhost:8080/"
    handleRequest _ =
      pure
        { body: stringToUint8Array "Hello"
        , headers: []
        , status: status200
        }
  Server.run config handleListen handleRequest
