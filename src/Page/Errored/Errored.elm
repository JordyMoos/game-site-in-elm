module Page.Errored.Errored exposing (Model, init, view)

import Html exposing (..)


type alias Model =
    ()


init : Model
init =
    ()


view : a -> Html msg
view model =
    div []
        [ h1 [] [ text "Errored Page" ] ]
