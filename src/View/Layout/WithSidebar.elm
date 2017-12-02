module View.Layout.WithSidebar exposing (view)

import Color
import Html exposing (Html)
import Element exposing (..)
import Style exposing (..)
import Style.Color as Color
import Style.Font as Font
import View.Layout.Header as Header
import Style.Sheet as Sheet


type Styles
    = None
    | Title
    | HeaderStyles Header.Styles


styleSheet : StyleSheet Styles variation
styleSheet =
    Style.styleSheet
        [ style None []
        , style Title
            [ Color.text Color.darkGrey
            , Color.background Color.white
            , Font.size 50
            ]
        , Sheet.map HeaderStyles (\x -> x) Header.styles |> Sheet.merge
        ]


view : Html msg
view =
    Element.layout styleSheet <|
        row
            None
            []
            [ el None [] (text "Title")
            ]
