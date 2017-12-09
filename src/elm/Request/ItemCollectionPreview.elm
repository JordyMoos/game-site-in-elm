module Request.ItemCollectionPreview exposing (list)

import Http
import Data.ItemCollectionPreview as ItemCollectionPreview
import RemoteData
import Request.Helpers exposing (apiUrl)


list :
    (RemoteData.WebData (List ItemCollectionPreview.ItemCollectionPreview) -> msg)
    -> Cmd msg
list msg =
    Http.get listUrl ItemCollectionPreview.listDecoder
        |> RemoteData.sendRequest
        |> Cmd.map msg


listUrl : String
listUrl =
    apiUrl "/item-collection-previews"
