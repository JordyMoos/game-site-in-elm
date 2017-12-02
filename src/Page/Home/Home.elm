module Page.Home.Home exposing (Model, init, view)

import Html exposing (..)
import Data.ItemCollection as ItemCollection
import Data.ItemCollectionPreview as ItemCollectionPreview
import View.Layout.WithSidebar as WithSidebarLayout


type alias Model =
    { itemCollections : List ItemCollection.ItemCollection
    , itemCollectionPreviews : List ItemCollectionPreview.ItemCollectionPreview
    }


init : Model
init =
    Model [] []


view : a -> Html msg
view model =
    WithSidebarLayout.view
