module Share.View.SpotList
  (view) where

import Data.Foldable (find, for_)
import Data.Maybe (Maybe(..))
import Prelude (discard, ($), (==))
import Pux.DOM.HTML as P
import Share.Event (Event)
import Share.Request (Spot)
import Text.Smolder.HTML as H
import Text.Smolder.HTML.Attributes as HA
import Text.Smolder.Markup as M

view
  ::
    { qrCodeList :: Array { spotId :: Int, dataUrl :: String }
    , spotList :: Array Spot
    }
  -> P.HTML Event
view { qrCodeList, spotList } = do
  H.div M.! HA.className "spot-list" $ do
    H.ul $ do
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
