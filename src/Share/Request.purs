module Share.Request
  ( RallyToken
  , createToken
  ) where

import Bouzuya.HTTP.Client (body, fetch, headers, method, url)
import Bouzuya.HTTP.Method as Method
import Data.Either (either)
import Data.Maybe (Maybe(..))
import Data.Options ((:=))
import Data.Tuple (Tuple(..))
import Effect.Aff (Aff)
import Foreign.Object as Object
import Prelude (bind, const, pure, (<>))
import Simple.JSON (readJSON, writeJSON)

type RallyToken =
  { expiredAt :: String -- DateTime
  , refreshToken :: String
  , refreshTokenExpiredAt :: String -- DateTime
  , token :: String
  , userId :: String
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
