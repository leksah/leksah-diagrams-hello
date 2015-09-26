{-# LANGUAGE CPP #-}
module Main (
    main
) where

import Diagrams.Prelude
#ifdef ghcjs_HOST_OS
import Diagrams.Backend.GHCJS (Options(..), Canvas(..))
import System.Directory (getCurrentDirectory)
import GHCJS.DOM
       (webViewGetDomDocument, enableInspector, runWebGUI)
import GHCJS.DOM.Document (getElementById, getBody)
import GHCJS.DOM.Element (setInnerHTML)
import GHCJS.DOM.Types (castToHTMLCanvasElement)
import GHCJS.DOM.HTMLCanvasElement (getContext)
import Unsafe.Coerce (unsafeCoerce)
#else
import Diagrams.Backend.SVG (renderSVG, B)
import System.Directory (getCurrentDirectory)
#endif

diagram = eyes `atop` circle 5

eyes = (eye' ||| eye') # centerX

eye' = (circle 0.5  # fc black
    `atop` circle 1 # fc blue # lw none
    `atop` circle 2 # scaleY 0.7) # pad 1.1

#ifdef ghcjs_HOST_OS
main = runWebGUI $ \ webView -> do
    enableInspector webView
    Just doc <- webViewGetDomDocument webView
    Just body <- getBody doc
    setInnerHTML body (Just $ "<canvas id=\"test\" width=\"200\" height=\"200\""
                 <> "style=\"border:1px solid #d3d3d3;\"></canvas>")
    Just canvas <- fmap castToHTMLCanvasElement <$> getElementById doc "test"
    ctx <- getContext canvas "2d"
    renderDia Canvas (CanvasOptions (mkSizeSpec2D (Just 200) (Just 200)) (unsafeCoerce ctx))
        (diagram :: Diagram Canvas)
    return ()
#else
main :: IO ()
main = do
    renderSVG "test.svg" (mkWidth 400) (diagram :: Diagram B)
    dir <- getCurrentDirectory
    putStrLn $ "<a href=\"file://" ++ dir ++ "/test.svg\">test.svg</a>"
#endif
