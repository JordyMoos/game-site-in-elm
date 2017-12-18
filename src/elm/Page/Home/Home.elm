module Page.Home.Home exposing (Model, init, view)

import Data.ItemCollection as ItemCollection
import Data.ItemCollectionPreview as ItemCollectionPreview
import View.Component.Main as Main
import View.Component.Sidebar as Sidebar
import View.Layout as Layout
import Element
import Element.Attributes as Attributes


type alias Model =
    { itemCollections : List ItemCollection.ItemCollection
    , itemCollectionPreviews : List ItemCollectionPreview.ItemCollectionPreview
    }


init : Model -> ( Model, Cmd msg )
init model =
    model ! []


view : Model -> Element.Element Layout.Styles variation msg
view model =
    Layout.withSidebarLayout
        (Element.column Main.None
            []
            [ Element.h1 Main.Title [] (Element.text "Popular Game Categories")
            , Element.el
                Main.None
                []
                (itemCollectionPreviewsView model.itemCollectionPreviews)
            ]
        )
        (Sidebar.view model.itemCollections)


itemCollectionPreviewsView :
    List ItemCollectionPreview.ItemCollectionPreview
    -> Element.Element Main.Styles variation msg
itemCollectionPreviewsView itemCollectionPreviews =
    Element.wrappedRow Main.None
        []
        (List.map itemCollectionPreviewView itemCollectionPreviews)


itemCollectionPreviewView :
    ItemCollectionPreview.ItemCollectionPreview
    -> Element.Element Main.Styles variation msg
itemCollectionPreviewView itemCollectionPreview =
    Element.column Main.None
        [ Attributes.center, Attributes.width Attributes.fill, Attributes.spacing 5 ]
        [ Element.el Main.None [ Attributes.alignLeft ] (Element.text itemCollectionPreview.title)
        , Element.image Main.None
            [ Attributes.alignLeft ]
            { src = itemCollectionPreview.image
            , caption = itemCollectionPreview.title
            }
            |> Element.link ("#/category/" ++ itemCollectionPreview.slug)
        ]
