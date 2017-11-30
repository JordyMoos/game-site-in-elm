module Command.FetchItemCollections exposing (..)

import Http
import Data.ItemCollection as ItemCollection
import RemoteData


fetchItemCollections : (RemoteData.WebData (List ItemCollection.ItemCollection) -> msg) -> Cmd msg
fetchItemCollections msg =
    Http.get fetchItemCollectionsUrl ItemCollection.listDecoder
        |> RemoteData.sendRequest
        |> Cmd.map msg


fetchItemCollectionsUrl : String
fetchItemCollectionsUrl =
    "http://localhost:5000/item-collections"
