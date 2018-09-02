module Share.State
  ( State
  , init
  ) where

import Data.Maybe (Maybe(..))
import Share.Request (Spot, StampRally, Token)
import Share.Route (Route(..))

type State =
  { config ::
    { assetsBaseUrl :: String
    }
  , email :: String
  , password :: String
  , route :: Route
  , spotList :: Maybe (Array Spot)
  , stampRallyList :: Maybe (Array StampRally)
  , token :: Maybe Token
  }

init :: State
init =
  { config:
    { assetsBaseUrl: "http://localhost:8081" -- TODO: production
    }
  , email: "email@example.com"
  , password: "pass1"
  , route: SignIn
  , spotList: Nothing
  , stampRallyList: Nothing
  , token: Nothing
  }
