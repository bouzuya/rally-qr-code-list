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
import Effect.Aff (Aff)
import Prelude (bind, map, pure)
import Share.Request.Rally as Rally

type Token = Rally.Token

type Spot =
  { id :: Int
  , image :: Maybe String
  , name :: String
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
  spotList <- MaybeT (Rally.getSpotList token stampRallyId)
  pure (map toSpot spotList.spots)
  where
    toSpot { id, image, name } =
      { id, image: (map (\{ s640 } -> s640) (toMaybe image)), name }

getStampRallyList :: Token -> Aff (Maybe (Array StampRally))
getStampRallyList token = runMaybeT do
  stampRallyList <- MaybeT (Rally.getStampRallyList token)
  pure (map toStampRally stampRallyList.stampRallies)
  where
    toStampRally { displayName, image, name } =
      { displayName, image: (map (\{ s640 } -> s640) (toMaybe image)), name }
