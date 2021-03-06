module Share.Style.ClientRoot
  ( style
  ) where

import CSS (CSS, Selector, backgroundColor, fontSize, footer, fromString, header, px, rgba)
import Prelude (discard, (#))
import Share.Style.IndexPage as IndexPage
import Share.Style.Selector ((?>))
import Share.Style.StampRallyDetailPage as StampRallyDetailPage
import Share.Style.StampRallyListPage as StampRallyListPage

bodyClass :: Selector
bodyClass = fromString ".body"

style :: CSS
style = do
  fromString ".client-root" ?> do
    header ?> do
      fontSize (16.0 # px)
    bodyClass ?> do
      IndexPage.style
      StampRallyDetailPage.style
      StampRallyListPage.style
      backgroundColor (rgba 0 0 0 0.0)
    footer ?> do
      backgroundColor (rgba 0 0 0 0.0)
