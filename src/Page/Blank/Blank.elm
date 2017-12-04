module Page.Blank.Blank exposing (..)

import View.Layout as Layout
import Element
import View.Component.Sidebar as Sidebar


view : Element.Element Layout.Styles variation msg
view =
    Layout.withSidebarLayout
        Element.empty
        (Sidebar.view [])
