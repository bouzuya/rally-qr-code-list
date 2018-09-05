module Share.View.ServerRoot
  (view) where

import Prelude (discard, ($), (<>))
import Pux.DOM.HTML as P
import Pux.DOM.HTML.Attributes as PA
import Share.Event (Event)
import Share.State (State)
import Share.State as State
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
      H.div M.! HA.className "root" $ do
        ClientRoot.view state
      H.script M.! PA.data_ "initial-state" (State.serialize state) M.! HA.src scriptUrl $ do
        M.text ""
  where
    scriptUrl = state.config.assetsBaseUrl <> "/script/index.js"
