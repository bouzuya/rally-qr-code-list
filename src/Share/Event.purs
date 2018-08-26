module Share.Event
  ( Event(..)
  , foldp
  ) where

import Data.Maybe (Maybe(..))
import Effect.Class (liftEffect)
import Effect.Console (log)
import Prelude (discard, pure)
import Pux (EffModel)
import Share.State (State)

data Event
  = SignIn

foldp :: Event -> State -> EffModel State Event
foldp SignIn state =
  { state
  , effects:
    [ do
        liftEffect (log "SignIn")
        pure Nothing
    ]
  }
