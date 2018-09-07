module Share.Style
  ( style
  ) where

import CSS (CSS, body, fromString, h1, html, margin, px)
import Prelude (discard, (#))
import Share.Style.ClientRoot as ClientRoot
import Share.Style.Selector ((?>))

style :: CSS
style = do
  html ?> do
    margin (0.0 # px) (0.0 # px) (0.0 # px) (0.0 # px)
  body ?> do
    margin (0.0 # px) (0.0 # px) (0.0 # px) (0.0 # px)
  h1 ?> do
    margin (0.0 # px) (0.0 # px) (0.0 # px) (0.0 # px)
  fromString ".root" ?> do
    ClientRoot.style
