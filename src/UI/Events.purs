module UI.Events where

import Prelude

import Data.Tuple (Tuple(..))

import UI.Core (AttrValue(..), Prop)

domName :: AttrValue -> Prop
domName st = Tuple "domName" st

click :: AttrValue -> Prop
click some = Tuple "click" some
