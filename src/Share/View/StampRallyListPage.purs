module Share.View.StampRallyListPage
  (view) where

import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Prelude (discard, ($))
import Pux.DOM.Events as PE
import Pux.DOM.HTML as P
import Share.Event (Event(..))
import Share.Route as Route
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
      case state.stampRallyList of
        Nothing -> M.text "loading..."
        Just stampRallyList ->
          H.ul $ do
            for_ stampRallyList \i -> do
              H.li M.#! PE.onClick (GoTo (Route.StampRallyDetail i.name)) $ do
                H.span M.! HA.className "image" $ do
                  case i.image of
                    Nothing -> M.text ""
                    Just imageUrl -> do
                      H.img M.! HA.src imageUrl
                H.span M.! HA.className "name" $ do
                  M.text i.displayName
    H.footer do
      M.text ""
