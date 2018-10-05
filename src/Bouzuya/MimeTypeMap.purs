module Bouzuya.MimeTypeMap
  ( Extension
  , MimeTypeMap
  , fromFoldable
  , lookup
  ) where

import Bouzuya.MimeType (MimeType)
import Data.Foldable (class Foldable, foldr)
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe)
import Data.Tuple (Tuple(..))

type Extension = String -- ".html"
newtype MimeTypeMap = MimeTypeMap (Map Extension MimeType)

fromFoldable :: forall f. Foldable f => f (Tuple MimeType (Array Extension)) -> MimeTypeMap
fromFoldable f =
  MimeTypeMap (foldr insert Map.empty f)
  where
  insert (Tuple mimeType extensions) mm =
    foldr (\e m -> Map.insert e mimeType m) mm extensions

lookup :: Extension -> MimeTypeMap -> Maybe MimeType
lookup extension (MimeTypeMap m) = Map.lookup extension m
