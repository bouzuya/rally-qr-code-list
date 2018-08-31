module Share.View.StampRallyList
  (view) where

import Prelude (discard, ($))
import Pux.DOM.HTML as P
import Share.Event (Event)
import Share.State (State)
import Text.Smolder.HTML as H
import Text.Smolder.HTML.Attributes as HA
import Text.Smolder.Markup as M

view :: State -> P.HTML Event
view state = do
  H.div M.! HA.className "stamp-rally-list" $ do
    H.header $ do
      H.h1 $ do
        M.text "Stamp Rally List"
    H.div M.! HA.className "body" $ do
      H.p $ do
        M.text "Stamp Rally List!"
    H.footer do
      M.text ""
