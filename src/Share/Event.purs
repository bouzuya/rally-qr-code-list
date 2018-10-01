module Share.Event
  ( Event(..)
  ) where

import Pux.DOM.Events (DOMEvent)
import Share.Event.InternalEvent (InternalEvent)
import Share.Route (Route)

data Event
  = EmailChange DOMEvent
  | ErrorCorrectionLevelLSelect DOMEvent
  | ErrorCorrectionLevelMSelect DOMEvent
  | ErrorCorrectionLevelQSelect DOMEvent
  | ErrorCorrectionLevelHSelect DOMEvent
  | GoTo Route DOMEvent
  | InternalEvent InternalEvent
  | PasswordChange DOMEvent
  | QrCodeSelect DOMEvent
  | SignIn DOMEvent
  | SignOut DOMEvent
  | UrlSelect DOMEvent
