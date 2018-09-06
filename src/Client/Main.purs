module Client.Main
  (main) where

import Data.List (List)
import Data.Maybe (maybe)
import Effect (Effect)
import Effect.Exception (throw)
import Prelude (Unit, bind, pure, (=<<))
import Pux as Pux
import Pux.DOM.HTML (HTML)
import Pux.DOM.History as PH
import Pux.Renderer.React (renderToReact)
import React (ReactClass)
import Share.Event (Event(..))
import Share.EventHandler (foldp)
import Share.Route (route)
import Share.State as State
import Share.View.ClientRoot as ClientRoot
import Signal (Signal, (~>))
import Signal.Channel (Channel)
import Web.HTML (window)

foreign import hydrateImpl :: forall props. String -> ReactClass props -> Effect Unit
foreign import loadInitialStateJson :: Effect String

hydrate
  :: forall ev
  .  String
  -> Signal (HTML ev)
  -> Channel (List ev)
  -> Effect Unit
hydrate selector markup input =
  hydrateImpl selector =<< renderToReact markup input

match :: String -> Event
match path = RouteChange (route path)

main :: Effect Unit
main = do
  json <- loadInitialStateJson
  let jsonObject = State.deserialize json
  initialState <- maybe (throw "invalid initial state") pure jsonObject
  w <- window
  urlSignal <- PH.sampleURL w
  let
    routeSignal = urlSignal ~> match
    puxConfig =
      { initialState
      , view: ClientRoot.view
      , foldp
      , inputs: [routeSignal]
      }
  app <- Pux.start puxConfig
  hydrate ".root" app.markup app.input
