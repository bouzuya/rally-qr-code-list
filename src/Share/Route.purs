module Share.Route
  ( Route(..)
  , route
  ) where

import Share.Path (normalizePath, toPieces)

data Route
  = SignIn
  | StampRallyList

route :: String -> Route
route path =
  let
    normalized = normalizePath path
  in
    case toPieces normalized of
      [] -> SignIn
      ["stamp_rallies"] -> StampRallyList
      _ -> SignIn -- default
