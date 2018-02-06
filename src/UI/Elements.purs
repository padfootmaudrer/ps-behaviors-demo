module UI.Elements
	( Node
	, Leaf
    , element
    , linearLayout
    , relativeLayout
	) where

import Prelude

import Data.Maybe (Maybe(..))

import Halogen.VDom (ElemName(..), ElemSpec(..), VDom(..))

import UI.Core (Attr(..), Prop)

type Node p i
   = Array Prop
  -> Array (VDom p i)
  -> VDom p i

type Leaf p i
   = Array Prop
  -> VDom p i


element :: forall i. ElemName -> Array Prop -> Array (VDom Attr i) -> VDom Attr i
element elemName props children = Elem (ElemSpec Nothing elemName (Attr props)) children

linearLayout :: forall i. Node Attr i
linearLayout = element (ElemName "linearLayout")

relativeLayout :: forall i. Node Attr i
relativeLayout = element (ElemName "relativeLayout")

