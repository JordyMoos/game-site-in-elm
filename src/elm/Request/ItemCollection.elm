module Request.ItemCollection exposing (bySlug, list)

import Http
import Data.ItemCollection as ItemCollection
import RemoteData
import Request.Helpers exposing (apiUrl)


bySlug :
    (RemoteData.WebData ItemCollection.ItemCollection -> msg)
    -> String
    -> Cmd msg
bySlug msg slug =
    Http.get (slugUrl slug) ItemCollection.decoder
        |> RemoteData.sendRequest
        |> Cmd.map msg


list : (RemoteData.WebData (List ItemCollection.ItemCollection) -> msg) -> Cmd msg
list msg =
    Http.get listUrl ItemCollection.listDecoder
        |> RemoteData.sendRequest
        |> Cmd.map msg


slugUrl : String -> String
slugUrl slug =
    apiUrl ("/item-collection/" ++ slug)


listUrl : String
listUrl =
    apiUrl "/item-collections"
