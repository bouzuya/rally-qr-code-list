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
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Prelude (Unit, bind, pure, show, (<<<), (<>))
import Pux as Pux
import Pux.Renderer.React (renderToStaticMarkup)
import Server.StaticRoute (staticRoute)
import Share.EventHandler (foldp)
import Share.Route (route)
import Share.State as State
import Share.View.ServerRoot as ServerRoot

-- TODO: move to Bouzuya.HTTP.Server
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
handleRequest request = do
  match <- liftEffect (staticRoute "dist" request.pathname)
  case match of
    Just { binary, extension, mimeType } -> do
      pure
        { body: binary
        , headers:
          [ Tuple "Content-Type" mimeType
          ]
        , status: status200
        }
    Nothing -> do
      let
        currentRoute = route request.pathname
        puxConfig =
          { initialState: State.init currentRoute
          , view: ServerRoot.view
          , foldp
          , inputs: []
          }
      app <- liftEffect (Pux.start puxConfig)
      htmlAsString <- liftEffect (renderToStaticMarkup app.markup)
      let
        body = stringToUint8Array htmlAsString
      pure
        { body: body
        , headers:
          [ Tuple "Content-Type" "text/html"
          ]
        , status: status200
        }

main :: Effect Unit
main = do
  let serverOptions = { hostname: "0.0.0.0", port: 8080 }
  Server.run serverOptions (handleListen serverOptions) handleRequest
