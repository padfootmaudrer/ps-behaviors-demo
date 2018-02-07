module Main where

import Data.Maybe
import Data.Tuple
import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import DOM.Node.Types (Document, Element)
import Data.Foreign (Foreign)
import Data.Foreign.Class (class Decode, class Encode, encode)
import Halogen.VDom (VDom(..), buildVDom)
import Halogen.VDom.Machine (step, extract)

import UI.Elements
import UI.Events
import UI.Properties
import UI.Core (MEvent, AttrValue(..), Attr(..), Prop)
import UI.Util
import Type

foreign import getRootNode :: forall eff. Eff eff Document
foreign import onClick :: MEvent
foreign import insertDom :: forall a b eff. a -> b -> Eff eff Unit

myDom1 :: forall a. Screen -> VDom Attr a
myDom1 sc = linearLayout
              [ id_ "1"
              , color "red"
              , text "hello"
              , domName (ScreenTag (encode sc))
              , click (Some onClick)
              ]
              [ relativeLayout
                  [ id_ "2" ]
                  [ linearLayout
                      [ id_ "3"]
                      []
                  , linearLayout
                      [ id_ "5"]
                      []
                  ]
              ]

myDom2 :: forall a. Screen -> VDom Attr a
myDom2 sc =
    linearLayout
        [ id_ "1"
        , color "blue"
        , bg "green"
        , domName (ScreenTag (encode sc))
        ]
        []

main = do
  root <- getRootNode

  machine1 <- buildVDom (mySpec root) (myDom1 (FirstScreen 0))
  insertDom root (extract machine1)

  machine2 <- step machine1 (myDom2 (SecondScreen 0))

  pure unit
