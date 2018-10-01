module Share.State
  ( State
  , deserialize
  , init
  , serialize
  ) where

import Data.Either (either)
import Data.Maybe (Maybe(..))
import Prelude (const)
import Share.QrCode (ErrorCorrectionLevel)
import Share.QrCode as ErrorCorrectionLevel
import Share.Request (Spot, StampRally, Token)
import Share.Route (Route(..))
import Simple.JSON (readJSON, writeJSON)

type State =
  { config ::
    { assetsBaseUrl :: String
    }
  , email :: String
  , errorCorrectionLevel :: ErrorCorrectionLevel
  , password :: String
  , qrCodeList :: Array { spotId :: Int, dataUrl :: String }
  , route :: Route
  , selected :: String -- qr or url
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
  , errorCorrectionLevel: ErrorCorrectionLevel.M
  , password: ""
  , qrCodeList: []
  , route: Index
  , selected: "qr"
  , spotList: Nothing
  , stampRallyList: Nothing
  , token: Nothing
  }

serialize :: State -> String
serialize = writeJSON
