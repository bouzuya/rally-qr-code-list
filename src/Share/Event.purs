module Share.Event
  ( Event(..)
  , RallyToken
  , foldp
  ) where

import Bouzuya.HTTP.Client (body, fetch, headers, method, url)
import Bouzuya.HTTP.Method as Method
import Data.Either (either)
import Data.Maybe (Maybe(..))
import Data.Options ((:=))
import Data.Tuple (Tuple(..))
import Effect.Class (liftEffect)
import Effect.Console (log)
import Foreign.Object as Object
import Prelude (bind, const, discard, pure, show, ($), (<>))
import Pux (EffModel, noEffects)
import Pux.DOM.Events (DOMEvent, targetValue)
import Share.Route (Route)
import Share.State (State)
import Simple.JSON (readJSON, writeJSON)
import Web.Event.Event (preventDefault)

data Event
  = EmailChange DOMEvent
  | PasswordChange DOMEvent
  | RouteChange Route
  | SignIn DOMEvent
  | SignInSuccess RallyToken

type RallyToken =
  { expiredAt :: String -- DateTime
  , refreshToken :: String
  , refreshTokenExpiredAt :: String -- DateTime
  , token :: String
  , userId :: String
  }

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
        response <-
          fetch
            ( body := writeJSON { email: state.email, password: state.password }
            <> headers := Object.fromFoldable [Tuple "Content-Type" "application/json"]
            <> method := Method.POST
            <> url := "https://api.rallyapp.jp/tokens")
        pure do
          body <- response.body
          token <- either (const Nothing) Just (readJSON body)
          pure (SignInSuccess (token :: RallyToken))
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
