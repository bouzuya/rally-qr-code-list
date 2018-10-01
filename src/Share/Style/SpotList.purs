module Share.Style.SpotList
  ( style
  ) where

import CSS (CSS, block, display, displayNone, flex, float, floatLeft, fontSize, fromString, label, li, padding, px, ul)
import CSS.ListStyle.Type (listStyleType)
import CSS.ListStyle.Type as ListStyleType
import Prelude (discard, (#))
import Share.Style.Selector ((?>))

selectorStyle :: CSS
selectorStyle = do
  display flex
  fontSize (16.0 # px)
  label ?> do
    padding (0.0 # px) (8.0 # px) (0.0 # px) (8.0 # px)
    fromString ".value" ?> do
      float floatLeft

style :: CSS
style = do
  fromString ".spot-list" ?> do
    fromString ".selector" ?> selectorStyle
    fromString ".error-correction-level-selector" ?> selectorStyle
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
