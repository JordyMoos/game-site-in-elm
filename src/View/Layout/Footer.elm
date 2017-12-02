module View.Layout.Footer exposing (Styles(..), styles, view)

import Element exposing (..)
import Style exposing (..)


type Styles
    = None


styles : List (Style Styles variation)
styles =
    [ style None [] ]


view : Element Styles variation msg
view =
    el None [] (text "Footer")
