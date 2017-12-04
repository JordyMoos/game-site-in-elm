module Page.NotFound.NotFound exposing (view)

import Element
import View.Component.Main as Main
import View.Layout as Layout


view : Element.Element Layout.Styles variation msg
view =
    Layout.plainLayout
        (Element.h1
            Main.Title
            []
            (Element.text "Not Found")
        )
