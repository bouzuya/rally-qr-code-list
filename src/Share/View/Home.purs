module Share.View.Home
  (view) where

import Prelude (Unit)
import Pux.DOM.HTML as P
import Share.State (State)
import Text.Smolder.HTML as H
import Text.Smolder.Markup as M

view :: State -> P.HTML Unit
view state = do
  H.html do
    H.body do
      H.h1 (M.text "Hello!!")
