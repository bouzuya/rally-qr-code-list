module Share.QrCode
  ( ErrorCorrectionLevel(..)
  , toDataUrl
  ) where

import Control.Monad.Except (except)
import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Either (Either(..))
import Data.List.NonEmpty as NonEmptyList
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Foreign (F, ForeignError(..))
import Prelude (bind)
import Simple.JSON (class ReadForeign, class WriteForeign, readImpl, writeImpl)

foreign import toDataUrlImpl :: ErrorCorrectionLevelString -> String -> Effect (Promise String)

data ErrorCorrectionLevel
  = L
  | M
  | Q
  | H

type ErrorCorrectionLevelString = String

instance readForeignErrorCorrectionLevel :: ReadForeign ErrorCorrectionLevel where
  readImpl f = do
    o <- readImpl f :: F ErrorCorrectionLevelString
    except case o of
      "L" -> Right L
      "M" -> Right M
      "Q" -> Right Q
      "H" -> Right H
      _ -> Left (NonEmptyList.singleton (ForeignError "Unknown Route"))

instance writeForeignErrorCorrectionLevel :: WriteForeign ErrorCorrectionLevel where
  writeImpl level = writeImpl (toStringErrorCorrectionLevel level)

toStringErrorCorrectionLevel :: ErrorCorrectionLevel -> String
toStringErrorCorrectionLevel level =
  case level of
    L -> "L"
    M -> "M"
    Q -> "Q"
    H -> "H"

toDataUrl :: ErrorCorrectionLevel -> String -> Aff String
toDataUrl level text = do
  promise <- liftEffect (toDataUrlImpl (toStringErrorCorrectionLevel level) text)
  Promise.toAff promise
