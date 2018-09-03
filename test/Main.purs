module Test.Main
  ( main
  , showShortenUrl
  , showSpotList ) where

import Data.Maybe (maybe)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Exception (throw)
import Prelude (Unit, bind, discard, pure, show)
import Share.Request (createToken, getSpotList)
import Share.Request.Rally (createShortenUrlToStampByQrCode)

main :: Effect Unit
main = log "Test"

showShortenUrl :: String -> Int -> String -> Effect Unit
showShortenUrl stampRallyId spotId qrCodeToken = launchAff_ do
  shortenUrlMaybe <- createShortenUrlToStampByQrCode stampRallyId spotId qrCodeToken
  shortenUrl <- maybe (liftEffect (throw "no shorten url")) pure shortenUrlMaybe
  liftEffect (log (show shortenUrl))

showSpotList :: { email :: String, password :: String } -> String -> Effect Unit
showSpotList credentials stampRallyId = launchAff_ do
  tokenMaybe <- createToken credentials
  token <- maybe (liftEffect (throw "no token")) pure tokenMaybe
  liftEffect (log (show token))
  spotListMaybe <- getSpotList token stampRallyId
  liftEffect (log (show spotListMaybe))
