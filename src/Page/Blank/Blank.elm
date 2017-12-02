module Page.Blank.Blank exposing (..)

import Html exposing (..)
import View.Header as Header


view : Html msg
view =
    div []
        [ Header.header
        , h1 [] [ text "<Blank Page>" ]
        ]
