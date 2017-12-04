module View.Layout exposing (Styles(..), styles, withSidebarLayout, plainLayout)

import Element exposing (..)
import Style exposing (..)
import View.Component.Main as Main
import Style.Sheet as Sheet
import View.Component.Sidebar as Sidebar
import Util.Util exposing (keepMsg, keepVariation)


type Styles
    = None
    | MainContentStyles Main.Styles
    | SidebarStyles Sidebar.Styles


styles : List (Style Styles variation)
styles =
    [ style None []
    , Sheet.map MainContentStyles keepVariation Main.styles |> Sheet.merge
    , Sheet.map SidebarStyles keepVariation Sidebar.styles |> Sheet.merge
    ]


withSidebarLayout :
    Element Main.Styles variation msg
    -> Element Sidebar.Styles variation msg
    -> Element Styles variation msg
withSidebarLayout content sideContent =
    Element.row None
        []
        [ mainContent None [] (Element.mapAll keepMsg MainContentStyles keepVariation content)
        , el None [] (Element.mapAll keepMsg SidebarStyles keepVariation sideContent)
        ]


plainLayout :
    Element Main.Styles variation msg
    -> Element Styles variation msg
plainLayout content =
    mainContent None [] (Element.mapAll keepMsg MainContentStyles keepVariation content)
