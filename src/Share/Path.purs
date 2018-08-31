-- Original:
-- https://github.com/bouzuya/tamaru/blob/2fb02e4354df8a25804b2790defbb8d83ea67934/src/Server/Path.purs
module Share.Path
  ( NormalizedPath
  , fromString
  , normalizePath
  , toPieces
  , toString
  ) where

import Data.Array as Array
import Data.Foldable (intercalate)
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..))
import Data.String as String
import Prelude (not, (<<<), (<>), (==))

newtype NormalizedPath = NormalizedPath (Array String)

fromString :: String -> Maybe NormalizedPath
fromString path =
  let
    normalized = normalizePath path
  in
    if path == toString normalized
    then Just normalized
    else Nothing

normalizePath :: String -> NormalizedPath
normalizePath path =
  let
    pieces = String.split (Pattern "/") path
    parsed = Array.filter (not <<< String.null) pieces
  in
    NormalizedPath parsed

toPieces :: NormalizedPath -> Array String
toPieces (NormalizedPath parsed) = parsed

toString :: NormalizedPath -> String
toString (NormalizedPath parsed) = "/" <> (intercalate "/" parsed)
