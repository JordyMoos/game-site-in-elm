module Page.NotFound.NotFound exposing (view)

import Html exposing (Html)
import Element
import View.MainContentStyle as MainContentStyle
import View.Layout.Plain as PlainLayout


view : Html msg
view =
    PlainLayout.view
        (Element.h1
            MainContentStyle.Title
            []
            (Element.text "Not Found")
        )
