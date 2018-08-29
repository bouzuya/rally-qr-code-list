module Share.State
  ( State
  , init
  ) where

type State =
  { config ::
    { assetsBaseUrl :: String
    }
  , email :: String
  , password :: String
  }

init :: State
init =
  { config:
    { assetsBaseUrl: "http://localhost:8081" -- TODO: production
    }
  , email: "email@example.com"
  , password: "pass1"
  }
