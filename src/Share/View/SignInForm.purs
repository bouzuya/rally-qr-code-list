module Share.View.SignInForm
  (view) where

import Prelude (discard, ($))
import Pux.DOM.Events as PE
import Pux.DOM.HTML as P
import Share.Event (Event(..))
import Share.State (State)
import Text.Smolder.HTML as H
import Text.Smolder.HTML.Attributes as HA
import Text.Smolder.Markup as M

labeledInput :: String -> String -> String -> String -> (PE.DOMEvent -> Event) -> P.HTML Event
labeledInput type' name label value onChange = do
  H.label M.! HA.className name $ do
    H.span M.! HA.className "label" $ do
      M.text label
    H.span M.! HA.className "value" $ do
      H.input M.! HA.name name M.! HA.type' type' M.! HA.value value M.#! PE.onChange onChange

view :: State -> P.HTML Event
view state = do
  H.form M.! HA.className "sign-in" $ do
    H.div $ do
      labeledInput "text" "email" "E-Mail" state.email EmailChange
    H.div $ do
      labeledInput "password" "password" "Password" state.password PasswordChange
    H.div $ do
      H.button M.! HA.className "sign-in" M.#! PE.onClick SignIn $ do
        H.span M.! HA.className "label" $ do
          M.text "Sign In"
