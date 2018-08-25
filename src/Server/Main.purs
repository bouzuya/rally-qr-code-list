module Server.Main
  (main) where

import Bouzuya.HTTP.Request (Request)
import Bouzuya.HTTP.Response (Response)
import Bouzuya.HTTP.Server as Server
import Bouzuya.HTTP.StatusCode (status200)
import Data.ArrayBuffer.ArrayBuffer as ArrayBuffer
import Data.ArrayBuffer.DataView as DataView
import Data.ArrayBuffer.Typed as TypedArray
import Data.ArrayBuffer.Types (Uint8Array)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class.Console (log)
import Prelude (Unit, discard, pure, show, (<<<), (<>))

type ServerOptions =
  { hostname :: String
  , port :: Int
  }

stringToUint8Array :: String -> Uint8Array
stringToUint8Array =
  TypedArray.asUint8Array <<< DataView.whole <<< ArrayBuffer.fromString

handleListen :: ServerOptions -> Effect Unit
handleListen options =
  log ("listen http://" <> options.hostname <> ":" <> show options.port)

handleRequest :: Request -> Aff Response
handleRequest _ =
  pure
    { body: stringToUint8Array "Hello"
    , headers: []
    , status: status200
    }

main :: Effect Unit
main = do
  log "start server"
  let serverOptions = { hostname: "0.0.0.0", port: 8080 }
  Server.run serverOptions (handleListen serverOptions) handleRequest
