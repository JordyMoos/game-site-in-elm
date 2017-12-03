module Page.ItemCollection.ItemCollection exposing (Model, init, view)

import Html
import Data.ItemCollection as ItemCollection
import Data.Item as Item
import View.Layout.WithSidebar as WithSidebarLayout
import View.MainContentStyle as MainContentStyle
import View.Component.Sidebar as Sidebar
import Element


type alias Model =
    { itemCollections : List ItemCollection.ItemCollection
    , itemCollection : ItemCollection.ItemCollection
    , items : List Item.Item
    }


init : Model
init =
    Model [] ItemCollection.empty []


view : Model -> Html.Html msg
view model =
    WithSidebarLayout.view
        (Element.column MainContentStyle.None
            []
            [ Element.h1 MainContentStyle.None [] (Element.text (model.itemCollection.title ++ " games"))
            , Element.el
                MainContentStyle.None
                []
                (Element.text "Content")
            ]
        )
        (Sidebar.view model.itemCollections)
