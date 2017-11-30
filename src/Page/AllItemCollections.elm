module Page.AllItemCollections exposing (..)

import Html exposing (..)


view : a -> Html msg
view model =
    div []
        [ h1 [] [ text "All Item Collections Page" ] ]
