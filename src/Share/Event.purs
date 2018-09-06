module Share.Event
  ( Event(..)
  ) where

import Pux.DOM.Events (DOMEvent)
import Share.Event.InternalEvent (InternalEvent)

data Event
  = EmailChange DOMEvent
  | InternalEvent InternalEvent
  | PasswordChange DOMEvent
  | SignIn DOMEvent
  | SignOut DOMEvent
