module View.Component.Footer exposing (Styles(..), styles, view)

import Element exposing (..)
import Element.Attributes exposing (..)
import Style exposing (..)
import Color
import Style.Color as Color
import Style.Border as Border


type Styles
    = None
    | Footer


styles : List (Style Styles variation)
styles =
    [ style None []
    , style Footer
        [ Color.background (Color.rgb 221 221 221)
        , Border.top 1
        , Color.border Color.black
        ]
    ]


view : Element Styles variation msg
view =
    footer
        Footer
        [ height fill ]
        (text "Footer")
