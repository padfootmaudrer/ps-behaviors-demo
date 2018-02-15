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
import Data.List (List)
import FRP.Event (Event)
import FRP.Event.Time (interval)
import UI.Core (MEvent, AttrValue(..), Attr(..), Prop)
import UI.Util as U

foreign import click :: MEvent

data EventsType = BoolEvent Boolean |  IntEvent Int | StringEvent String

widget state = linearLayout
              [ id_ "1"
              , height "match_parent"
              , width "match_parent"
              , background (state.color)
              , gravity "center"
              ]
              [ linearLayout
                  [ id_ "2"
                  , height "300"
                  , width "300"
                  , background "#987654"
                  ]

                  [ linearLayout
                      [ id_ "3"
                      , width "150"
                      , height "match_parent"
                      , background "#121231"
                      , onClick (Some click)
                      ]
                      [],
                    linearLayout
                      [ id_ "4"
                      , height "match_parent"
                      , width "150"
                      , background "#000000"
                      , onClick (Some click)
                      ]
                      []
                  ]
                  ]



main = do
  --- Init State {} empty record--
  U.initializeState

  --- Update State ----
  state <- U.updateState "color" "yellow"

  ---- Render Widget ---
  U.render (widget state) listen

  pure unit

eval (BoolEvent x) (BoolEvent y) = do
  let s = x && y
  logShow x
  logShow y
  if s
    then
     U.updateState "color" "green"
    else
     U.updateState "color" "red"


eval _ _ = U.updateState "x" "y"

listen = do
  sig1 <- U.signal "3" (BoolEvent true)
  sig2 <- U.signal "4" (BoolEvent true)

  let behavior = eval <$> sig1.behavior <*> sig2.behavior
  let events = (sig1.event <|> sig2.event  <|> ( map (\x -> IntEvent x) (interval 1000)))

  pure unit
  U.patch widget behavior events
