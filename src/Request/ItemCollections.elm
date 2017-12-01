module Request.ItemCollections exposing (list)

import Http
import Data.ItemCollection as ItemCollection
import RemoteData
import Request.Helpers exposing (apiUrl)


list : (RemoteData.WebData (List ItemCollection.ItemCollection) -> msg) -> Cmd msg
list msg =
    Http.get listUrl ItemCollection.listDecoder
        |> RemoteData.sendRequest
        |> Cmd.map msg


listUrl : String
listUrl =
    apiUrl "/item-collections"
