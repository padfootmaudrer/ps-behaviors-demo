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
import FRP.Event.Keyboard (up, down)
import FRP.Event.Time (animationFrame, interval)
import UI.Core (MEvent, AttrValue(..), Attr(..), Prop)
import UI.Util as U

foreign import click :: MEvent

widget state = relativeLayout
              [ id_ "1"
              , height "match_parent"
              , width "match_parent"
              , background (state.color)
              -- , gravity "center"
              ]
              [
                linearLayout
                  [ id_ "2"
                  , height (state.height)
                  , width (state.width)
                  , background "#FF00FF"
                  , alignParentBottom "true,-1"
                  , margin (state.leftMargin <> "," <> "0" <> "," <> state.rightMargin <> "," <> "0")
                  ]
                  [],
                linearLayout
                    [ id_ "3"
                    , height "60"
                    , width "30"
                    , background "#FF00FF"
                    , alignParentBottom "true,-1"
                    , margin (state.leftMargin3 <> "," <> state.topMargin <> "," <> state.rightMargin <> "," <> state.bottomMargin)
                    ]
                    []
              ]


main = do
  --- Init State {} empty record--
  U.initializeState

  --- Update State ----
  state <- U.updateState "color" "yellow"
  state <- U.updateState "height" "30"
  state <- U.updateState "width" "30"
  state <- U.updateState "leftMargin" "180"
  state <- U.updateState "topMargin" "0"
  state <- U.updateState "rightMargin" "0"
  state <- U.updateState "bottomMargin" "0"
  state <- U.updateState "leftMargin3" "375"
  state <- U.updateState "leftMargin4" "485"
  state <- U.updateState "leftMargin5" "575"

  ---- Render Widget ---
  U.render (widget state) listen

  pure unit


eval z x = do
  logShow x
  state <- U.getState
  case x of
    37 -> do
      -- leftMargin <- pure $ getMarginWidthDec state.leftMargin
      state <- U.updateState "leftMargin" state.leftMargin
      state <- U.updateState "topMargin" state.topMargin
      state <- U.updateState "rightMargin" state.rightMargin
      U.updateState "bottomMargin" state.bottomMargin
    38 -> do
      bottomMargin <- pure $ getMarginHeightInc state.bottomMargin
      -- state <- U.updateState "leftMargin" state.leftMargin
      state <- U.updateState "topMargin" state.topMargin
      state <- U.updateState "rightMargin" state.rightMargin
      U.updateState "bottomMargin" bottomMargin
    39 -> do
      leftMargin <- pure $ getMarginWidthInc state.leftMargin
      state <- U.updateState "leftMargin" leftMargin
      state <- U.updateState "topMargin" state.topMargin
      state <- U.updateState "rightMargin" state.rightMargin
      U.updateState "bottomMargin" state.bottomMargin
    40 -> do
      -- bottomMargin <- pure $ getMarginHeightDec state.bottomMargin
      state <- U.updateState "leftMargin" state.leftMargin
      state <- U.updateState "topMargin" state.topMargin
      state <- U.updateState "rightMargin" state.rightMargin
      U.updateState "bottomMargin" state.bottomMargin
      -- U.updateState "bottomMargin" bottomMargin
    _ -> U.updateState "bottomMargin" state.bottomMargin


  where
    getMarginWidthInc margin = case (fromString margin) of
      Just m -> case (m >= 0 && m <= 1280) of
        true -> show (m+5)
        false -> show (0)
      Nothing -> margin
    getMarginHeightInc margin = case (fromString margin) of
      Just m -> case (m >= 0 && m <= 700) of
        true -> show (m+5)
        false -> show (0)
      Nothing -> margin
    -- getMarginHeightDec margin = case (fromString margin) of
    --   Just m -> case (m >= 0 && m <= 700) of
    --     true -> show (m-5)
    --     false -> show (0)
    --   Nothing -> margin
    -- getMarginWidthDec margin = case (fromString margin) of
    --   Just m -> case (m >= 0 && m <= 1280) of
    --     true -> show (m-5)
    --     false -> show (0)
    --   Nothing -> margin


listen = do
  let behavior = eval <$> (key 32) <*> (step 10 down)
  let events = ((void down) <|> (animationFrame)) --  (void (interval 50)))

  U.patch widget behavior events
