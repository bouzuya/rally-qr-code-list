module Share.Event.InternalEventHandler
  ( foldp
  ) where

import Data.Maybe (Maybe(..))
import Data.Traversable (traverse)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Prelude (bind, discard, pure, show, ($), (<$>))
import Pux (EffModel, noEffects, onlyEffects)
import Share.Cookie as Cookie
import Share.Event.InternalEvent (InternalEvent(..))
import Share.QrCode as QrCode
import Share.QrCode.ErrorCorrectionLevel (ErrorCorrectionLevel)
import Share.Request (Spot, getSpotList, getStampRallyList)
import Share.Route as Route
import Share.State (State)
import Simple.JSON (undefined)
import Web.HTML (window)
import Web.HTML.History as History
import Web.HTML.Window (history)

foldp :: InternalEvent -> State -> EffModel State InternalEvent
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
  , effects: [ pure (Just GenerateQrCodeList)
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
foldp GenerateQrCodeList state =
  onlyEffects
    state
    [
      do
        let
          generateQrCode :: ErrorCorrectionLevel -> Spot -> Aff { dataUrl :: String, spotId :: Int }
          generateQrCode level spot = do
            dataUrl <- QrCode.toDataUrl level spot.shortenUrl
            pure { dataUrl: dataUrl, spotId: spot.id }
        case state.spotList of
          Nothing -> pure (Just (UpdateQrCodeList []))
          Just spotList -> do
            qrCodeList <- traverse (generateQrCode state.errorCorrectionLevel) spotList
            pure (Just (UpdateQrCodeList qrCodeList))
    ]
foldp (RouteChange route replaceMaybe) state =
  { state:
      state
        { qrCodeList = case route of
            Route.StampRallyDetail _ -> []
            _ -> state.qrCodeList
        , route = route
        , spotList = case route of
            Route.StampRallyDetail _ -> Nothing
            _ -> state.spotList
        , stampRallyList = case route of
            Route.StampRallyList -> Nothing
            _ -> state.stampRallyList
        }
  , effects:
    [
      case replaceMaybe of
        Nothing -> pure Nothing
        Just _ -> liftEffect do
          w <- window
          h <- history w
          History.pushState
            undefined
            (History.DocumentTitle "")
            (History.URL (show route))
            h
          pure Nothing
    , do
        case route of
          Route.Index -> do
            pure (Just (RouteChange Route.SignIn (Just false)))
          Route.SignIn -> do
            tokenMaybe <- liftEffect Cookie.loadToken
            pure (SignInSuccess <$> tokenMaybe)
          Route.StampRallyDetail stampRallyId ->
            pure (Just (FetchSpotList stampRallyId))
          Route.StampRallyList ->
            pure (Just FetchStampRallyList)
    ]
  }
foldp (SignInSuccess token) state =
  { state: state { token = Just token }
  , effects:
    [ pure (Just (RouteChange Route.StampRallyList (Just true)))
    , do
        liftEffect (Cookie.saveToken (Just token))
        pure Nothing
    ]
  }
foldp (UpdateQrCodeList qrCodeList) state =
  noEffects $ state { qrCodeList = qrCodeList }
