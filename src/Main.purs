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
              ]
                [
                  linearLayout [id_ "2" , click (Some onClick)] [],
                  linearLayout [id_ "3" , click (Some onClick)] []
                ]

main = do
  --- Init State {} empty record--
  U.initializeState

  --- Update State ----
  state <- U.updateState "color" "blue"

  ---- Render Widget ---
  U.render (widget state) listen

  pure unit

eval x y = do
     let s = x && y

     if s
        then
         U.updateState "color" "green"
       else
         U.updateState "color" "red"

listen = do
  sig1 <- U.signal "2"
  sig2 <- U.signal "3"

  let behavior = eval <$> sig1.behavior <*> sig2.behavior
  let events = (sig1.event <|> sig2.event)

  U.patch widget behavior events
