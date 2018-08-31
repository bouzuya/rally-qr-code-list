module Share.State
  ( State
  , init
  ) where

import Data.Maybe (Maybe(..))
import Share.Request (RallyToken)
import Share.Route (Route(..))

type State =
  { config ::
    { assetsBaseUrl :: String
    }
  , email :: String
  , password :: String
  , route :: Route
  , token :: Maybe RallyToken
  }

init :: State
init =
  { config:
    { assetsBaseUrl: "http://localhost:8081" -- TODO: production
    }
  , email: "email@example.com"
  , password: "pass1"
  , route: SignIn
  , token: Nothing
  }
