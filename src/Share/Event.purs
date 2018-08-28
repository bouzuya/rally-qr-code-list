module Share.Event
  ( Event(..)
  , foldp
  ) where

import Data.Maybe (Maybe(..))
import Effect.Class (liftEffect)
import Effect.Console (log)
import Prelude (discard, pure, ($))
import Pux (EffModel, noEffects)
import Pux.DOM.Events (DOMEvent, targetValue)
import Share.State (State)

data Event
  = EmailChange DOMEvent
  | PasswordChange DOMEvent
  | SignIn

foldp :: Event -> State -> EffModel State Event
foldp (EmailChange event) state = noEffects $ state { email = targetValue event }
foldp (PasswordChange event) state = noEffects $ state { password = targetValue event }
foldp SignIn state =
  { state
  , effects:
    [ do
        liftEffect (log "SignIn")
        pure Nothing
    ]
  }
