module Page.ItemCollection.ItemCollection exposing (Model, view)

import Html
import Data.ItemCollection as ItemCollection
import Data.Item as Item
import Data.Pagination as Pagination
import View.Layout.WithSidebar as WithSidebarLayout
import View.MainContentStyle as MainContentStyle
import View.Component.Sidebar as Sidebar
import Element
import Element.Attributes as Attributes
import Maybe.Extra
import Module.Paginator.Paginator as Paginator


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
            [ Element.h1 MainContentStyle.Title [] (Element.text (model.itemCollection.title ++ " Games"))
            , paginationView model.pagination
            , itemsView model.items
            , paginationView model.pagination
            ]
        )
        (Sidebar.view model.itemCollections)


itemsView : List Item.Item -> Element.Element MainContentStyle.Styles variation msg
itemsView items =
    Element.wrappedRow
        MainContentStyle.None
        [ Attributes.spacing 5 ]
        (List.map itemView items)


itemView : Item.Item -> Element.Element MainContentStyle.Styles variation msg
itemView item =
    Element.column
        MainContentStyle.None
        []
        [ Element.el MainContentStyle.None [] (Element.text item.title)
        , Element.image MainContentStyle.None
            []
            { src = item.image
            , caption = item.title
            }
        , Element.el MainContentStyle.None [] (Element.text (item.since ++ " ago"))
        ]


paginationView : Pagination.Pagination -> Element.Element MainContentStyle.Styles variation msg
paginationView pagination =
    Element.column
        MainContentStyle.None
        []
        [ paginationTextView pagination
        , paginationButtonsContainerView pagination
        ]


paginationTextView : Pagination.Pagination -> Element.Element MainContentStyle.Styles variation msg
paginationTextView pagination =
    Element.el
        MainContentStyle.None
        []
        (Element.text <| Pagination.message pagination)


paginationButtonsContainerView : Pagination.Pagination -> Element.Element MainContentStyle.Styles variation msg
paginationButtonsContainerView pagination =
    Element.navigation
        MainContentStyle.None
        []
        { name = "Pagination"
        , options =
            []
        }
