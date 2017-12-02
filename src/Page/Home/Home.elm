module Page.Home.Home exposing (Model, init, view)

import Html exposing (..)
import Data.ItemCollection as ItemCollection
import Data.ItemCollectionPreview as ItemCollectionPreview


type alias Model =
    { itemCollections : List ItemCollection.ItemCollection
    , itemCollectionPreviews : List ItemCollectionPreview.ItemCollectionPreview
    }


init : Model
init =
    Model [] []


view : a -> Html msg
view model =
    div []
        [ h1 [] [ text "Home Page" ] ]
