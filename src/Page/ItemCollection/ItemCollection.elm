module Page.ItemCollection.ItemCollection exposing (Model, view)

import Html
import Data.ItemCollection as ItemCollection
import Data.Item as Item
import Data.Pagination as Pagination
import View.Layout.WithSidebar as WithSidebarLayout
import View.MainContentStyle as MainContentStyle
import View.Component.Sidebar as Sidebar
import Element


type alias Model =
    { itemCollections : List ItemCollection.ItemCollection
    , itemCollection : ItemCollection.ItemCollection
    , items : List Item.Item
    , pagination : Pagination.Pagination
    }


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
