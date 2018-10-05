module Server.StaticRouteMimeTypeMap
  ( getMimeTypeString ) where

import Bouzuya.MimeType (MimeType)
import Bouzuya.MimeType as MimeType
import Bouzuya.MimeTypeMap (Extension, MimeTypeMap)
import Bouzuya.MimeTypeMap as MimeTypeMap
import Data.Maybe (fromJust, fromMaybe)
import Data.Tuple (Tuple(..))
import Partial.Unsafe (unsafePartial)
import Prelude (map)

defaultMimeType :: MimeType
defaultMimeType =
  unsafePartial (fromJust (MimeType.fromString "application/octet-stream"))

mimeTypeMap :: MimeTypeMap
mimeTypeMap =
  MimeTypeMap.fromFoldable
    (map
      (\(Tuple m es) -> Tuple (unsafePartial (fromJust m)) es)
      [ Tuple (MimeType.fromString "application/javascript") [".js"]
      , Tuple (MimeType.fromString "image/jpeg") [".jpeg", ".jpg"]
      , Tuple (MimeType.fromString "image/png") [".png"]
      , Tuple (MimeType.fromString "text/css") [".css"]
      , Tuple (MimeType.fromString "text/html") [".html"]
      , Tuple (MimeType.fromString "text/plain") [".txt"]
      ])

getMimeTypeString :: Extension -> String
getMimeTypeString extension =
  MimeType.toString (fromMaybe defaultMimeType (MimeTypeMap.lookup extension mimeTypeMap))
