module Page.Errored.Errored exposing (Model, view)

import Element
import View.Layout as Layout
import View.Component.Main as Main


type alias Model =
    String


view : Model -> Element.Element Layout.Styles variation msg
view model =
    Layout.plainLayout
        (Element.column Main.None
            []
            [ Element.h1 Main.Title [] (Element.text "Errored Page")
            , Element.el
                Main.None
                []
                (Element.text model)
            ]
        )
