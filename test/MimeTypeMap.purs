module Test.MimeTypeMap
  ( tests ) where

import Bouzuya.MimeType (MimeType, mimeType)
import Bouzuya.MimeTypeMap (Extension, MimeTypeMap, fromFoldable, lookup)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Prelude (discard)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert as Assert

tests :: TestSuite
tests = suite "MimeTypeMap" do
  let
    e1 :: Extension
    e1 = ".html"
    e2 :: Extension
    e2 = ".jpg"
    e3 :: Extension
    e3 = ".jpeg"
    t1 :: MimeType
    t1 = mimeType "text" "html"
    t2 :: MimeType
    t2 = mimeType "image" "jpeg"
    m1 :: MimeTypeMap
    m1 =
      fromFoldable
        [ Tuple t1 [e1]
        , Tuple t2 [e2, e3]
        ]
  test "fromFoldable" do
    Assert.assert "already tested" true
  test "lookup" do
    Assert.equal (Just t2) (lookup ".jpeg" m1)
    Assert.equal (Just t2) (lookup ".jpg" m1)
    Assert.equal Nothing (lookup ".gif" m1)
