module Share.QrCode
  ( ErrorCorrectionLevel(..)
  , toDataUrl
  ) where

import Control.Promise (Promise)
import Control.Promise as Promise
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Prelude (bind)

data ErrorCorrectionLevel
  = L
  | M
  | Q
  | H

foreign import toDataUrlImpl :: String -> String -> Effect (Promise String)

toDataUrl :: ErrorCorrectionLevel -> String -> Aff String
toDataUrl level text =
  let
    level' = case level of
      L -> "L"
      M -> "M"
      Q -> "Q"
      H -> "H"
  in
    do
      promise <- liftEffect (toDataUrlImpl level' text)
      Promise.toAff promise
