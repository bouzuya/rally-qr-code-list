module Share.Cookie
  ( loadToken
  , saveToken
  ) where

import Data.Either (either)
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toMaybe)
import Effect (Effect)
import Prelude (Unit, bind, const, pure)
import Share.Request (Token)
import Simple.JSON (readJSON, writeJSON)

foreign import loadTokenImpl :: Effect (Nullable String)
foreign import removeTokenImpl :: Effect Unit
foreign import saveTokenImpl :: String -> Effect Unit

loadToken :: Effect (Maybe Token)
loadToken = do
  tokenNullable <- loadTokenImpl
  let tokenMaybe = toMaybe tokenNullable
  pure case tokenMaybe of
    Nothing -> Nothing
    Just r -> either (const Nothing) Just (readJSON r)

saveToken :: Maybe Token -> Effect Unit
saveToken (Just token) = saveTokenImpl (writeJSON token)
saveToken Nothing = removeTokenImpl
