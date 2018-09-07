module Share.Style.Selector
  ( (?>)
  , select'
  ) where

import CSS (App(..), CSS, Rule(..), Selector, rule, runS)
import Prelude (($))

infixr 5 select' as ?>

select' :: Selector -> CSS -> CSS
select' sel rs = rule $ Nested (Child sel) (runS rs)
