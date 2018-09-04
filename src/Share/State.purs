module Share.State
  ( State
  , deserialize
  , init
  , serialize
  ) where

import Data.Either (either)
import Data.Maybe (Maybe(..))
import Prelude (const)
import Share.Request (Spot, StampRally, Token)
import Share.Route (Route(..))
import Simple.JSON (readJSON, writeJSON)

type State =
  { config ::
    { assetsBaseUrl :: String
    }
  , email :: String
  , password :: String
  , qrCodeList :: Array { spotId :: Int, dataUrl :: String }
  , route :: Route
  , spotList :: Maybe (Array Spot)
  , stampRallyList :: Maybe (Array StampRally)
  , token :: Maybe Token
  }

deserialize :: String -> Maybe State
deserialize s = either (const Nothing) Just (readJSON s)

init :: State
init =
  { config:
    { assetsBaseUrl: "http://localhost:8081" -- TODO: production
    }
  , email: ""
  , password: ""
  , qrCodeList: []
  , route: SignIn
  , spotList: Nothing
  , stampRallyList: Nothing
  , token: Nothing
  }

serialize :: State -> String
serialize = writeJSON
