module View.Layout.Header exposing (Styles(..), styles, view)

import Element exposing (..)
import Element.Attributes exposing (..)
import Style exposing (..)
import Color
import Style.Color as Color


type Styles
    = None
    | Header


styles : List (Style Styles variation)
styles =
    [ style None []
    , style Header
        [ Color.background (Color.rgb 178 30 3) ]
    ]


view : Element Styles variation msg
view =
    header
        Header
        [ height <| px 75 ]
        (text "Header")
