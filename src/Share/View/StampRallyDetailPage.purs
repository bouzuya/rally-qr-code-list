module Share.View.StampRallyDetailPage
  (view) where

import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Prelude (discard, ($))
import Pux.DOM.HTML as P
import Share.Event (Event)
import Share.State (State)
import Text.Smolder.HTML as H
import Text.Smolder.HTML.Attributes as HA
import Text.Smolder.Markup as M

view :: State -> String -> P.HTML Event
view state stampRallyId = do
  H.section M.! HA.className "stamp-rally-detail-page" $ do
    H.header $ do
      H.h1 $ do
        M.text "Stamp Rally Detail"
    H.div M.! HA.className "body" $ do
      H.p $ do
        M.text stampRallyId
      case state.spotList of
        Nothing -> M.text "loading..."
        Just spotList ->
          H.ul $ do
            for_ spotList \i -> do
              H.li $ do
                M.text i.name
    H.footer do
      M.text ""
