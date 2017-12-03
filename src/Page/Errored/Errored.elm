module Page.Errored.Errored exposing (Model, view)

import Html exposing (Html)
import Element
import View.MainContentStyle as MainContentStyle
import View.Layout.Plain as PlainLayout


type alias Model =
    String


view : Model -> Html msg
view model =
    PlainLayout.view
        (Element.column MainContentStyle.None
            []
            [ Element.h1 MainContentStyle.Title [] (Element.text "Errored Page")
            , Element.el
                MainContentStyle.None
                []
                (Element.text model)
            ]
        )
