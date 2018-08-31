module Share.View.ClientRoot
  (view) where

import Prelude (discard, ($))
import Pux.DOM.HTML as P
import Share.Event (Event)
import Share.Route as Route
import Share.State (State)
import Share.View.SignInPage as SignInPage
import Share.View.StampRallyListPage as StampRallyListPage
import Text.Smolder.HTML as H
import Text.Smolder.HTML.Attributes as HA
import Text.Smolder.Markup as M

view :: State -> P.HTML Event
view state = do
  H.div M.! HA.className "client-root" $ do
    H.header $ do
      H.h1 $ do
        M.text "RALLY QR code list"
    H.div M.! HA.className "body" $ do
      case state.route of
        Route.SignIn ->
          SignInPage.view state
        Route.StampRallyList ->
          StampRallyListPage.view state
    H.footer $ do
      H.div M.! HA.className "source-code" $ do
        H.a M.! HA.href "https://github.com/bouzuya/rally-qr-code-list" $ do
          M.text "Source Code"
      H.address $ do
        H.a M.! HA.href "https://bouzuya.net" $ do
          M.text "bouzuya"
