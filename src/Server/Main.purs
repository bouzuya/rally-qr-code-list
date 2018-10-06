module Server.Main
  (main) where

import Bouzuya.HTTP.Request (Request)
import Bouzuya.HTTP.Response (Response)
import Bouzuya.HTTP.Server as Server
import Bouzuya.HTTP.StatusCode (status200)
import Control.Monad.Maybe.Trans (MaybeT(..), runMaybeT)
import Data.ArrayBuffer.ArrayBuffer as ArrayBuffer
import Data.ArrayBuffer.DataView as DataView
import Data.ArrayBuffer.Typed as TypedArray
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Int as Int
import Data.Maybe (Maybe(..), maybe)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Effect.Exception (throw)
import Node.Process (lookupEnv)
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

handleRequest :: String -> Request -> Aff Response
handleRequest assetsBaseUrl request = do
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
          { initialState: State.init assetsBaseUrl currentRoute
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
  configMaybe <- runMaybeT do
    assetsBaseUrl <- MaybeT (lookupEnv "ASSETS_BASE_URL")
    portString <- MaybeT (lookupEnv "PORT")
    port <- MaybeT (pure (Int.fromString portString))
    pure { assetsBaseUrl, port }
  config <- maybe (throw "invalid env") pure configMaybe
  let
    serverOptions = { hostname: "0.0.0.0", port: config.port }
    assetsBaseUrl = config.assetsBaseUrl
  Server.run
    serverOptions
    (handleListen serverOptions)
    (handleRequest assetsBaseUrl)
