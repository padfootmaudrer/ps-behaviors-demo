module UI.Properties where

import Prelude

import Data.Tuple (Tuple(..))

import UI.Core (AttrValue(..), Prop)


prop :: String -> String -> Prop
prop key value = Tuple key (AttrValue value)

id_ :: String -> Prop
id_ = prop "id"

color :: String -> Prop
color = prop "color"

text :: String -> Prop
text = prop "text"

bg :: String -> Prop
bg = prop "bg"

