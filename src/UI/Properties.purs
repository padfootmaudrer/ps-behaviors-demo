module UI.Properties where

import Prelude

import Data.Tuple (Tuple(..))

import UI.Core (AttrValue(..), Prop)


prop :: String -> String -> Prop
prop key value = Tuple key (AttrValue value)

id_ :: String -> Prop
id_ = prop "id"

height :: String -> Prop
height = prop "height"

width :: String -> Prop
width = prop "width"

background :: String -> Prop
background = prop "background"

margin :: String -> Prop
margin = prop "margin"

color :: String -> Prop
color = prop "color"

text :: String -> Prop
text = prop "text"

bg :: String -> Prop
bg = prop "bg"

gravity :: String -> Prop
gravity = prop "gravity"

a_translationX :: String -> Prop
a_translationX = prop "a_translationX"

a_duration :: String -> Prop
a_duration = prop "a_duration"

alignParentBottom :: String -> Prop
alignParentBottom = prop "alignParentBottom"
