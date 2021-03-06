module Share.State
  ( State
  , deserialize
  , init
  , serialize
  ) where

import Data.Either (either, hush)
import Data.Maybe (Maybe(..))
import Prelude (const)
import Share.QrCode.ErrorCorrectionLevel (ErrorCorrectionLevel)
import Share.QrCode.ErrorCorrectionLevel as ErrorCorrectionLevel
import Share.Request (Spot, StampRally, Token)
import Share.Route (Route)
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
deserialize s = hush (readJSON s)

init :: String -> Route -> State
init assetsBaseUrl route =
  { config:
    { assetsBaseUrl
    }
  , email: ""
  , errorCorrectionLevel: ErrorCorrectionLevel.M
  , password: ""
  , qrCodeList: []
  , route
  , selected: "qr"
  , spotList: Nothing
  , stampRallyList: Nothing
  , token: Nothing
  }

serialize :: State -> String
serialize = writeJSON
