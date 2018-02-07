module Main where

import Prelude
import Types
import UI.Elements
import UI.Events
import UI.Properties

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Plus ((<|>))
import UI.Core (MEvent, AttrValue(..), Attr(..), Prop)
import UI.Util as U

foreign import onClick :: MEvent

widget state = linearLayout
              [ id_ "1"
              , color (state.color)
              , text "hello"
              , click (Some onClick)
              ]
                [
                ]

main = do
  --- Init State {} empty record--
  U.initializeState

  --- Update State ----
  state <- U.updateState "color" "blue"

  ---- Render Widget ---
  U.render (widget state) listen

  pure unit

eval x = U.updateState "color" "red"

listen = do
  sig1 <- U.signal "1"

  let behavior = eval <$> sig1.behavior
  let events = (sig1.event)

  U.patch widget behavior events
