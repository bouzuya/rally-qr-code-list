module Test.Main
  ( main
  , showQrCodeDataUrl
  , showShortenUrl
  , showSpotDetail
  , showSpotList ) where

import Data.Maybe (maybe)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Exception (throw)
import Prelude (Unit, bind, discard, pure, show)
import Share.QrCode as QrCode
import Share.QrCode.ErrorCorrectionLevel as ErrorCorrectionLevel
import Share.Request.Rally as Rally
import Test.MimeType as MimeType
import Test.MimeTypeMap as MimeTypeMap
import Test.Unit.Main (runTest)

main :: Effect Unit
main = runTest do
  MimeType.tests
  MimeTypeMap.tests

showQrCodeDataUrl :: String -> Effect Unit
showQrCodeDataUrl text = launchAff_ do
  dataUrl <- QrCode.toDataUrl ErrorCorrectionLevel.L text
  liftEffect (log dataUrl)

showShortenUrl :: String -> Int -> String -> Effect Unit
showShortenUrl stampRallyId spotId qrCodeToken = launchAff_ do
  shortenUrlMaybe <- Rally.createShortenUrlToStampByQrCode stampRallyId spotId qrCodeToken
  shortenUrl <- maybe (liftEffect (throw "no shorten url")) pure shortenUrlMaybe
  liftEffect (log (show shortenUrl))

showSpotDetail :: { email :: String, password :: String } -> Int -> Effect Unit
showSpotDetail credentials spotId = launchAff_ do
  tokenMaybe <- Rally.createToken credentials
  token <- maybe (liftEffect (throw "no token")) pure tokenMaybe
  spotDetailMaybe <- Rally.getSpotDetail token spotId
  spotDetail <- maybe (liftEffect (throw "no spot")) pure spotDetailMaybe
  liftEffect (log (show spotDetail))

showSpotList :: { email :: String, password :: String } -> String -> Effect Unit
showSpotList credentials stampRallyId = launchAff_ do
  tokenMaybe <- Rally.createToken credentials
  token <- maybe (liftEffect (throw "no token")) pure tokenMaybe
  liftEffect (log (show token))
  spotListMaybe <- Rally.getSpotList token stampRallyId
  liftEffect (log (show spotListMaybe))
