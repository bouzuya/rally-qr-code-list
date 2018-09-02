module Share.Request
  ( Spot
  , StampRally
  , RallyToken
  , createToken
  , getSpotList
  , getStampRallyList
  ) where

import Bouzuya.HTTP.Client (body, fetch, headers, method, url)
import Bouzuya.HTTP.Method as Method
import Control.Monad.Maybe.Trans (MaybeT(..), runMaybeT)
import Data.Either (either)
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toMaybe)
import Data.Options ((:=))
import Data.Tuple (Tuple(..))
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Foreign.Object as Object
import Prelude (bind, const, discard, map, pure, show, (<>))
import Simple.JSON (readJSON, writeJSON)

type RallyImage =
  { id :: String
  , position :: Int
  , s64 :: String -- URL
  , s640 :: String -- URL
  }

type RallySpotList =
  { hasNextPage :: Boolean
  , spots :: Array RallySpotSummary
  }

type RallySpotSummary =
  { description :: String
  , id :: Int
  , image :: Nullable RallyImage
  , lat :: String -- Number
  , lng :: String -- Number
  , lockVersion :: Int
  , name :: String
  , position :: Int
  , stampByLocation :: Boolean
  , stampByQrCode :: Boolean
  , stampImage :: Nullable RallyImage
  , stampRallyId :: String
  , tagline :: String
  , zoom :: Int
  }

type RallyStampRallyList =
  { hasNextPage :: Boolean
  , stampRallies :: Array RallyStampRallySummary
  }

type RallyStampRallySummary =
  { createdAt :: String -- DateTime
  , display :: Boolean
  , displayEndDatetime :: String -- DateTime
  , displayName :: String
  , displayStartDatetime :: String -- DateTime
  , expiredAt :: String -- DateTime
  , image :: Nullable RallyImage
  , isStandardPlan :: Boolean
  , name :: String
  , noStampedStampCardsCountLimitEnabled :: Boolean
  , ownerDisplayName :: String
  , role :: String
  , stampedStampCardsCount :: Int
  , stampedStampCardsCountLimit :: Int
  , unconfirmedOwner :: Boolean
  , updatedAt :: String -- DateTime
  }

type RallyToken =
  { expiredAt :: String -- DateTime
  , refreshToken :: String
  , refreshTokenExpiredAt :: String -- DateTime
  , token :: String
  , userId :: String
  }

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

createToken :: { email :: String, password :: String } -> Aff (Maybe RallyToken)
createToken params = do
  response <-
    fetch
      ( body := writeJSON params
      <> headers := Object.fromFoldable [Tuple "Content-Type" "application/json"]
      <> method := Method.POST
      <> url := "https://api.rallyapp.jp/tokens")
  pure do
    body <- response.body
    token <- either (const Nothing) Just (readJSON body)
    pure token :: Maybe RallyToken

getSpotList :: RallyToken -> String -> Aff (Maybe (Array Spot))
getSpotList token stampRallyId = runMaybeT do
  spotList <- MaybeT (getSpotList' token stampRallyId)
  pure (map toSpot spotList.spots)
  where
    toSpot { id, image, name } =
      { id, image: (map (\{ s640 } -> s640) (toMaybe image)), name }

getSpotList' :: RallyToken -> String -> Aff (Maybe RallySpotList)
getSpotList' token stampRallyId = do
  response <-
    fetch
      ( headers :=
          Object.fromFoldable
            [ Tuple "Content-Type" "application/json"
            , Tuple "Authorization" ("Token token=" <> token.token)]
      <> method := Method.GET
      <> url := ("https://api.rallyapp.jp/stamp_rallies/" <> stampRallyId <> "/spots?view_type=admin"))
  liftEffect (log (show response.body))
  pure do
    body <- response.body
    spotList <- either (const Nothing) Just (readJSON body)
    pure spotList :: Maybe RallySpotList

getStampRallyList :: RallyToken -> Aff (Maybe (Array StampRally))
getStampRallyList token = runMaybeT do
  stampRallyList <- MaybeT (getStampRallyList' token)
  pure (map toStampRally stampRallyList.stampRallies)
  where
    toStampRally { displayName, image, name } =
      { displayName, image: (map (\{ s640 } -> s640) (toMaybe image)), name }

getStampRallyList' :: RallyToken -> Aff (Maybe RallyStampRallyList)
getStampRallyList' token = do
  response <-
    fetch
      ( headers :=
          Object.fromFoldable
            [ Tuple "Content-Type" "application/json"
            , Tuple "Authorization" ("Token token=" <> token.token)]
      <> method := Method.GET
      <> url := ("https://api.rallyapp.jp/users/" <> token.userId <> "/stamp_rallies"))
  pure do
    body <- response.body
    stampRallyList <- either (const Nothing) Just (readJSON body)
    pure stampRallyList :: Maybe RallyStampRallyList
