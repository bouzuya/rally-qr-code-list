module Share.Event
  ( Event(..)
  , foldp
  ) where

import Data.Maybe (Maybe(..))
import Data.Traversable (traverse)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Prelude (bind, discard, pure, ($), (<$>))
import Pux (EffModel, noEffects, onlyEffects)
import Pux.DOM.Events (DOMEvent, targetValue)
import Share.Cookie as Cookie
import Share.QrCode as QrCode
import Share.Request (Spot, StampRally, Token, createToken, getSpotList, getStampRallyList)
import Share.Route as Route
import Share.State (State)
import Web.Event.Event (preventDefault)

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

foldp :: Event -> State -> EffModel State Event
foldp (EmailChange event) state =
  noEffects $ state { email = targetValue event }
foldp (FetchSpotList stampRallyid) state =
  onlyEffects
    state
    [
      do
        case state.spotList of
          Just _ -> pure Nothing
          Nothing ->
            case state.token of
              Just token -> do
                spotListMaybe <- getSpotList token stampRallyid
                pure (FetchSpotListSuccess <$> spotListMaybe)
              Nothing -> pure Nothing
    ]
foldp (FetchSpotListSuccess spotList) state =
  { state: state { spotList = Just spotList }
  , effects: [
      do
        let
          generateQrCode :: Spot -> Aff { dataUrl :: String, spotId :: Int }
          generateQrCode spot = do
            dataUrl <- QrCode.toDataUrl QrCode.M spot.shortenUrl
            pure { dataUrl: dataUrl, spotId: spot.id }
        qrCodeList <- traverse generateQrCode spotList
        pure (Just (UpdateQrCodeList qrCodeList))
    ]
  }
foldp FetchStampRallyList state =
  onlyEffects
    state
    [
      do
        case state.stampRallyList of
          Just _ -> pure Nothing
          Nothing ->
            case state.token of
              Just token -> do
                stampRallyListMaybe <- getStampRallyList token
                pure (FetchStampRallyListSuccess <$> stampRallyListMaybe)
              Nothing -> pure Nothing
    ]
foldp (FetchStampRallyListSuccess stampRallyList) state =
  noEffects $ state { stampRallyList = Just stampRallyList }
foldp (PasswordChange event) state =
  noEffects $ state { password = targetValue event }
foldp (RouteChange route) state =
  { state: state { route = route }
  , effects:
    [ do
        case route of
          Route.SignIn -> do
            tokenMaybe <- liftEffect Cookie.loadToken
            case tokenMaybe of
              Nothing -> pure Nothing
              Just token -> pure (Just (SignInSuccess token))
          Route.StampRallyDetail stampRallyId ->
            pure (Just (FetchSpotList stampRallyId))
          Route.StampRallyList ->
            pure (Just FetchStampRallyList)
    ]
  }
foldp (SignIn event) state =
  { state
  , effects:
    [ do
        liftEffect $ preventDefault event
        tokenMaybe <- createToken { email: state.email, password: state.password }
        pure $ SignInSuccess <$> tokenMaybe
    ]
  }
foldp (SignInSuccess token) state =
  { state: state { token = Just token }
  , effects:
    [ pure (Just (RouteChange Route.StampRallyList))
    , do
        liftEffect (Cookie.saveToken (Just token))
        pure Nothing
    ]
  }
foldp (SignOut event) state =
  { state: state { token = Nothing }
  , effects:
    [ do
        liftEffect (preventDefault event)
        liftEffect (Cookie.saveToken Nothing)
        pure (Just (RouteChange Route.SignIn))
    ]
  }

foldp (UpdateQrCodeList qrCodeList) state =
  noEffects $ state { qrCodeList = qrCodeList }
