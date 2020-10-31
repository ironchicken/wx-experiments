module Main where

import Graphics.UI.WX

main :: IO ()
main = start gui

gui :: IO ()
gui = do
  f <- frame [text := "Hello!"]
  q <- button f [text := "Quit", on command := close f]
  set f [ layout := margin 10 (column 5 [ floatCenter (label "Press")
                                        , floatCenter (widget q)
                                        ]) ]
