module Bouzuya.MimeType
  ( MimeType
  , fromString
  , mimeType
  , toString ) where

import Data.Maybe (Maybe(..))
import Data.String (Pattern(..))
import Data.String as String
import Prelude (class Eq, class Show, not, show, (&&), (<>), (==))

type Type = String
type SubType = String
data MimeType = MimeType Type SubType

instance eqMimeType :: Eq MimeType where
  eq (MimeType t1 s1) (MimeType t2 s2) = t1 == t2 && s1 == s2

instance showMimeType :: Show MimeType where
  show (MimeType t s) = t <> "/" <> s

fromString :: String -> Maybe MimeType
fromString s =
  case String.split (Pattern "/") s of
    [t, st] ->
      if not (String.null t) && not (String.null st)
      then Just (MimeType t st)
      else Nothing
    _ -> Nothing

mimeType :: Type -> SubType -> MimeType
mimeType = MimeType

toString :: MimeType -> String
toString = show
