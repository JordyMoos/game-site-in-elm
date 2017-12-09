module Data.ItemCollection exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)


type alias ItemCollection =
    { slug : String
    , title : String
    }


empty : ItemCollection
empty =
    ItemCollection "" ""


listDecoder : Decoder (List ItemCollection)
listDecoder =
    Decode.list decoder


decoder : Decoder ItemCollection
decoder =
    decode ItemCollection
        |> required "slug" Decode.string
        |> required "title" Decode.string
