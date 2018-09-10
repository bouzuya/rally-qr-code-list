module Share.Route
  ( Route(..)
  , route
  ) where

import Control.Monad.Except (except)
import Data.Either (Either(..))
import Data.List.NonEmpty as NonEmptyList
import Foreign (F, ForeignError(..))
import Prelude (class Show, bind, (<>))
import Share.Path (normalizePath, toPieces)
import Simple.JSON (class ReadForeign, class WriteForeign, readImpl, writeImpl)

data Route
  = Index
  | SignIn
  | StampRallyDetail String
  | StampRallyList

type RouteRecord = { name :: String, params :: Array String }

instance readForeignRoute :: ReadForeign Route where
  readImpl f = do
    o <- readImpl f :: F RouteRecord
    except case o of
      { name: "Index" } ->
        Right Index
      { name: "SignIn" } ->
        Right SignIn
      { name: "StampRallyDetail", params: [stampRallyId] } ->
        Right (StampRallyDetail stampRallyId)
      { name: "StampRallyList" } ->
        Right StampRallyList
      _ ->
        Left (NonEmptyList.singleton (ForeignError "Unknown Route"))

instance showRoute :: Show Route where
  show Index = "/" -- TODO
  show SignIn = "/sign_in" -- TODO
  show (StampRallyDetail stampRallyId) = "/stamp_rallies/" <> stampRallyId
  show StampRallyList = "/stamp_rallies"

instance writeForeignRoute :: WriteForeign Route where
  writeImpl Index =
    writeImpl ({ name: "Index", params: [] } :: RouteRecord)
  writeImpl SignIn =
    writeImpl ({ name: "SignIn", params: [] } :: RouteRecord)
  writeImpl (StampRallyDetail stampRallyId) =
    writeImpl { name: "StampRallyDetail", params: [stampRallyId] }
  writeImpl StampRallyList =
    writeImpl ({ name: "StampRallyList", params: [] } :: RouteRecord)

route :: String -> Route
route path =
  let
    normalized = normalizePath path
  in
    case toPieces normalized of
      [] -> Index
      ["sign_in"] -> SignIn
      ["stamp_rallies"] -> StampRallyList
      ["stamp_rallies", stampRallyId] -> StampRallyDetail stampRallyId
      _ -> Index -- default
