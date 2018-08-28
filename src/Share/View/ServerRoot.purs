module Share.View.ServerRoot
  (view) where

import Prelude (discard, ($))
import Pux.DOM.HTML as P
import Share.Event (Event)
import Share.State (State)
import Share.View.ClientRoot as ClientRoot
import Text.Smolder.HTML as H
import Text.Smolder.HTML.Attributes as HA
import Text.Smolder.Markup as M

view :: State -> P.HTML Event
view state = do
  H.html $ do
    H.head $ do
      H.meta M.! HA.charset "UTF-8"
      H.title $ do
        M.text "RALLY QR code list"
    H.body $ do
      ClientRoot.view state
      H.script M.! HA.src "http://localhost:8081/script/index.js" $ do -- TODO
        M.text ""
