module UI.Properties where

import Prelude

import Data.Tuple (Tuple(..))

import UI.Core (AttrValue(..), Prop)


id_ :: String -> Prop
id_ value = Tuple "id" (AttrValue value)

color :: String -> Prop
color value = Tuple "color" (AttrValue value)

text :: String -> Prop
text value = Tuple "text" (AttrValue value)

