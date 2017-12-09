module Page.ItemCollection.LoadingItemCollection exposing (Model, Msg(..), init, update)

import Data.ItemCollection as ItemCollection
import Data.ItemSearchResult as ItemSearchResult
import Data.TransitionStatus as TransitionStatus
import Request.ItemCollection as ItemCollectionRequest
import Request.Item as ItemRequest
import RemoteData exposing (WebData)
import Util.RemoteDataExt.Status as RemoteDataStatus
import Page.ItemCollection.ItemCollection as ItemCollectionPage


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
    { itemCollections = RemoteData.NotAsked
    , itemCollection = RemoteData.NotAsked
    , itemSearchResult = RemoteData.NotAsked
    , slug = slug
    , page = page
    }
        ! []
        |> requestData


requestData : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
requestData ( model, cmd ) =
    let
        itemCollectionsCmd =
            ItemCollectionRequest.list ItemCollectionsResponse

        itemCollectionCmd =
            ItemCollectionRequest.bySlug ItemCollectionResponse model.slug

        itemSearchResultCmd =
            ItemRequest.searchForItemCollectionSlug ItemSearchResultResponse model.slug model.page
    in
        { model
            | itemCollections = RemoteData.Loading
            , itemCollection = RemoteData.Loading
            , itemSearchResult = RemoteData.Loading
        }
            ! [ itemCollectionsCmd, itemCollectionCmd, itemSearchResultCmd, cmd ]


update : Msg -> Model -> TransitionStatus.TransitionStatus Model Msg ItemCollectionPage.Model
update msg model =
    let
        ( newModel, newCmd ) =
            case msg of
                ItemCollectionsResponse response ->
                    { model | itemCollections = response } ! []

                ItemCollectionResponse response ->
                    { model | itemCollection = response } ! []

                ItemSearchResultResponse response ->
                    { model | itemSearchResult = response } ! []
    in
        asTransitionStatus ( newModel, newCmd )


asTransitionStatus :
    ( Model, Cmd Msg )
    -> TransitionStatus.TransitionStatus Model Msg ItemCollectionPage.Model
asTransitionStatus ( model, cmd ) =
    let
        isFailed =
            hasFailedDependencies model

        finishedCount =
            getFinishedDependencyCount model

        totalCount =
            totalDependencyCount model

        isFinished =
            finishedCount == totalCount
    in
        if isFailed then
            TransitionStatus.Failed "Some requests failed"
        else if isFinished then
            let
                itemSearchResult =
                    RemoteData.withDefault ItemSearchResult.empty model.itemSearchResult
            in
                TransitionStatus.Success
                    { itemCollections = RemoteData.withDefault [] model.itemCollections
                    , itemCollection = RemoteData.withDefault ItemCollection.empty model.itemCollection
                    , items = itemSearchResult.items
                    , pagination = itemSearchResult.pagination
                    }
        else
            TransitionStatus.Pending
                ( model, cmd )
                (TransitionStatus.Progression totalCount finishedCount)


dependencyStatuses : Model -> List RemoteDataStatus.Status
dependencyStatuses model =
    [ RemoteDataStatus.asStatus model.itemCollections
    , RemoteDataStatus.asStatus model.itemCollection
    , RemoteDataStatus.asStatus model.itemSearchResult
    ]


totalDependencyCount : Model -> Int
totalDependencyCount model =
    dependencyStatuses model
        |> List.length


hasFailedDependencies : Model -> Bool
hasFailedDependencies model =
    dependencyStatuses model
        |> List.any RemoteDataStatus.isFailed


getFinishedDependencyCount : Model -> Int
getFinishedDependencyCount model =
    dependencyStatuses model
        |> List.filter RemoteDataStatus.isSuccess
        |> List.length
