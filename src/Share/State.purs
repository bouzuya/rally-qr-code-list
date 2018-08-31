module Share.State
  ( State
  , init
  ) where

import Share.Route (Route(..))

type State =
  { config ::
    { assetsBaseUrl :: String
    }
  , email :: String
  , password :: String
  , route :: Route
  }

init :: State
init =
  { config:
    { assetsBaseUrl: "http://localhost:8081" -- TODO: production
    }
  , email: "email@example.com"
  , password: "pass1"
  , route: SignIn
  }
