module Share.QrCode
  ( toDataUrl
  ) where

import Control.Promise (Promise)
import Control.Promise as Promise
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Prelude (bind)
import Share.QrCode.ErrorCorrectionLevel as ErrorCorrectionLevel

foreign import toDataUrlImpl :: ErrorCorrectionLevelString -> String -> Effect (Promise String)

type ErrorCorrectionLevel = ErrorCorrectionLevel.ErrorCorrectionLevel
type ErrorCorrectionLevelString = String

toDataUrl :: ErrorCorrectionLevel -> String -> Aff String
toDataUrl level text = do
  promise <- liftEffect (toDataUrlImpl (ErrorCorrectionLevel.toString level) text)
  Promise.toAff promise
