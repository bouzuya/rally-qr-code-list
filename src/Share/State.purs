module Share.State
  ( State
  , init
  ) where

type State =
  { email :: String
  , password :: String
  }

init :: State
init =
  { email: "email@example.com"
  , password: "pass1"
  }
