module Share.Event.InternalEvent
  ( InternalEvent(..)
  ) where

import Data.Maybe (Maybe)
import Share.Request (Spot, StampRally, Token)
import Share.Route as Route

data InternalEvent
  = FetchSpotList String
  | FetchSpotListSuccess (Array Spot)
  | FetchStampRallyList
  | FetchStampRallyListSuccess (Array StampRally)
  | GenerateQrCodeList
  | RouteChange Route.Route (Maybe Boolean)
  | SignInSuccess Token
  | UpdateQrCodeList (Array { dataUrl :: String, spotId :: Int })
