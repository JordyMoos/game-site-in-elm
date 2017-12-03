module View.Layout.Plain exposing (view)

import Color
import Html exposing (Html)
import Element exposing (..)
import Style exposing (..)
import Style.Color as Color
import Style.Font as Font
import View.Component.Header as Header
import View.Component.Navbar as Navbar
import View.Component.Footer as Footer
import Style.Sheet as Sheet
import View.MainContentStyle as MainContentStyle
import View.Component.Sidebar as Sidebar
import Util.Util exposing (keepMsg, keepVariation)


type Styles
    = None
    | Title
    | HeaderStyles Header.Styles
    | NavbarStyles Navbar.Styles
    | FooterStyles Footer.Styles
    | MainContentStyles MainContentStyle.Styles


styleSheet : StyleSheet Styles variation
styleSheet =
    Style.styleSheet
        [ style None []
        , style Title
            [ Color.text Color.darkGrey
            , Color.background Color.white
            , Font.size 50
            ]
        , Sheet.map HeaderStyles keepVariation Header.styles |> Sheet.merge
        , Sheet.map NavbarStyles keepVariation Navbar.styles |> Sheet.merge
        , Sheet.map FooterStyles keepVariation Footer.styles |> Sheet.merge
        , Sheet.map MainContentStyles keepVariation MainContentStyle.styles |> Sheet.merge
        ]


view :
    Element MainContentStyle.Styles variation msg
    -> Html msg
view content =
    Element.layout styleSheet <|
        column
            None
            []
            [ Element.mapAll keepMsg HeaderStyles keepVariation Header.view
            , Element.mapAll keepMsg NavbarStyles keepVariation Navbar.view
            , mainContent None [] (Element.mapAll keepMsg MainContentStyles keepVariation content)
            , Element.mapAll keepMsg FooterStyles keepVariation Footer.view
            ]
