module Page.ItemCollection.LoadingItemCollection exposing (Model, Msg(..), init, update)

import Data.ItemCollection as ItemCollection
import Data.Item as Item
import Data.TransitionStatus as TransitionStatus
import Request.ItemCollection as ItemCollectionRequest
import Request.Item as ItemRequest
import RemoteData exposing (WebData)
import Util.RemoteDataExt.Status as RemoteDataStatus
import Page.ItemCollection.ItemCollection as ItemCollectionPage


type alias Model =
    { itemCollections : WebData (List ItemCollection.ItemCollection)
    , itemCollection : WebData ItemCollection.ItemCollection
    , items : WebData (List Item.Item)
    , slug : String
    }


type Msg
    = ItemCollectionsResponse (WebData (List ItemCollection.ItemCollection))
    | ItemCollectionResponse (WebData ItemCollection.ItemCollection)
    | ItemsResponse (WebData (List Item.Item))


init : String -> ( Model, Cmd Msg )
init slug =
    { itemCollections = RemoteData.NotAsked
    , itemCollection = RemoteData.NotAsked
    , items = RemoteData.NotAsked
    , slug = slug
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

        itemCmd =
            ItemRequest.searchForItemCollectionSlug ItemsResponse model.slug
    in
        { model
            | itemCollections = RemoteData.Loading
            , itemCollection = RemoteData.Loading
            , items = RemoteData.Loading
        }
            ! [ itemCollectionsCmd, itemCollectionCmd, itemCmd, cmd ]


update : Msg -> Model -> TransitionStatus.TransitionStatus Model Msg ItemCollectionPage.Model
update msg model =
    let
        ( newModel, newCmd ) =
            case msg of
                ItemCollectionsResponse response ->
                    { model | itemCollections = response } ! []

                ItemCollectionResponse response ->
                    { model | itemCollection = response } ! []

                ItemsResponse response ->
                    { model | items = response } ! []
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
            TransitionStatus.Success
                { itemCollections = RemoteData.withDefault [] model.itemCollections
                , itemCollection = RemoteData.withDefault ItemCollection.empty model.itemCollection
                , items = RemoteData.withDefault [] model.items
                }
        else
            TransitionStatus.Pending
                ( model, cmd )
                (TransitionStatus.Progression totalCount finishedCount)


dependencyStatuses : Model -> List RemoteDataStatus.Status
dependencyStatuses model =
    [ RemoteDataStatus.asStatus model.itemCollections
    , RemoteDataStatus.asStatus model.itemCollection
    , RemoteDataStatus.asStatus model.items
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
