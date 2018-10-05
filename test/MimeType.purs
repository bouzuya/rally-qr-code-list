module Test.MimeType
  ( tests ) where

import Bouzuya.MimeType (MimeType, fromString, mimeType, toString)
import Data.Maybe (Maybe(..))
import Prelude (discard, eq, map, show)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert as Assert

tests :: TestSuite
tests = suite "MimeType" do
  let
    m1 :: MimeType
    m1 = mimeType "text" "html"
  test "Eq" do
    Assert.equal true (eq (mimeType "text" "html") m1)
  test "Show" do
    Assert.equal "text/html" (show (mimeType "text" "html"))
  test "fromString" do
    Assert.equal (Just "text/html") (map show (fromString "text/html"))
    Assert.equal Nothing (map show (fromString "text/"))
    Assert.equal Nothing (map show (fromString "/html"))
  test "toString" do
    Assert.equal "text/html" (toString (mimeType "text" "html"))
