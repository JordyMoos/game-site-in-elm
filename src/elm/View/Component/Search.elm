module View.Component.Search exposing (viewSearch)

import Html exposing (..)
import Html.Attributes exposing (..)


viewSearch : Html msg
viewSearch =
    node
        "paper-autocomplete"
        [ id "searchInput"
        , attribute "label" "Search ..."
        , attribute "no-label-float" "no-label-float"
        , attribute "maxlength" "100"
        , attribute "remote-source" "remote-source"
        ]
        [ node "paper-icon-button"
            [ attribute "slot" "suffix"
            , attribute "suffix" "suffix"
            , attribute "icon" "search"
            ]
            []
        ]
