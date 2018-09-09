module Share.View.SpotList
  (view) where

import Data.Foldable (find, for_)
import Data.Maybe (Maybe(..))
import Prelude (discard, ($), (<>), (==))
import Pux.DOM.Events as PE
import Pux.DOM.HTML as P
import Share.Event (Event(..))
import Share.Request (Spot)
import Text.Smolder.HTML as H
import Text.Smolder.HTML.Attributes as HA
import Text.Smolder.Markup as M

labeledInput' :: String -> String -> String -> String -> Boolean -> (PE.DOMEvent -> Event) -> P.HTML Event
labeledInput' type' name label value checked onChange = do
  H.label M.! HA.className name $ do
    H.span M.! HA.className "label" $ do
      M.text label
    H.span M.! HA.className "value" $ do
      H.input
        M.! HA.name name
        M.! HA.type' type'
        M.! HA.value value
        M.#! PE.onChange onChange
        M.!? checked $ HA.checked "checked"

view
  ::
    { qrCodeList :: Array { spotId :: Int, dataUrl :: String }
    , selected :: String
    , spotList :: Array Spot
    }
  -> P.HTML Event
view { qrCodeList, selected, spotList } = do
  H.div M.! HA.className "spot-list" $ do
    H.div M.! HA.className "selector" $ do
      labeledInput' "radio" "url-or-qr-code" "URL" "url" (selected == "url") UrlSelect
      labeledInput' "radio" "url-or-qr-code" "QR code" "qr" (selected == "qr")  QrCodeSelect
    H.ul M.! HA.className ("is-selected-" <> selected) $ do
      for_ spotList \i -> do
        H.li $ do
          H.span M.! HA.className "name" $ do
            M.text i.name
          H.span M.! HA.className "url" $ do
            M.text i.shortenUrl
          H.span M.! HA.className "qr-code" $ do
            case find (\{ spotId } -> spotId == i.id) qrCodeList of
              Nothing -> M.text "loding..."
              Just { dataUrl } -> H.img M.! HA.src dataUrl
