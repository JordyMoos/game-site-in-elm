module View.Component.Header exposing (Styles(..), styles, view)

import Element exposing (..)
import Element.Attributes exposing (..)
import Style exposing (..)
import Color
import Style.Color as Color
import Data.Search as Search
import Data.SearchSuggestion as SearchSuggestion
import Json.Encode as Encode


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


view : Search.Search -> Element Styles variation msg
view search =
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
                    , attribute "text" search.input
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
            , node "paper-autocomplete-suggestions"
                (el None
                    [ attribute "for" "searchInput"
                    , attribute "source" (encodeSuggestions search.suggestions)
                    , attribute "remoteSource" "true"
                    , attribute "showResultsOnFocus" "true"
                    ]
                    empty
                )
            ]
        )


encodeSuggestions : List SearchSuggestion.SearchSuggestion -> String
encodeSuggestions suggestions =
    List.map encodeSuggestion suggestions
        |> Encode.list
        |> Encode.encode 0


encodeSuggestion : SearchSuggestion.SearchSuggestion -> Encode.Value
encodeSuggestion suggestion =
    Encode.object
        [ ( "text", Encode.string suggestion )
        , ( "value", Encode.string suggestion )
        ]
