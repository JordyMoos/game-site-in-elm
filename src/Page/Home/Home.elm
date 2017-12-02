module Page.Home.Home exposing (Model, init, view)

import Html exposing (..)
import Data.ItemCollection as ItemCollection


type alias Model =
    { itemCollections : List ItemCollection.ItemCollection
    }



init : Model
init =
    Model []


view : a -> Html msg
view model =
    div []
        [ h1 [] [ text "Home Page" ] ]
