module View.Layout.WithSidebar exposing (view)

import Color
import Html exposing (Html)
import Element exposing (..)
import Style exposing (..)
import Style.Color as Color
import Style.Font as Font
import View.Layout.Header as Header
import View.Layout.Footer as Footer
import Style.Sheet as Sheet
import View.MainContentStyle as MainContentStyle
import View.Component.Sidebar as Sidebar


type Styles
    = None
    | Title
    | HeaderStyles Header.Styles
    | FooterStyles Footer.Styles
    | MainContentStyles MainContentStyle.Styles
    | SidebarStyles Sidebar.Styles


styleSheet : StyleSheet Styles variation
styleSheet =
    Style.styleSheet
        [ style None []
        , style Title
            [ Color.text Color.darkGrey
            , Color.background Color.white
            , Font.size 50
            ]
        , Sheet.map HeaderStyles (\x -> x) Header.styles |> Sheet.merge
        , Sheet.map FooterStyles (\x -> x) Footer.styles |> Sheet.merge
        , Sheet.map MainContentStyles (\x -> x) MainContentStyle.styles |> Sheet.merge
        , Sheet.map SidebarStyles (\x -> x) Sidebar.styles |> Sheet.merge
        ]


view :
    Element MainContentStyle.Styles variation msg
    -> Element Sidebar.Styles variation msg
    -> Html msg
view content sideContent =
    Element.layout styleSheet <|
        column
            None
            []
            [ Element.mapAll (\x -> x) HeaderStyles (\x -> x) Header.view
            , Element.row None
                []
                [ mainContent None [] (Element.mapAll (\x -> x) MainContentStyles (\x -> x) content)
                , el None [] (Element.mapAll (\x -> x) SidebarStyles (\x -> x) sideContent)
                ]
            , Element.mapAll (\x -> x) FooterStyles (\x -> x) Footer.view
            ]
