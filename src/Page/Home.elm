module Page.Home exposing (..)

import Html exposing (..)


view : a -> Html msg
view model =
    div []
        [ h1 [] [ text "Home Page" ] ]
