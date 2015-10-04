module Render (
    defaultMain
) where

import Diagrams.Prelude
import Diagrams.Backend.GHCJS (Options(..), Canvas(..))
import System.Directory (getCurrentDirectory)
import GHCJS.DOM
       (webViewGetDomDocument, enableInspector, runWebGUI)
import GHCJS.DOM.Document (getElementById, getBody)
import GHCJS.DOM.Element (setInnerHTML)
import GHCJS.DOM.Types (castToHTMLCanvasElement)
import GHCJS.DOM.HTMLCanvasElement (getContext)
import Unsafe.Coerce (unsafeCoerce)
import Control.Concurrent (threadDelay)

defaultMain :: Diagram Canvas -> IO ()
defaultMain diagram = runWebGUI $ \ webView -> do
    enableInspector webView
    Just doc <- webViewGetDomDocument webView
    Just body <- getBody doc
    setInnerHTML body (Just $ "<canvas id=\"test\" width=\"400\" height=\"400\""
                 <> "style=\"border:1px solid #d3d3d3;\"></canvas>")
    Just canvas <- fmap castToHTMLCanvasElement <$> getElementById doc "test"
    ctx <- getContext canvas "2d"
    renderDia Canvas (CanvasOptions (mkSizeSpec2D (Just 200) (Just 200)) (unsafeCoerce ctx))
        diagram
    return ()

