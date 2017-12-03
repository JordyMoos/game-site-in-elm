module Page.Blank.Blank exposing (..)

import Html
import View.Layout.WithSidebar as WithSidebarLayout
import Element
import View.MainContentStyle as MainContentStyle
import View.Component.Sidebar as Sidebar


view : Html.Html msg
view =
    WithSidebarLayout.view
        Element.empty
        (Sidebar.view [])
