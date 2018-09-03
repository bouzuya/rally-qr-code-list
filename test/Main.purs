module Test.Main
  ( main
  , showSpotList ) where

import Data.Maybe (maybe)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Exception (throw)
import Prelude (Unit, bind, discard, pure, show)
import Share.Request (createToken, getSpotList)

main :: Effect Unit
main = log "Test"

showSpotList :: { email :: String, password :: String } -> String -> Effect Unit
showSpotList credentials stampRallyId = launchAff_ do
  tokenMaybe <- createToken credentials
  token <- maybe (liftEffect (throw "no token")) pure tokenMaybe
  liftEffect (log (show token))
  spotList <- getSpotList token stampRallyId
  liftEffect (log (show spotList))
