module Client.Main
  (main) where

import Data.List (List)
import Effect (Effect)
import Effect.Class.Console (log)
import Prelude (Unit, bind, discard, (=<<))
import Pux as Pux
import Pux.DOM.HTML (HTML)
import Pux.Renderer.React (renderToReact)
import React (ReactClass)
import Share.Event (foldp)
import Share.State as State
import Share.View.ClientRoot as ClientRoot
import Signal (Signal)
import Signal.Channel (Channel)

foreign import hydrateImpl :: ∀ props. String -> ReactClass props -> Effect Unit

hydrate
  :: forall ev
  .  String
  -> Signal (HTML ev)
  -> Channel (List ev)
  -> Effect Unit
hydrate selector markup input =
  hydrateImpl selector =<< renderToReact markup input

main :: Effect Unit
main = do
  log "client"
  let
    puxConfig =
      { initialState: State.init
      , view: ClientRoot.view
      , foldp
      , inputs: []
      }
  app <- Pux.start puxConfig
  hydrate ".root" app.markup app.input
