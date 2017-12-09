module Page.ItemCollection.ItemCollection exposing (Model, view)

import Data.ItemCollection as ItemCollection
import Data.Item as Item
import Data.Pagination as Pagination
import View.Layout as Layout
import View.Component.Main as Main
import View.Component.Sidebar as Sidebar
import Element
import Element.Attributes as Attributes
import Module.Paginator.Paginator as Paginator


type alias Model =
    { itemCollections : List ItemCollection.ItemCollection
    , itemCollection : ItemCollection.ItemCollection
    , items : List Item.Item
    , pagination : Pagination.Pagination
    }


view : Model -> Element.Element Layout.Styles variation msg
view model =
    Layout.withSidebarLayout
        (Element.column Main.None
            []
            [ Element.h1 Main.Title [] (Element.text (model.itemCollection.title ++ " Games"))
            , paginationView model.pagination model.itemCollection
            , itemsView model.items
            , paginationView model.pagination model.itemCollection
            ]
        )
        (Sidebar.view model.itemCollections)


itemsView : List Item.Item -> Element.Element Main.Styles variation msg
itemsView items =
    Element.wrappedRow
        Main.None
        [ Attributes.spacing 5 ]
        (List.map itemView items)


itemView : Item.Item -> Element.Element Main.Styles variation msg
itemView item =
    Element.column
        Main.None
        []
        [ Element.el Main.None [] (Element.text item.title)
        , Element.image Main.None
            []
            { src = item.image
            , caption = item.title
            }
        , Element.el Main.None [] (Element.text (item.since ++ " ago"))
        ]


paginationView :
    Pagination.Pagination
    -> ItemCollection.ItemCollection
    -> Element.Element Main.Styles variation msg
paginationView pagination itemCollection =
    Element.column
        Main.None
        []
        [ paginationTextView pagination
        , paginationButtonsContainerView pagination itemCollection
        ]


paginationTextView : Pagination.Pagination -> Element.Element Main.Styles variation msg
paginationTextView pagination =
    Element.el
        Main.None
        []
        (Element.text <| Pagination.message pagination)


paginationButtonsContainerView :
    Pagination.Pagination
    -> ItemCollection.ItemCollection
    -> Element.Element Main.Styles variation msg
paginationButtonsContainerView pagination itemCollection =
    Element.navigation
        Main.None
        []
        { name = "Pagination"
        , options =
            Paginator.paginator
                { currentPage = pagination.page
                , totalPages = ceiling (toFloat pagination.total / toFloat pagination.perPage)
                , pagesAroundCurrent = 2
                , linkStrategy =
                    (\page ->
                        case page of
                            1 ->
                                "#/category/" ++ itemCollection.slug

                            number ->
                                "#/category/" ++ itemCollection.slug ++ "/" ++ (toString number)
                    )
                }
                |> List.map toLink
        }


toLink : Paginator.Page -> Element.Element Main.Styles variation msg
toLink page =
    Element.link page.link (Element.el Main.None [] (Element.text page.content))
