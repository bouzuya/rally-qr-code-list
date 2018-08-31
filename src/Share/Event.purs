module Share.Event
  ( Event(..)
  , foldp
  ) where

import Data.Maybe (Maybe(..))
import Effect.Class (liftEffect)
import Prelude (bind, discard, pure, ($), (<$>))
import Pux (EffModel, noEffects)
import Pux.DOM.Events (DOMEvent, targetValue)
import Share.Request (RallyToken, createToken)
import Share.Route as Route
import Share.State (State)
import Web.Event.Event (preventDefault)

data Event
  = EmailChange DOMEvent
  | PasswordChange DOMEvent
  | RouteChange Route.Route
  | SignIn DOMEvent
  | SignInSuccess RallyToken

foldp :: Event -> State -> EffModel State Event
foldp (EmailChange event) state =
  noEffects $ state { email = targetValue event }
foldp (PasswordChange event) state =
  noEffects $ state { password = targetValue event }
foldp (RouteChange route) state =
  noEffects $ state { route = route }
foldp (SignIn event) state =
  { state
  , effects:
    [ do
        liftEffect $ preventDefault event
        tokenMaybe <- createToken { email: state.email, password: state.password }
        pure $ SignInSuccess <$> tokenMaybe
    ]
  }
foldp (SignInSuccess token) state =
  { state: state { token = Just token }
  , effects:
    [ pure (Just (RouteChange Route.StampRallyList))
    ]
  }
