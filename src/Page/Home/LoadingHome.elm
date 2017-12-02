module Page.Home.LoadingHome exposing (Model, init, update)

import Data.ItemCollection as ItemCollection
import Data.TransitionStatus as TransitionStatus
import Request.ItemCollections as ItemCollectionRequest
import RemoteData exposing (WebData)
import Page.Home.Home as Home


type alias Model =
    { itemCollections : WebData (List ItemCollection.ItemCollection)
    }


totalDependencyCount : Int
totalDependencyCount =
    1


type Msg
    = ItemCollectionsResponse (WebData (List ItemCollection.ItemCollection))


init : ( Model, Cmd Msg )
init =
    { itemCollections = RemoteData.NotAsked }
        ! []
        |> requestItemCollections


requestItemCollections : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
requestItemCollections ( model, cmd ) =
    let
        itemCollectionsCmd =
            ItemCollectionRequest.list ItemCollectionsResponse
    in
        { model | itemCollections = RemoteData.Loading } ! [itemCollectionsCmd, cmd]


update : Msg -> Model -> TransitionStatus.TransitionStatus Model Msg Home.Model
update msg model =
    case msg of
        ItemCollectionsResponse response ->
            { model | itemCollections = response } ! []
                |> asTransitionStatus


asTransitionStatus : ( Model, Cmd Msg )
    -> TransitionStatus.TransitionStatus Model Msg Home.Model
asTransitionStatus ( model, cmd ) =
    let
        isFailed =
            hasFailed model

        finishedCount =
            getFinishedCount model

        isFinished =
            finishedCount == totalDependencyCount
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
                (TransitionStatus.Progression totalDependencyCount finishedCount)


hasFailed : Model -> Bool
hasFailed model =
    [ RemoteData.isFailure model.itemCollections ]
        |> List.any ((==) True)


getFinishedCount : Model -> Int
getFinishedCount model =
    [ RemoteData.isSuccess model.itemCollections ]
        |> List.filter ((==) True)
        |> List.length
