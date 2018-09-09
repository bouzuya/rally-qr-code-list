module Share.Style.StampRallyDetailPage
  ( style
  ) where

import CSS (CSS, Selector, display, displayNone, fontSize, footer, fromString, header, px)
import Prelude (discard, (#))
import Share.Style.Selector ((?>))
import Share.Style.SpotList as SpotList

bodyClass :: Selector
bodyClass = fromString ".body"

style :: CSS
style = do
  fromString ".stamp-rally-detail-page" ?> do
    header ?> do
      fontSize (16.0 # px)
    bodyClass ?> do
      SpotList.style
    footer ?> do
      display displayNone
