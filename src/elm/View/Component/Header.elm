module View.Component.Header exposing (Styles(..), styles, view)

import Element exposing (..)
import Element.Attributes exposing (..)
import Style exposing (..)
import Color
import Style.Color as Color


type Styles
    = None
    | Header
    | SearchBox


styles : List (Style Styles variation)
styles =
    [ style None []
    , style Header
        [ Color.background (Color.rgb 178 30 3) ]
    , style SearchBox
        [ Color.background Color.white ]
    ]


view : Element Styles variation msg
view =
    header
        Header
        [ height <| px 75 ]
        (row None
            []
            [ text "Header here"
            , node "paper-autocomplete"
                (el SearchBox
                    [ attribute "id" "searchInput"
                    , attribute "label" "Search ..."
                    , attribute "no-label-float" "no-label-float"
                    ]
                    (node "paper-icon-button"
                        (el None
                            [ attribute "slot" "suffix"
                            , attribute "suffix" "suffix"
                            , attribute "icon" "search"
                            ]
                            empty
                        )
                    )
                )
            ]
        )
