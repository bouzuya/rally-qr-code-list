module Share.View.Home
  (view) where

import Prelude (discard, ($))
import Pux.DOM.HTML as P
import Share.Event (Event)
import Share.State (State)
import Share.View.SignInForm as SignInForm
import Text.Smolder.HTML as H
import Text.Smolder.HTML.Attributes as HA
import Text.Smolder.Markup as M

view :: State -> P.HTML Event
view state = do
  H.html $ do
    H.head $ do
      H.meta M.! HA.charset "UTF-8"
      H.title $ do
        M.text "RALLY QR code list"
    H.body $ do
      H.header $ do
        H.h1 $ do
          M.text "RALLY QR code list"
      H.div M.! HA.className "body" $ do
        H.p $ do
          M.text "Hello!"
        SignInForm.view state
      H.footer $ do
        H.div M.! HA.className "source-code" $ do
          H.a M.! HA.href "https://github.com/bouzuya/rally-qr-code-list" $ do
            M.text "Source Code"
        H.address $ do
          H.a M.! HA.href "https://bouzuya.net" $ do
            M.text "bouzuya"
