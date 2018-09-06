module Share.Event
  ( Event(..)
  ) where

import Pux.DOM.Events (DOMEvent)
import Share.Request (StampRally, Token, Spot)
import Share.Route as Route

data Event
  = EmailChange DOMEvent
  | FetchSpotList String
  | FetchSpotListSuccess (Array Spot)
  | FetchStampRallyList
  | FetchStampRallyListSuccess (Array StampRally)
  | PasswordChange DOMEvent
  | RouteChange Route.Route
  | SignIn DOMEvent
  | SignInSuccess Token
  | SignOut DOMEvent
  | UpdateQrCodeList (Array { dataUrl :: String, spotId :: Int })
