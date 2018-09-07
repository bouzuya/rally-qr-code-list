module Share.Style.StampRallyListPage
  ( style
  ) where

import CSS (CSS, Selector, Size(..), absolute, block, display, displayNone, fontSize, footer, fromString, header, height, img, key, left, li, padding, pct, position, px, relative, top, ul, width)
import CSS.ListStyle.Type (listStyleType)
import CSS.ListStyle.Type as ListStyleType
import Prelude (discard, (#))
import Share.Style.Selector ((?>))

bodyClass :: Selector
bodyClass = fromString ".body"

size :: forall a. Size a -> Size a -> CSS
size w h = do
  height h
  width w

style :: CSS
style = do
  fromString ".stamp-rally-list-page" ?> do
    header ?> do
      fontSize (16.0 # px)
    bodyClass ?> do
      ul ?> do
        listStyleType ListStyleType.None
        padding (0.0 # px) (0.0 # px) (0.0 # px) (0.0 # px)
        li ?> do
          -- TODO: cursor
          height (64.0 # px)
          position relative
          fromString ".image" ?> do
            display block
            left (0.0 # px)
            position absolute
            size (64.0 # px) (64.0 # px)
            top (0.0 # px)
            img ?> do
              size (100.0 # pct) (100.0 # pct)
          fromString ".name" ?> do
            position absolute
            left (64.0 # px)
            top (0.0 # px)
    footer ?> do
      display displayNone
