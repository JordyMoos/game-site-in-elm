module View.Layout.Header exposing (Styles(..), styles, view)

import Element exposing (..)
import Style exposing (..)


type Styles
    = None


styles : List (Style Styles variation)
styles =
    [ style None [] ]


view : Element Styles variation msg
view =
    el None [] (text "Header")



--navBar : Html msg
--navBar =
--    ul []
--        [ li [] [ a [ href "#" ] [ text "Home" ] ]
--        , li [] [ a [ href "#all-categories" ] [ text "All categories" ] ]
--        ]
