module Main where

import Data.Maybe
import Data.Tuple
import Prelude

import Control.Monad.Eff (Eff, foreachE)
import Control.Monad.Eff.Console (CONSOLE, log)
import DOM.Node.Types (Document, Element, Node)
import Data.Foreign (Foreign)
import Data.Foreign.Class (class Decode, class Encode, encode)
import Data.Foreign.Generic (defaultOptions, genericDecode, genericEncode)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import FRP.Event (Event, subscribe)
import Halogen.VDom (ElemName(..), ElemSpec(..), Machine, Step(..), VDom(..), VDomMachine, VDomSpec(..), buildVDom, extract)
import Halogen.VDom.Machine (never, Machine(..), step, extract)

import UI.Core (MEvent, AttrValue(..), Attr(..), Prop)
import UI.Elements
import UI.Properties
import UI.Events

foreign import done :: forall eff. Eff eff Unit
foreign import getRootNode :: forall eff. Eff eff Document
foreign import onClick :: MEvent
foreign import logMy :: forall a eff. a -> Eff eff Unit
foreign import insertDom :: forall a b eff. a -> b -> Eff eff Unit

foreign import applyAttributes ∷ forall eff. Element → Attr → Eff eff Unit
foreign import patchAttributes ∷ forall eff. Element → Attr → Attr → Eff eff Unit
foreign import cleanupAttributes ∷ forall eff. Element → Attr → Eff eff Unit

foreign import attachSub :: forall a. Foreign -> Event { id :: String | a}

data Screen = FirstScreen Int | SecondScreen Int

derive instance genericFirstScreen :: Generic Screen _
instance encodeFirstScreen :: Encode Screen where
  encode = genericEncode (defaultOptions {unwrapSingleConstructors = false})
instance decodeFirstScreen :: Decode Screen where
  decode = genericDecode (defaultOptions {unwrapSingleConstructors = false})

instance showScreen :: Show Screen where
  show = genericShow

buildAttributes
  ∷ ∀ eff a
  . Element
  → VDomMachine eff Attr Unit
buildAttributes elem = apply
  where
  apply ∷ forall eff. VDomMachine eff Attr Unit
  apply attrs = do
    applyAttributes elem attrs
    pure
      (Step unit
        (patch attrs)
        (done attrs))

  patch ∷ forall eff. Attr → VDomMachine eff Attr Unit
  patch attrs1 attrs2 = do
    patchAttributes elem attrs1 attrs2
    pure
      (Step unit
        (patch attrs2)
        (done attrs2))

  done ∷ forall eff. Attr → Eff eff Unit
  done attrs = cleanupAttributes elem attrs

mySpec document =  VDomSpec {
      buildWidget: const never
    , buildAttributes: buildAttributes
    , document : document
    }

-- gChildNode1 = Elem (ElemSpec (Nothing) (ElemName "linearLayout") (Attr [(Tuple "id" (AttrValue "3"))])) []
-- gChildNode2 = Elem (ElemSpec (Nothing) (ElemName "linearLayout") (Attr [(Tuple "id" (AttrValue "5"))])) []

-- childNode1 = Elem (ElemSpec (Nothing) (ElemName "linearLayout") (Attr [(Tuple "id" (AttrValue "2"))])) []
-- childNode2 = Elem (ElemSpec (Nothing) (ElemName "relativeLayout") (Attr [(Tuple "id" (AttrValue "2"))])) [gChildNode1, gChildNode2]

-- myDom1 :: forall a. Screen -> VDom Attr a
-- myDom1 sc = Elem (ElemSpec (Nothing) (ElemName "linearLayout") (Attr [
--                                                                  (Tuple "id" (AttrValue "1")),
--                                                                  (Tuple "color" (AttrValue "red")),
--                                                                  (Tuple "text" (AttrValue "hello")),
--                                                                  (Tuple "domName" (ScreenTag (encode sc))),
--                                                                  (Tuple "click" (Some onClick))
--                                                                  ]) ) [childNode2]

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

-- myDom2 :: forall a. Screen -> VDom Attr a
-- myDom2 sc = Elem (ElemSpec (Nothing) (ElemName "linearLayout") (Attr [
--                                                                   (Tuple "id" (AttrValue "1")),
--                                                                   (Tuple "color" (AttrValue "blue")),
--                                                                   (Tuple "bg" (AttrValue "green")),
--                                                                   (Tuple "domName" (ScreenTag (encode sc)))
--                                                                   ]) ) []
myDom2 :: forall a. Screen -> VDom Attr a
myDom2 sc =
    linearLayout
        [ id_ "1"
        , color "blue"
        , bg "green"
        , domName (ScreenTag (encode sc))
        ]
        []


myDom3 :: forall a. Screen -> VDom Attr a
myDom3 sc = Elem (ElemSpec (Nothing) (ElemName "linearLayout") (Attr [
                                                                   (Tuple "id" (AttrValue "1"))
                                                                   ])) []
main = do
  root <- getRootNode

  let ev1 = attachSub (encode $ FirstScreen 0)
  _ <- (subscribe ev1 (\c -> log $ show $ c.id))
  machine1 <- buildVDom (mySpec root) (myDom1 (FirstScreen 0))

  insertDom root (extract machine1)

  machine2 <- step machine1 (myDom2 (SecondScreen 0))
  machine3 <- step machine2 (myDom3 (SecondScreen 0))

  logMy (extract machine3)

  pure unit
