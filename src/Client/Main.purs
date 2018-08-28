module Client.Main
  (main) where

import Effect (Effect)
import Effect.Class.Console (log)
import Prelude (Unit, bind, discard)
import Pux as Pux
import Pux.Renderer.React as PR
import Share.Event (foldp)
import Share.View.ClientRoot as ClientRoot

main :: Effect Unit
main = do
  log "client"
  let
    puxConfig =
      { initialState:
        { email: "email@example.com"
        , password: "pass1"
        }
      , view: ClientRoot.view
      , foldp
      , inputs: []
      }
  app <- Pux.start puxConfig
  PR.renderToDOM ".client-root" app.markup app.input
