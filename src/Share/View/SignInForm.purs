module Share.View.SignInForm
  (view) where

import Prelude (Unit, discard, ($))
import Pux.DOM.HTML as P
import Share.State (State)
import Text.Smolder.HTML as H
import Text.Smolder.HTML.Attributes as HA
import Text.Smolder.Markup as M

view :: State -> P.HTML Unit
view _ = do
  H.form M.! HA.className "sign-in" $ do
    H.div $ do
      H.label M.! HA.className "email" $ do
        H.span M.! HA.className "label" $ do
          M.text "E-Mail"
        H.span M.! HA.className "value" $ do
          H.input M.! HA.value "email@example.com" -- TODO
    H.div $ do
      H.label M.! HA.className "password" $ do
        H.span M.! HA.className "label" $ do
          M.text "Password"
        H.span M.! HA.className "value" $ do
          H.input M.! HA.type' "password" M.! HA.value "pass1" -- TODO
    H.div $ do
      H.button M.! HA.className "sign-in" $ do
        H.span M.! HA.className "label" $ do
          M.text "Sign In"
