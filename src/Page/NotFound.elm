module Page.NotFound exposing (..)

import Html exposing (..)


view : a -> Html msg
view model =
    div []
        [ h1 [] [ text "Not Found Page" ] ]
