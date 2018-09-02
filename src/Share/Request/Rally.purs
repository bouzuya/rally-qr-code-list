module Share.Request.Rally
  ( Image
  , SpotList
  , SpotSummary
  , StampRallyList
  , StampRallySummary
  , Token
  , createToken
  , getSpotList
  , getStampRallyList
  ) where

import Bouzuya.HTTP.Client (body, fetch, headers, method, url)
import Bouzuya.HTTP.Method as Method
import Data.Either (either)
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable)
import Data.Options ((:=))
import Data.Tuple (Tuple(..))
import Effect.Aff (Aff)
import Foreign.Object (Object)
import Foreign.Object as Object
import Prelude (bind, const, pure, (<>))
import Simple.JSON (readJSON, writeJSON)

type Image =
  { id :: String
  , position :: Int
  , s64 :: String -- URL
  , s640 :: String -- URL
  }

type SpotList =
  { hasNextPage :: Boolean
  , spots :: Array SpotSummary
  }

type SpotSummary =
  { description :: String
  , id :: Int
  , image :: Nullable Image
  , lat :: String -- Number
  , lng :: String -- Number
  , lockVersion :: Int
  , name :: String
  , position :: Int
  , stampByLocation :: Boolean
  , stampByQrCode :: Boolean
  , stampImage :: Nullable Image
  , stampRallyId :: String
  , tagline :: String
  , zoom :: Int
  }

type StampRallyList =
  { hasNextPage :: Boolean
  , stampRallies :: Array StampRallySummary
  }

type StampRallySummary =
  { createdAt :: String -- DateTime
  , display :: Boolean
  , displayEndDatetime :: String -- DateTime
  , displayName :: String
  , displayStartDatetime :: String -- DateTime
  , expiredAt :: String -- DateTime
  , image :: Nullable Image
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

type Token =
  { expiredAt :: String -- DateTime
  , refreshToken :: String
  , refreshTokenExpiredAt :: String -- DateTime
  , token :: String
  , userId :: String
  }

baseUrl :: String
baseUrl = "https://api.rallyapp.jp"

buildHeaders :: Object String
buildHeaders = Object.fromFoldable [Tuple "Content-Type" "application/json"]

buildHeadersWithToken :: Token -> Object String
buildHeadersWithToken token =
  Object.insert "Authorization" ("Token token=" <> token.token) buildHeaders

createToken :: { email :: String, password :: String } -> Aff (Maybe Token)
createToken params = do
  let path = "/tokens"
  response <-
    fetch
      ( body := writeJSON params
      <> headers := buildHeaders
      <> method := Method.POST
      <> url := (baseUrl <> path))
  pure do
    body <- response.body
    token <- either (const Nothing) Just (readJSON body)
    pure token :: Maybe Token

getSpotList :: Token -> String -> Aff (Maybe SpotList)
getSpotList token stampRallyId = do
  let path = "/stamp_rallies/" <> stampRallyId <> "/spots"
  response <-
    fetch
      ( headers := buildHeadersWithToken token
      <> method := Method.GET
      <> url := (baseUrl <> path <> "?view_type=admin"))
  pure do
    body <- response.body
    spotList <- either (const Nothing) Just (readJSON body)
    pure spotList :: Maybe SpotList

getStampRallyList :: Token -> Aff (Maybe StampRallyList)
getStampRallyList token = do
  let path = "/users/" <> token.userId <> "/stamp_rallies"
  response <-
    fetch
      ( headers := buildHeadersWithToken token
      <> method := Method.GET
      <> url := (baseUrl <> path))
  pure do
    body <- response.body
    stampRallyList <- either (const Nothing) Just (readJSON body)
    pure stampRallyList :: Maybe StampRallyList
