module Share.Cookie
  ( loadToken
  , saveToken
  ) where

import Control.Monad.Maybe.Trans (MaybeT(..), lift, runMaybeT)
import Data.Either (either)
import Data.JSDate as JSDate
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toMaybe)
import Effect (Effect)
import Effect.Now (now)
import Prelude (Unit, bind, const, map, pure, (<))
import Share.Request (Token)
import Simple.JSON (readJSON, writeJSON)

foreign import loadTokenImpl :: Effect (Nullable String)
foreign import removeTokenImpl :: Effect Unit
foreign import saveTokenImpl :: String -> Effect Unit

loadToken :: Effect (Maybe Token)
loadToken = runMaybeT do
  rawToken <- MaybeT (map toMaybe loadTokenImpl)
  token <- MaybeT (pure (either (const Nothing) Just (readJSON rawToken)))
  instant <- lift (map JSDate.fromInstant now)
  expiredAt <- lift (JSDate.parse token.expiredAt)
  MaybeT (pure (if expiredAt < instant then Nothing else (Just token)))

saveToken :: Maybe Token -> Effect Unit
saveToken (Just token) = saveTokenImpl (writeJSON token)
saveToken Nothing = removeTokenImpl
