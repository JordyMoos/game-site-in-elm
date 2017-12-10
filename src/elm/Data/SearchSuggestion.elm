module Data.SearchSuggestion exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)


type alias SearchSuggestion =
    String


listDecoder : Decoder (List SearchSuggestion)
listDecoder =
    Decode.list decoder


decoder : Decoder SearchSuggestion
decoder =
    Decode.string
