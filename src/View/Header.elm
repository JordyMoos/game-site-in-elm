module View.Header exposing (header)

import Html exposing (..)
import Html.Attributes exposing (href)


header : Html msg
header =
    div [] [ navBar ]


navBar : Html msg
navBar =
    ul []
        [ li [] [ a [ href "#" ] [ text "Home" ] ]
        , li [] [ a [ href "#all-categories" ] [ text "All categories" ] ]
        ]
