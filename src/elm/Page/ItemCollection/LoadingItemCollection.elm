module Page.ItemCollection.LoadingItemCollection exposing (Model, Msg(..), init, update)

import Data.ItemCollection as ItemCollection
import Data.ItemSearchResult as ItemSearchResult
import Request.ItemCollection as ItemCollectionRequest
import Request.Item as ItemRequest
import RemoteData exposing (WebData)
import Page.ItemCollection.ItemCollection as ItemCollectionPage
import PageLoader.PageLoader as PageLoader exposing (TransitionStatus(Pending, Success, Failed))
import PageLoader.DependencyStatus.DependencyStatus as DependencyStatus
import PageLoader.DependencyStatus.RemoteDataExt as RemoteDataExt


type alias Model =
    { itemCollections : WebData (List ItemCollection.ItemCollection)
    , itemCollection : WebData ItemCollection.ItemCollection
    , itemSearchResult : WebData ItemSearchResult.ItemSearchResult
    , slug : String
    , page : Int
    }


type Msg
    = ItemCollectionsResponse (WebData (List ItemCollection.ItemCollection))
    | ItemCollectionResponse (WebData ItemCollection.ItemCollection)
    | ItemSearchResultResponse (WebData ItemSearchResult.ItemSearchResult)


init : String -> Int -> ( Model, Cmd Msg )
init slug page =
    { itemCollections = RemoteData.Loading
    , itemCollection = RemoteData.Loading
    , itemSearchResult = RemoteData.Loading
    , slug = slug
    , page = page
    }
        ! [ ItemCollectionRequest.list ItemCollectionsResponse
          , ItemCollectionRequest.bySlug ItemCollectionResponse slug
          , ItemRequest.searchForItemCollectionSlug ItemSearchResultResponse slug page
          ]


update : Msg -> Model -> TransitionStatus Model Msg ItemCollectionPage.Model
update msg model =
    asTransitionStatus <|
        case msg of
            ItemCollectionsResponse response ->
                { model | itemCollections = response } ! []

            ItemCollectionResponse response ->
                { model | itemCollection = response } ! []

            ItemSearchResultResponse response ->
                { model | itemSearchResult = response } ! []


asTransitionStatus :
    ( Model, Cmd Msg )
    -> TransitionStatus Model Msg ItemCollectionPage.Model
asTransitionStatus ( model, cmd ) =
    PageLoader.defaultListTransitionHandler
        ( model, cmd )
        (dependencyStatuses model)
        (\() ->
            let
                itemSearchResult =
                    RemoteData.withDefault ItemSearchResult.empty model.itemSearchResult
            in
                { itemCollections = RemoteData.withDefault [] model.itemCollections
                , itemCollection = RemoteData.withDefault ItemCollection.empty model.itemCollection
                , items = itemSearchResult.items
                , pagination = itemSearchResult.pagination
                }
        )


dependencyStatuses : Model -> List DependencyStatus.Status
dependencyStatuses model =
    [ RemoteDataExt.asStatus model.itemCollections
    , RemoteDataExt.asStatus model.itemCollection
    , RemoteDataExt.asStatus model.itemSearchResult
    ]
