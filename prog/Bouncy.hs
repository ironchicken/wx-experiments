module Main where

-- Bouncy balls example from https://wiki.haskell.org/WxHaskell/Quick_start

import Graphics.UI.WX

radius :: Int
radius = 10

maxY :: Int
maxY = 300

maxX :: Int
maxX = 300

maxH :: Int
maxH = maxY - radius

ballsFrame :: IO ()
ballsFrame = do
  vballs <- varCreate []
  f <- frameFixed [ text := "Bouncing balls" ]
  p <- panel f [ on paint := paintBalls vballs ]
  t <- timer f [ interval := 20
               , on command := nextBalls vballs p
               ]

  set p [ on click := dropBall vballs p
        , on clickRight := (\_ -> ballsFrame)
        , on (charKey 'p') := set t [ enabled :~ not ]
        , on (charKey '-') := set t [ interval :~ \i -> i*2 ]
        , on (charKey '+') := set t [ interval :~ \i -> max 1 (i `div` 2) ]
        ]

  set f [ layout := minsize (sz maxX maxY) $ widget p ]

  where
    paintBalls :: Var [[Point]] -> DC a -> Rect -> IO ()
    paintBalls vballs dc viewArea = do
      balls <- varGet vballs
      set dc [ brushColor := red
             , brushKind := BrushSolid
             ]
      mapM_ (drawBall dc) [ p | (p:ps) <- balls ]

    drawBall dc pt = circle dc pt radius []

    nextBalls :: Var [[Point]] -> Panel () -> IO ()
    nextBalls vballs p = do
      varUpdate vballs (filter (not . null) . map (drop 1))
      repaint p

    dropBall :: Var [[Point]] -> Panel () -> Point -> IO ()
    dropBall vballs p pt = do
      varUpdate vballs (bouncing pt:)
      repaint p

    bouncing (Point x y) =
      map (\h -> Point x (maxH - h)) (bounce (maxH - y) 0)

    bounce h v
      | h <= 0 && v == 0 = replicate 20 0
      | h <= 0 && v < 0 = bounce 0 ((-v) - 2)
      | otherwise = h : bounce (h + v) (v - 1)

main :: IO ()
main = start ballsFrame
