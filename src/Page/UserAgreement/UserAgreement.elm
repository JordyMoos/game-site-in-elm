module Page.UserAgreement.UserAgreement exposing (Model, init, view)

import Html exposing (..)
import View.Header as Header


type alias Model =
    ()


init : Model
init =
    ()


view : a -> Html msg
view model =
    div []
        [ Header.header
        , h1 [] [ text "User Agreement Page" ]
        ]
