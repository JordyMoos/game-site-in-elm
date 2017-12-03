module Page.Home.Home exposing (Model, init, view)

import Html
import Data.ItemCollection as ItemCollection
import Data.ItemCollectionPreview as ItemCollectionPreview
import View.Layout.WithSidebar as WithSidebarLayout
import View.MainContentStyle as MainContentStyle
import View.Component.Sidebar as Sidebar
import Element
import Element.Attributes as Attributes


type alias Model =
    { itemCollections : List ItemCollection.ItemCollection
    , itemCollectionPreviews : List ItemCollectionPreview.ItemCollectionPreview
    }


init : Model
init =
    Model [] []


view : Model -> Html.Html msg
view model =
    WithSidebarLayout.view
        (Element.column MainContentStyle.None
            []
            [ Element.h1 MainContentStyle.None [] (Element.text "Popular Game Categories")
            , Element.el
                MainContentStyle.None
                []
                (itemCollectionPreviewsView model.itemCollectionPreviews)
            ]
        )
        (Sidebar.view model.itemCollections)


itemCollectionPreviewsView :
    List ItemCollectionPreview.ItemCollectionPreview
    -> Element.Element MainContentStyle.Styles variation msg
itemCollectionPreviewsView itemCollectionPreviews =
    Element.wrappedRow MainContentStyle.None
        []
        (List.map itemCollectionPreviewView itemCollectionPreviews)


itemCollectionPreviewView :
    ItemCollectionPreview.ItemCollectionPreview
    -> Element.Element MainContentStyle.Styles variation msg
itemCollectionPreviewView itemCollectionPreview =
    Element.column MainContentStyle.None
        [ Attributes.center, Attributes.width Attributes.fill, Attributes.spacing 5 ]
        [ Element.el MainContentStyle.None [ Attributes.alignLeft ] (Element.text itemCollectionPreview.title)
        , Element.image MainContentStyle.None
            [ Attributes.alignLeft ]
            { src = itemCollectionPreview.image
            , caption = itemCollectionPreview.title
            }
            |> Element.link ("#/category/" ++ itemCollectionPreview.slug)
        ]
