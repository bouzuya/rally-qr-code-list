module Share.Request
  ( Spot
  , StampRally
  , Token
  , createToken
  , getSpotList
  , getStampRallyList
  ) where

import Control.Monad.Maybe.Trans (MaybeT(..), runMaybeT)
import Data.Maybe (Maybe)
import Data.Nullable (toMaybe)
import Data.Traversable (sequence, traverse)
import Effect.Aff (Aff)
import Prelude (bind, map, pure)
import Share.Request.Rally (SpotSummary)
import Share.Request.Rally as Rally

type Token = Rally.Token

type Spot =
  { id :: Int
  , image :: Maybe String
  , name :: String
  , shortenUrl :: String -- URL
  }

type StampRally =
  { displayName :: String
  , image :: Maybe String
  , name :: String
  }

createToken :: { email :: String, password :: String } -> Aff (Maybe Token)
createToken params = Rally.createToken params

getSpotList :: Token -> String -> Aff (Maybe (Array Spot))
getSpotList token stampRallyId = runMaybeT do
  let
    fetchAndParse :: SpotSummary -> Aff (Maybe Spot)
    fetchAndParse spot = runMaybeT do
      spotDetail <- MaybeT (Rally.getSpotDetail token spot.id)
      shortenUrl <-
        MaybeT
          (Rally.createShortenUrlToStampByQrCode
            stampRallyId
            spotDetail.id
            spotDetail.qrCodeToken)
      pure (toSpot spot shortenUrl)
    toSpot { id, image, name } { shortenUrl } =
      { id, image: (map (\{ s640 } -> s640) (toMaybe image)), name, shortenUrl }
  spotList <- MaybeT (Rally.getSpotList token stampRallyId)
  MaybeT (map sequence (traverse fetchAndParse spotList.spots))

getStampRallyList :: Token -> Aff (Maybe (Array StampRally))
getStampRallyList token = runMaybeT do
  stampRallyList <- MaybeT (Rally.getStampRallyList token)
  pure (map toStampRally stampRallyList.stampRallies)
  where
    toStampRally { displayName, image, name } =
      { displayName, image: (map (\{ s640 } -> s640) (toMaybe image)), name }
