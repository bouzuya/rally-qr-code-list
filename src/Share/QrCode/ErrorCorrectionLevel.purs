module Share.QrCode.ErrorCorrectionLevel
  ( ErrorCorrectionLevel(..)
  , toString
  ) where

import Control.Monad.Except (except)
import Data.Either (Either(..))
import Data.List.NonEmpty as NonEmptyList
import Foreign (F, ForeignError(..))
import Prelude (class Eq, bind, (==))
import Simple.JSON (class ReadForeign, class WriteForeign, readImpl, writeImpl)

data ErrorCorrectionLevel
  = L
  | M
  | Q
  | H

instance eqErrorCorrectionLevel :: Eq ErrorCorrectionLevel where
  eq a b = toString a == toString b

instance readForeignErrorCorrectionLevel :: ReadForeign ErrorCorrectionLevel where
  readImpl f = do
    o <- readImpl f :: F String
    except case o of
      "L" -> Right L
      "M" -> Right M
      "Q" -> Right Q
      "H" -> Right H
      _ -> Left (NonEmptyList.singleton (ForeignError "Unknown Route"))

instance writeForeignErrorCorrectionLevel :: WriteForeign ErrorCorrectionLevel where
  writeImpl level = writeImpl (toString level)

toString :: ErrorCorrectionLevel -> String
toString level =
  case level of
    L -> "L"
    M -> "M"
    Q -> "Q"
    H -> "H"
