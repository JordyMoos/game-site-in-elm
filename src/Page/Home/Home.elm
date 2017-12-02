module Page.Home.Home exposing (Model, init, view)

import Html exposing (..)
import Data.ItemCollection as ItemCollection
import Data.ItemCollectionPreview as ItemCollectionPreview
import View.Layout.WithSidebar as WithSidebarLayout
import View.MainContentStyle as MainContentStyle
import View.SidebarStyle as SidebarStyle
import Element


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
        (Element.el MainContentStyle.None [] (Element.text "Home Page"))
        (Element.el SidebarStyle.None [] (Element.text "Sidebar"))
