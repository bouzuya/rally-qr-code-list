module Share.Event
  ( Event(..)
  , foldp
  ) where

import Data.Maybe (Maybe(..))
import Effect.Class (liftEffect)
import Effect.Console (log)
import Prelude (bind, discard, pure, show, ($), (<$>), (<>))
import Pux (EffModel, noEffects)
import Pux.DOM.Events (DOMEvent, targetValue)
import Share.Request (RallyToken, createToken)
import Share.Route (Route)
import Share.State (State)
import Web.Event.Event (preventDefault)

data Event
  = EmailChange DOMEvent
  | PasswordChange DOMEvent
  | RouteChange Route
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
        liftEffect $ log $ "SignIn: " <> state.email <> ":" <> state.password
        tokenMaybe <- createToken { email: state.email, password: state.password }
        pure $ SignInSuccess <$> tokenMaybe
    ]
  }
foldp (SignInSuccess token) state =
  { state
  , effects:
    [ do
        liftEffect $ log $ show token
        pure Nothing
    ]
  }
