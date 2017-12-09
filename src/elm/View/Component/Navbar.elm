module View.Component.Navbar exposing (Styles(..), styles, view)

import Style exposing (..)
import Element exposing (..)
import Data.ItemCollection as ItemCollection
import Color
import Style.Color as Color


type Styles
    = None
    | Navigation


styles : List (Style Styles variation)
styles =
    [ style None []
    , style Navigation
        [ Color.background (Color.rgb 221 221 221)
        ]
    ]


view : Element Styles variable msg
view =
    navigation
        Navigation
        []
        { name = "Main Navigation"
        , options =
            [ link "#" (el None [] (text "Home"))
            ]
        }
