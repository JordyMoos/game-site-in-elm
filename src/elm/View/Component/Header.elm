module View.Component.Header exposing (Styles(..), styles, view)

import Element exposing (..)
import Element.Attributes exposing (..)
import Style exposing (..)
import Color
import Style.Color as Color
import Style.Border as Border
import View.Component.Search as Search


type Styles
    = None
    | Header
    | SearchBox


styles : List (Style Styles variation)
styles =
    [ style None []
    , style Header
        [ Color.background (Color.rgb 178 30 3) ]
    , style SearchBox
        [ Color.background Color.white
        , Border.rounded 3
        ]
    ]


view : Element Styles variation msg
view =
    header
        Header
        [ height <| px 75 ]
        (row None
            [ alignRight, width fill, paddingTop 15, paddingRight 30 ]
            [ el
                SearchBox
                [ paddingXY 10 2, width (px 300) ]
                (html Search.viewSearch)
            ]
        )
