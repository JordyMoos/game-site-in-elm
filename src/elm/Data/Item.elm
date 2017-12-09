module Data.Item exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)


type alias Item =
    { title : String
    , image : String
    , since : String
    , url : String
    }


listDecoder : Decoder (List Item)
listDecoder =
    Decode.list decoder


decoder : Decoder Item
decoder =
    decode Item
        |> required "title" Decode.string
        |> required "image" Decode.string
        |> required "since" Decode.string
        |> required "url" Decode.string
