module Main where

import Data.Maybe
import Data.Tuple
import Prelude

import Control.Monad.Eff (Eff, foreachE)
import Control.Monad.Eff.Console (CONSOLE, log)
import DOM.Node.Types (Document, Element, Node)
import Halogen.VDom (ElemName(..), ElemSpec(..), Machine, Step(..), VDom(..), VDomMachine, VDomSpec(..), buildVDom, extract)
import Halogen.VDom.Machine (never, Machine(..), step, extract)

data MEvent
data AttrValue = AttrValue String | Some MEvent
newtype Attr = Attr (Array (Tuple String AttrValue))

foreign import done :: forall eff. Eff eff Unit
foreign import appendChildToBody :: forall eff. Node -> Eff eff Unit
foreign import getDoc :: forall eff. Eff eff Document
foreign import  onClick :: MEvent
foreign import logMy :: forall a eff. a -> Eff eff Unit

foreign import applyAttributes ∷ forall eff. Element → Attr → Eff eff Unit
foreign import patchAttributes ∷ forall eff. Element → Attr → Attr → Eff eff Unit
foreign import cleanupAttributes ∷ forall eff. Element → Attr → Eff eff Unit

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

-- buildAttributes
--   ∷ ∀ eff
--   . Element
--   → VDomMachine eff Attr Unit
-- buildAttributes element = setAttr element

mySpec document =  VDomSpec {
      buildWidget: const never
    , buildAttributes: buildAttributes
    , document : document
    }

-- myDom1 :: forall b. VDom Attr b
-- myDom1 = Elem (ElemSpec (Nothing) (ElemName "linearLayout")
--                (Attr [
--                    (Tuple "id" (AttrValue "1")),
--                    (Tuple "name" (AttrValue "naman")) ,
--                    (Tuple "click" (Some onClick))
--                    ]))
--                [Elem (ElemSpec (Nothing) (ElemName "linearLayout")
--                (Attr [
--                    (Tuple "id" (AttrValue "2")),
--                    (Tuple "name" (AttrValue "kalkhuria")) ,
--                    (Tuple "click" (Some onClick))
--                    ])) []]

gChildNode1 = Elem (ElemSpec (Nothing) (ElemName "linearLayout") (Attr [(Tuple "id" (AttrValue "3"))])) []
childNode1 = Elem (ElemSpec (Nothing) (ElemName "linearLayout") (Attr [(Tuple "id" (AttrValue "2"))])) [gChildNode1]

gChildNode2 = Elem (ElemSpec (Nothing) (ElemName "linearLayout") (Attr [(Tuple "id" (AttrValue "3"))])) []
childNode2 = Elem (ElemSpec (Nothing) (ElemName "linearLayout") (Attr [])) [gChildNode1]

myDom1 = Elem (ElemSpec (Nothing) (ElemName "linearLayout") (Attr [
                                                                  (Tuple "id" (AttrValue "1")),
                                                                  (Tuple "color" (AttrValue "red")),
                                                                  (Tuple "text" (AttrValue "hello"))
                                                                  ]) ) [childNode1]

myDom2 = Elem (ElemSpec (Nothing) (ElemName "linearLayout") (Attr [
                                                                   (Tuple "id" (AttrValue "1")),
                                                                   (Tuple "color" (AttrValue "blue")),
                                                                   (Tuple "bg" (AttrValue "green"))
                                                                   ]) ) [childNode2]

main = do
  document <- getDoc
  machine1 <- buildVDom ( mySpec document ) myDom1
  machine2 <- step machine1 myDom2
  pure unit
