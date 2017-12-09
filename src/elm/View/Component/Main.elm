module View.Component.Main exposing (Styles(..), styles)

import Style exposing (..)
import Color
import Style.Color as Color
import Style.Font as Font


type Styles
    = None
    | ItemCollectionPreviewContainer
    | Title


styles : List (Style Styles variation)
styles =
    [ style None []
    , style ItemCollectionPreviewContainer
        []
    , style Title
        [ Color.text Color.darkCharcoal
        , Font.size 25
        ]
    ]
