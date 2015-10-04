module Render (
    defaultMain
) where

import Diagrams.Prelude
import Diagrams.Backend.SVG (renderSVG, B)
import System.Directory (getCurrentDirectory)

defaultMain :: Diagram B -> IO ()
defaultMain diagram = do
    renderSVG "test2.svg" (mkWidth 400) diagram
    dir <- getCurrentDirectory
    putStrLn $ "<img src=\"file://" ++ dir ++ "/test2.svg\" />"


