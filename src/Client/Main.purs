module Client.Main
  (main) where

import Data.List (List)
import Effect (Effect)
import Effect.Class.Console (log)
import Prelude (Unit, bind, discard, (=<<))
import Pux as Pux
import Pux.DOM.HTML (HTML)
import Pux.DOM.History as PH
import Pux.Renderer.React (renderToReact)
import React (ReactClass)
import Share.Event (Event(..), foldp)
import Share.Route (route)
import Share.State as State
import Share.View.ClientRoot as ClientRoot
import Signal (Signal, (~>))
import Signal.Channel (Channel)
import Web.HTML (window)

foreign import hydrateImpl :: ∀ props. String -> ReactClass props -> Effect Unit

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
  log "client"
  urlSignal <- PH.sampleURL =<< window
  let
    routeSignal = urlSignal ~> match
    puxConfig =
      { initialState: State.init
      , view: ClientRoot.view
      , foldp
      , inputs: [routeSignal]
      }
  app <- Pux.start puxConfig
  hydrate ".root" app.markup app.input
