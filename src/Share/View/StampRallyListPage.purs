module Share.View.StampRallyListPage
  (view) where

import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Prelude (discard, ($))
import Pux.DOM.HTML as P
import Share.Event (Event)
import Share.State (State)
import Text.Smolder.HTML as H
import Text.Smolder.HTML.Attributes as HA
import Text.Smolder.Markup as M

view :: State -> P.HTML Event
view state = do
  H.section M.! HA.className "stamp-rally-list-page" $ do
    H.header $ do
      H.h1 $ do
        M.text "Stamp Rally List"
    H.div M.! HA.className "body" $ do
      H.ul $ do
        case state.stampRallyList of
          Nothing -> M.text "no stamp rally"
          Just stampRallyList ->
            for_ stampRallyList \i -> do
              H.li $ M.text i.displayName
    H.footer do
      M.text ""
