module View.Component.Sidebar exposing (Styles(..), styles, view)

import Style exposing (..)
import Element exposing (..)
import Data.ItemCollection as ItemCollection


type Styles
    = None


styles : List (Style Styles variation)
styles =
    [ style None [] ]


view : List ItemCollection.ItemCollection -> Element Styles variable msg
view itemCollections =
    Element.column None
        []
        [ Element.h2 None [] (text "Top 100 Game Categories")
        , Element.column None
            []
            (List.map
                itemCollectionView
                itemCollections
            )
        ]


itemCollectionView : ItemCollection.ItemCollection -> Element Styles variable msg
itemCollectionView itemCollection =
    el None [] (text itemCollection.title)
        |> Element.link ("#/category/" ++ itemCollection.slug)
