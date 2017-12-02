module Page.Home.LoadingHome exposing (Model, init, update)

import Data.ItemCollection as ItemCollection
import Data.ItemCollectionPreview as ItemCollectionPreview
import Data.TransitionStatus as TransitionStatus
import Request.ItemCollection as ItemCollectionRequest
import Request.ItemCollectionPreview as ItemCollectionPreviewRequest
import RemoteData exposing (WebData)
import Util.RemoteDataExt.Status as RemoteDataStatus
import Page.Home.Home as Home


type alias Model =
    { itemCollections : WebData (List ItemCollection.ItemCollection)
    , itemCollectionPreviews : WebData (List ItemCollectionPreview.ItemCollectionPreview)
    }


type Msg
    = ItemCollectionsResponse (WebData (List ItemCollection.ItemCollection))
    | ItemCollectionPreviewsResponse (WebData (List ItemCollectionPreview.ItemCollectionPreview))


init : ( Model, Cmd Msg )
init =
    { itemCollections = RemoteData.NotAsked
     , itemCollectionPreviews = RemoteData.NotAsked} ! []
        |> requestData


requestData : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
requestData ( model, cmd ) =
    let
        itemCollectionsCmd =
            ItemCollectionRequest.list ItemCollectionsResponse

        itemCollectionPreviewsCmd
            = ItemCollectionPreviewRequest.list ItemCollectionPreviewsResponse
    in
        { model
        | itemCollections = RemoteData.Loading
        , itemCollectionPreviews = RemoteData.Loading }
        ! [itemCollectionsCmd, itemCollectionPreviewsCmd, cmd]


update : Msg -> Model -> TransitionStatus.TransitionStatus Model Msg Home.Model
update msg model =
    let
        (newModel, newCmd) =
            case msg of
                ItemCollectionsResponse response ->
                    { model | itemCollections = response } ! []


                ItemCollectionPreviewsResponse response ->
                    { model | itemCollectionPreviews = response } ! []
    in
        asTransitionStatus (newModel, newCmd)

asTransitionStatus : ( Model, Cmd Msg )
    -> TransitionStatus.TransitionStatus Model Msg Home.Model
asTransitionStatus ( model, cmd ) =
    let
        isFailed =
            hasFailedDependencies model

        finishedCount =
            getFinishedDependencyCount model

        totalCount = totalDependencyCount model

        isFinished =
            finishedCount == totalCount
    in
        if isFailed then
            TransitionStatus.Failed "Some requests failed"
        else if isFinished then
            TransitionStatus.Success
                { itemCollections = RemoteData.withDefault [] model.itemCollections
                }
        else
            TransitionStatus.Pending
                ( model, cmd )
                (TransitionStatus.Progression totalCount finishedCount)


dependencyStatuses : Model -> List RemoteDataStatus.Status
dependencyStatuses model =
    [ RemoteDataStatus.asStatus model.itemCollections
    , RemoteDataStatus.asStatus model.itemCollectionPreviews
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
