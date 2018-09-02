module Share.View.StampRallyDetailPage
  (view) where

import Prelude (discard, ($))
import Pux.DOM.HTML as P
import Share.Event (Event)
import Share.Route as Route
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
    H.footer do
      M.text ""
