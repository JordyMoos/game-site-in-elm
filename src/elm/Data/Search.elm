module Data.Search exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)
import Data.SearchSuggestion as SearchSuggestion


type alias Search =
    { input : String
    , suggestions : List SearchSuggestion.SearchSuggestion
    }


empty : Search
empty =
    { input = "Army"
    , suggestions = [ "Super army", "Other army", "Even another army" ]
    }


withInput : Search -> String -> Search
withInput search input =
    { search | input = input }


decoder : Decoder Search
decoder =
    decode Search
        |> required "input" Decode.string
        |> required "suggestions" SearchSuggestion.listDecoder
