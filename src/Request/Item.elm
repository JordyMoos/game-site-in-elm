module Request.Item exposing (searchForItemCollectionSlug)

import Http
import Data.ItemSearchResult as ItemSearchResult
import RemoteData
import Request.Helpers exposing (apiUrl)


searchForItemCollectionSlug :
    (RemoteData.WebData ItemSearchResult.ItemSearchResult -> msg)
    -> String
    -> Cmd msg
searchForItemCollectionSlug msg itemCollectionSlug =
    Http.get (searchUrl itemCollectionSlug) ItemSearchResult.decoder
        |> RemoteData.sendRequest
        |> Cmd.map msg


searchUrl : String -> String
searchUrl itemCollectionSlug =
    apiUrl ("/item-by-slug/" ++ itemCollectionSlug)
