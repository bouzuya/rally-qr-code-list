module Share.EventHandler
  ( foldp
  ) where

import Data.Maybe (Maybe(..))
import Effect.Class (liftEffect)
import Prelude (bind, discard, pure, ($), (<$>))
import Pux (EffModel, mapEffects, noEffects, onlyEffects)
import Pux.DOM.Events (targetValue)
import Share.Cookie as Cookie
import Share.Event (Event(..))
import Share.Event.InternalEvent (InternalEvent(..))
import Share.Event.InternalEventHandler as InternalEventHandler
import Share.Request (createToken)
import Share.Route as Route
import Share.State (State)
import Web.Event.Event (preventDefault)

foldp :: Event -> State -> EffModel State Event
foldp (EmailChange event) state =
  noEffects $ state { email = targetValue event }
foldp (GoTo route event) state =
  onlyEffects
    state
    [ do
        liftEffect (preventDefault event)
        pure (Just (InternalEvent (RouteChange route)))
    ]
foldp (InternalEvent event) state =
  mapEffects InternalEvent (InternalEventHandler.foldp event state)
foldp (PasswordChange event) state =
  noEffects $ state { password = targetValue event }
foldp (SignIn event) state =
  onlyEffects
    state
    [ do
        liftEffect $ preventDefault event
        tokenMaybe <- createToken { email: state.email, password: state.password }
        pure $ InternalEvent <$> SignInSuccess <$> tokenMaybe
    ]
foldp (SignOut event) state =
  { state: state { token = Nothing }
  , effects:
    [ do
        liftEffect (preventDefault event)
        liftEffect (Cookie.saveToken Nothing)
        pure (Just (InternalEvent (RouteChange Route.SignIn)))
    ]
  }
