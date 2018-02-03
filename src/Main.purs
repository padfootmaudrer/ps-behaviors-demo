module Main where

import Data.Maybe
import Data.Tuple
import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import DOM.Node.Types (Document, Element, Node)
import Halogen.VDom (ElemName(..), ElemSpec(..), Machine, Step(..), VDom(..), VDomMachine, VDomSpec(..), buildVDom)
import Halogen.VDom.Machine (never, Machine(..), step, extract)

data MEvent
data AttrValue = AttrValue String | Some MEvent
newtype Attr = Attr (Array (Tuple String AttrValue))

foreign import setAttrImpl :: forall eff. Element -> Attr -> Eff eff Unit
foreign import done :: forall eff. Eff eff Unit
foreign import appendChildToBody :: forall eff. Node -> Eff eff Unit
foreign import getDoc :: forall eff. Eff eff Document
foreign import  onClick :: MEvent

setAttr :: forall eff. Element -> Attr -> Eff eff (Step (Eff eff) Attr Unit)
setAttr element attr = do
   setAttrImpl element attr
   pure $ Step unit (setAttr element) (done)

buildAttributes
  ∷ ∀ eff
  . Element
  → VDomMachine eff Attr Unit
buildAttributes element = setAttr element

mySpec document =  VDomSpec {
      buildWidget: const never
    , buildAttributes: buildAttributes
    , document : document
    }


myDom1 :: forall b. VDom Attr b
myDom1 = Elem (ElemSpec (Nothing) (ElemName "linearLayout")
               (Attr [
                   (Tuple "id" (AttrValue "1")),
                   (Tuple "name" (AttrValue "naman")) ,
                   (Tuple "click" (Some onClick))
                   ]))
               [Elem (ElemSpec (Nothing) (ElemName "linearLayout")
               (Attr [
                   (Tuple "id" (AttrValue "2")),
                   (Tuple "name" (AttrValue "kalkhuria")) ,
                   (Tuple "click" (Some onClick))
                   ])) []]

main = do
  document <- getDoc
  machine1 <- buildVDom ( mySpec document ) myDom1
  log "hello"
  pure unit
