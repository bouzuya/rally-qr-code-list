module Share.View.SignInPage
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
  H.section M.! HA.className "sign-in-page" $ do
    H.header $ do
      H.h1 $ do
        M.text "Sign In"
    H.div M.! HA.className "body" $ do
      SignInForm.view { email: state.email, password: state.password }
    H.footer do
      M.text ""
