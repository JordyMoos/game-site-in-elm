module Request.Item exposing (searchForItemCollectionSlug)

import Http
import Data.ItemSearchResult as ItemSearchResult
import RemoteData
import Request.Helpers exposing (apiUrl)


searchForItemCollectionSlug :
    (RemoteData.WebData ItemSearchResult.ItemSearchResult -> msg)
    -> String
    -> Int
    -> Cmd msg
searchForItemCollectionSlug msg itemCollectionSlug page =
    Http.get (searchUrl itemCollectionSlug page) ItemSearchResult.decoder
        |> RemoteData.sendRequest
        |> Cmd.map msg


searchUrl : String -> Int -> String
searchUrl itemCollectionSlug page =
    apiUrl ("/item-by-slug/" ++ itemCollectionSlug ++ "/" ++ (toString page))
