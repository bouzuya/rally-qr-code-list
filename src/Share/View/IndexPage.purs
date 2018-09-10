module Share.View.IndexPage
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
  H.section M.! HA.className "index-page" $ do
    H.header $ do
      H.h1 $ do
        M.text "Index"
    H.div M.! HA.className "body" $ do
      M.text ""
    H.footer do
      M.text ""
