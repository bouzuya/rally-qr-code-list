module Share.Style.IndexPage
  ( style
  ) where

import CSS (CSS, Selector, block, display, displayNone, fontSize, footer, fromString, header, px)
import Prelude (discard, (#))
import Share.Style.Selector ((?>))

bodyClass :: Selector
bodyClass = fromString ".body"

style :: CSS
style = do
  fromString ".index-page" ?> do
    header ?> do
      fontSize (16.0 # px)
    bodyClass ?> do
      display block
    footer ?> do
      display displayNone
