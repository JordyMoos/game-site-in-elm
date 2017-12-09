module Data.ItemSearchResult exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)
import Data.Pagination as Pagination
import Data.Item as Item


type alias ItemSearchResult =
    { pagination : Pagination.Pagination
    , items : List Item.Item
    }


empty : ItemSearchResult
empty =
    { pagination = Pagination.empty
    , items = []
    }


decoder : Decoder ItemSearchResult
decoder =
    decode ItemSearchResult
        |> required "pagination" Pagination.decoder
        |> required "items" Item.listDecoder
