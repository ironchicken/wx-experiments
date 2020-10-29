module Main where

import Graphics.UI.WX

main :: IO ()
main = start gui

gui :: IO (Frame ())
gui = do
  frame [text := "Hello!"]
