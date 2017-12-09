module Data.ItemCollectionPreview exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)


type alias ItemCollectionPreview =
    { slug : String
    , title : String
    , image : String
    }


listDecoder : Decoder (List ItemCollectionPreview)
listDecoder =
    Decode.list decoder


decoder : Decoder ItemCollectionPreview
decoder =
    decode ItemCollectionPreview
        |> required "slug" Decode.string
        |> required "title" Decode.string
        |> required "image" Decode.string
