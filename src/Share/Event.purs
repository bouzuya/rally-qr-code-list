module Share.Event
  ( Event(..)
  , foldp
  ) where

import Data.Maybe (Maybe(..))
import Effect.Class (liftEffect)
import Prelude (bind, discard, pure, ($), (<$>))
import Pux (EffModel, noEffects, onlyEffects)
import Pux.DOM.Events (DOMEvent, targetValue)
import Share.Request (Token, StampRally, createToken, getStampRallyList)
import Share.Route as Route
import Share.State (State)
import Web.Event.Event (preventDefault)

data Event
  = EmailChange DOMEvent
  | FetchStampRallyList
  | FetchStampRallyListSuccess (Array StampRally)
  | PasswordChange DOMEvent
  | RouteChange Route.Route
  | SignIn DOMEvent
  | SignInSuccess Token

foldp :: Event -> State -> EffModel State Event
foldp (EmailChange event) state =
  noEffects $ state { email = targetValue event }
foldp FetchStampRallyList state =
  onlyEffects
    state
    [
      do
        case state.stampRallyList of
          Just _ -> pure Nothing
          Nothing ->
            case state.token of
              Just token -> do
                stampRallyListMaybe <- getStampRallyList token
                pure (FetchStampRallyListSuccess <$> stampRallyListMaybe)
              Nothing -> pure Nothing
    ]
foldp (FetchStampRallyListSuccess stampRallyList) state =
  noEffects $ state { stampRallyList = Just stampRallyList }
foldp (PasswordChange event) state =
  noEffects $ state { password = targetValue event }
foldp (RouteChange route) state =
  { state: state { route = route }
  , effects:
    [ do
        case route of
          Route.StampRallyList ->
            pure (Just FetchStampRallyList)
          _ ->
            pure Nothing
    ]
  }
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
