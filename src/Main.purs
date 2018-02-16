module Main where

import FRP.Behavior.Time
import Prelude
import Types
import UI.Elements
import UI.Events
import UI.Properties

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log, logShow)
import Control.Plus ((<|>))
import Data.Array (head, toUnfoldable)
import Data.Int (fromString)
import Data.List (List)
import Data.Maybe (Maybe(..))
import Data.Set (Set)
import Data.Unfoldable (class Unfoldable)
import FRP.Behavior (step)
import FRP.Behavior.Keyboard (key, keys)
import FRP.Behavior.Mouse (buttons)
import FRP.Event (Event)
import FRP.Event.Keyboard (up)
import FRP.Event.Mouse (down)
import FRP.Event.Time (interval)
import UI.Core (MEvent, AttrValue(..), Attr(..), Prop)
import UI.Util as U

foreign import click :: MEvent

widget state = linearLayout
              [ id_ "1"
              , height "match_parent"
              , width "match_parent"
              , background (state.color)
              , gravity "center"
              ]
              [ linearLayout
                  [ id_ "2"
                  , height (state.height)
                  , width (state.width)
                  , background "#FF00FF"
                  ]
                  []
                ]



main = do
  --- Init State {} empty record--
  U.initializeState

  --- Update State ----
  state <- U.updateState "color" "yellow"
  state <- U.updateState "height" "300"
  state <- U.updateState "width" "300"

  ---- Render Widget ---
  U.render (widget state) listen

  pure unit


eval z = do
  state <- U.getState
  if (z)
    then do
      height <- pure $ getDecreasedHeight state.height
      width <- pure $ getDecreasedWidth state.width
      state <- U.updateState "height" height
      U.updateState "width" width
    else do
      height <- pure $ getIncreasedHeight state.height
      width <- pure $ getIncreasedWidth state.width
      state <- U.updateState "height" height
      U.updateState "width" width

  where
    getDecreasedHeight height = case (fromString height) of
      Just h -> show (h-2)
      Nothing -> height
    getIncreasedHeight height = case (fromString height) of
      Just h -> show (h+5)
      Nothing -> height
    getIncreasedWidth width = case (fromString width) of
      Just h -> show (h+5)
      Nothing -> width
    getDecreasedWidth width = case (fromString width) of
      Just h -> show (h-2)
      Nothing -> width

listen = do
  let behavior = eval <$> (key 32)  -- <*> (step 10 down)
  let events = ((void down) <|> (void (interval 50)))

  U.patch widget behavior events
