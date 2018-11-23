module Share.Request.Rally
  ( Detail
  , Image
  , SpotDetail
  , SpotList
  , SpotSummary
  , StampRallyList
  , StampRallySummary
  , Token
  , createShortenUrlToStampByQrCode
  , createToken
  , getSpotDetail
  , getSpotList
  , getStampRallyList
  ) where

import Bouzuya.HTTP.Client (body, fetch, headers, method, url)
import Bouzuya.HTTP.Method as Method
import Data.Either (either, hush)
import Data.Maybe (Maybe(..), maybe)
import Data.Nullable (Nullable)
import Data.Options ((:=))
import Data.Tuple (Tuple(..))
import Effect.Aff (Aff)
import Foreign.Object (Object)
import Foreign.Object as Object
import Prelude (bind, const, map, pure, show, (+), (<>))
import Simple.JSON (readJSON, writeJSON)

type Detail =
  { id :: Int
  , name :: String
  , position :: Int
  , value :: String
  }

type Image =
  { id :: String
  , position :: Int
  , s64 :: String -- URL
  , s640 :: String -- URL
  }

type ShortenUrl =
  { expandUrl :: String -- URL
  , name :: String
  , shortenUrl :: String -- URL
  }

type SpotDetail =
  { description :: Nullable String
  , details :: Array Detail
  , detailsCountLimit :: Int
  , displayEndDatetime :: String -- DateTime
  , displayEndDatetimeSpecified :: Boolean
  , displayStartDatetime :: String -- DateTime
  , displayStartDatetimeSpecified :: Boolean
  , endDatetime :: String -- DateTime
  , endDatetimeSpecified :: Boolean
  , id :: Int
  , images :: Array Image
  , lat :: String -- Number
  , lng :: String -- Number
  , lockVersion :: Int
  , name :: String
  , position :: Nullable Int
  , qrCodeToken :: String
  , radius :: Nullable String -- Number
  , stampByKeyword :: Boolean
  , stampByLocation :: Boolean
  , stampByQrCode :: Boolean
  , stampDurationEndTime :: Nullable String -- DateTime
  , stampDurationStartTime :: Nullable String -- DateTime
  , stampImages :: Array Image
  , stampKeyword :: Nullable String
  , stampRallyId :: String
  , stampTypeSpecified :: Boolean
  , startDatetime :: String -- DateTime
  , startDatetimeSpecified :: Boolean
  , tagline :: Nullable String
  , zoom :: Int
  }

type SpotList =
  { hasNextPage :: Boolean
  , spots :: Array SpotSummary
  }

type SpotSummary =
  { description :: Nullable String
  , id :: Int
  , image :: Nullable Image
  , lat :: String -- Number
  , lng :: String -- Number
  , lockVersion :: Int
  , name :: String
  , position :: Nullable Int
  , stampByLocation :: Boolean
  , stampByQrCode :: Boolean
  , stampImage :: Nullable Image
  , stampRallyId :: String
  , tagline :: Nullable String
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

createShortenUrlToStampByQrCode :: String -> Int -> String -> Aff (Maybe ShortenUrl)
createShortenUrlToStampByQrCode stampRallyId spotId qrCodeToken = do
  let path = "/s"
  response <-
    fetch
      ( body :=
          writeJSON
            { qr_code_token: qrCodeToken
            , spot_id: spotId
            , stamp_rally_id: stampRallyId }
      <> headers := buildHeaders
      <> method := Method.POST
      <> url := (baseUrl <> path <> "?view_type=admin"))
  pure do
    body <- response.body
    shortenUrl <- hush (readJSON body)
    pure shortenUrl :: Maybe ShortenUrl

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
    token <- hush (readJSON body)
    pure token :: Maybe Token

getSpotDetail :: Token -> Int -> Aff (Maybe SpotDetail)
getSpotDetail token spotId = do
  let path = "/spots/" <> show spotId
  response <-
    fetch
      ( headers := buildHeadersWithToken token
      <> method := Method.GET
      <> url := (baseUrl <> path <> "?view_type=admin"))
  pure do
    body <- response.body
    spotList <- hush (readJSON body)
    pure spotList :: Maybe SpotDetail

getSpotList :: Token -> String -> Aff (Maybe SpotList)
getSpotList token stampRallyId = do
  spotsMaybe <- g Nothing 1
  pure (map (\spots -> { hasNextPage: false, spots }) spotsMaybe)
  where
    g :: Maybe (Array SpotSummary) -> Int -> Aff (Maybe (Array SpotSummary))
    g result page = do
      spotListMaybe <- f 100 page
      case spotListMaybe of
        Nothing -> pure result
        Just c ->
          let
            newResult = maybe (Just c.spots) (\r -> Just (r <> c.spots)) result
          in
            if c.hasNextPage
            then g newResult (page + 1)
            else pure newResult
    f per page = do
      let path = "/stamp_rallies/" <> stampRallyId <> "/spots"
      response <-
        fetch
          ( headers := buildHeadersWithToken token
          <> method := Method.GET
          <> url := (baseUrl <> path <> "?per=" <> show per <> "&page=" <> show page <> "&view_type=admin"))
      pure do
        body <- response.body
        spotList <- hush (readJSON body)
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
    stampRallyList <- hush (readJSON body)
    pure stampRallyList :: Maybe StampRallyList
