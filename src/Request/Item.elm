module Request.Item exposing (searchForItemCollectionSlug)

import Http
import Data.Item as Item
import RemoteData
import Request.Helpers exposing (apiUrl)


searchForItemCollectionSlug :
    (RemoteData.WebData (List Item.Item) -> msg)
    -> String
    -> Cmd msg
searchForItemCollectionSlug msg itemCollectionSlug =
    Http.get (searchUrl itemCollectionSlug) Item.listDecoder
        |> RemoteData.sendRequest
        |> Cmd.map msg


searchUrl : String -> String
searchUrl itemCollectionSlug =
    apiUrl ("/item-by-slug/" ++ itemCollectionSlug)
