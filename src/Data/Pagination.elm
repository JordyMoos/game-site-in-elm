module Data.Pagination exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)


type alias Pagination =
    { total : Int
    , page : Int
    , perPage : Int
    }


empty : Pagination
empty =
    { total = 0
    , page = 0
    , perPage = 0
    }


decoder : Decoder Pagination
decoder =
    decode Pagination
        |> required "total" Decode.int
        |> required "page" Decode.int
        |> required "per_page" Decode.int
