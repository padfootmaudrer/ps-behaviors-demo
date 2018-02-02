module Main where

import Data.Maybe
import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log, logShow)
import DOM.Node.Types (Document, Element, Node)
import Halogen.VDom (ElemName(..), ElemSpec(..), Machine, Step(..), VDom(..), VDomMachine, VDomSpec(..), buildVDom, extract)
import Halogen.VDom.Machine (never, Machine(..), step, extract)

foreign import setAttrImpl :: forall eff. Element -> String -> Eff eff Unit
foreign import done :: forall eff. Eff eff Unit
foreign import appendChildToBody :: forall eff. Node -> Eff eff Unit
foreign import getDoc :: forall eff. Eff eff Document
foreign import  logMy:: forall a eff. a -> Eff eff Unit

setAttr :: forall eff. Element -> String -> Eff eff (Step (Eff eff) String Unit)
setAttr element attr = do
   setAttrImpl element attr
   pure $ Step unit (setAttr element) (done)

buildAttributes
  ∷ ∀ eff
  . Element
  → VDomMachine eff String Unit
buildAttributes element = setAttr element

-- buildWidget
--   ∷ ∀ eff a
--   . V.VDomSpec eff a MyWidget
--   → V.VDomMachine eff MyWidget DOM.Node


mySpec document =  VDomSpec {
      buildWidget: const never
    , buildAttributes: buildAttributes
    , document : document
    }

myDom1 :: forall b. VDom String b
myDom1 = Elem (ElemSpec (Nothing) (ElemName "linearLayout") "1") [ (Text "hello")]

myDom2 :: forall b. VDom String b
myDom2 = Elem (ElemSpec (Nothing) (ElemName "linearLayout") "2") [(Text "hi")]

main = do
  document <- getDoc
  machine1 <- buildVDom ( mySpec document ) myDom1
  appendChildToBody (extract machine1)
  machine2 <- step machine1 myDom2
  -- logMy (extract machine2)
  pure unit
