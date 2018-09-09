module Share.Style.SpotList
  ( style
  ) where

import CSS (CSS, block, display, displayNone, fontSize, fromString, li, px, ul)
import CSS.ListStyle.Type (listStyleType)
import CSS.ListStyle.Type as ListStyleType
import Prelude (discard, (#))
import Share.Style.Selector ((?>))

style :: CSS
style = do
  fromString ".spot-list" ?> do
    fromString ".selector" ?> do
      fontSize (16.0 # px)
    ul ?> do
      listStyleType ListStyleType.None
      li ?> do
        fromString ".url" ?> do
          display displayNone
        fromString ".qr-code" ?> do
          display displayNone
    fromString "ul.is-selected-url" ?> do
      li ?> do
        fromString ".url" ?> do
          display block
    fromString "ul.is-selected-qr" ?> do
      li ?> do
        fromString ".qr-code" ?> do
          display block
