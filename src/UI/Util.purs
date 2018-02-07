module UI.Util where

import Prelude
import Halogen.VDom (ElemName(..), ElemSpec(..), Machine, Step(..), VDom(..), VDomMachine, VDomSpec(..), buildVDom, extract)
import Halogen.VDom.Machine (never, Machine(..), step, extract)
import UI.Core (MEvent, AttrValue(..), Attr(..), Prop)
import DOM.Node.Types (Element, Document)
import Control.Monad.Eff (Eff, foreachE)
import FRP as F
import FRP.Behavior as B
import FRP.Event as E
import Types

foreign import logNode :: forall eff a . a  -> Eff eff Unit
foreign import applyAttributes ∷ forall eff. Element → Attr → Eff eff Unit
foreign import done :: forall eff. Eff eff Unit
foreign import patchAttributes ∷ forall eff. Element → Attr → Attr → Eff eff Unit
foreign import cleanupAttributes ∷ forall eff. Element → Attr → Eff eff Unit
foreign import getLatestMachine :: forall m a b eff. Eff eff (Step m a b)
foreign import storeMachine :: forall eff m a b. Step m a b -> Eff eff Unit
foreign import getRootNode :: forall eff. Eff eff Document
foreign import insertDom :: forall a b eff. a -> b -> Eff eff Unit
foreign import attachEvents :: forall a b eff.  String ->  (b ->  Eff (frp::F.FRP | eff) Unit) -> Unit
foreign import initializeState :: forall eff t . Eff eff Unit
foreign import updateState :: forall eff a b t. a  -> b -> Eff eff (Rec t)
foreign import getState :: forall eff t. Eff eff (Rec t)

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

patchAndRun x myDom = do
  state <- x
  logNode "patching"
  machine <- getLatestMachine
  newMachine <- step machine (myDom state)
  storeMachine newMachine


render dom listen= do
  root <- getRootNode
  machine <- buildVDom (mySpec root) dom
  storeMachine machine
  insertDom root (extract machine)
  _ <- listen
  pure unit

signal id = do
  o <- E.create
  let behavior = B.step false o.event
  let x = attachEvents id o.push
  pure $ {behavior : behavior , event : o.event}

patch dom behavior events = do
  B.sample_ behavior events `E.subscribe` (\x -> patchAndRun x dom)
