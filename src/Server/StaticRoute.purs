module Server.StaticRoute
  ( staticRoute
  ) where

import Bouzuya.HTTP.Server.Uint8Array as ArrayBuffer
import Control.Monad.Maybe.Trans (MaybeT(..), lift, runMaybeT)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Node.FS.Stats as Stats
import Node.FS.Sync as FS
import Node.Path as Path
import Prelude (Unit, bind, discard, map, pure, unit)
import Server.StaticRouteMimeTypeMap (getMimeTypeString)
import Type.Data.Boolean (kind Boolean)

normalizeRemotePath :: String -> Maybe String
normalizeRemotePath path =
  let
    normalizedPath = Path.normalize path
  in
    if Path.isAbsolute normalizedPath
    then Just normalizedPath
    else Nothing

remotePathToLocalPath :: String -> String -> String
remotePathToLocalPath localRootPath normalizedPath =
  Path.concat [localRootPath, normalizedPath]

staticRoute
  :: String
  -> String
  -> Effect
    (Maybe
      { binary :: Uint8Array
      , extension :: String
      , localPath :: String
      , mimeType :: String
      , path :: String
      })
staticRoute localRootPath path = runMaybeT do
  normalizedPath <- MaybeT (pure (normalizeRemotePath path))
  let localPath = remotePathToLocalPath localRootPath normalizedPath
  MaybeT (guard' (FS.exists localPath))
  MaybeT (guard' (map Stats.isFile (FS.stat localPath)))
  let extension = Path.extname normalizedPath
  let mimeType = getMimeTypeString extension
  buffer <- lift (FS.readFile localPath)
  binary <- lift (ArrayBuffer.fromBuffer buffer)
  pure { binary, extension, localPath, mimeType,  path: normalizedPath }
  where
  guard' :: Effect Boolean -> Effect (Maybe Unit)
  guard' = map (\b -> if b then Just unit else Nothing)
