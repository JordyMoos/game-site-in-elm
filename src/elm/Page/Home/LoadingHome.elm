module Page.Home.LoadingHome exposing (Model, Msg(..), init, update)

import Data.ItemCollection as ItemCollection
import Data.ItemCollectionPreview as ItemCollectionPreview
import Request.ItemCollection as ItemCollectionRequest
import Request.ItemCollectionPreview as ItemCollectionPreviewRequest
import RemoteData exposing (WebData)
import Page.Home.Home as Home
import PageLoader exposing (TransitionStatus(Pending, Success, Failed))
import PageLoader.DependencyStatus as DependencyStatus
import PageLoader.DependencyStatus.RemoteDataExt as RemoteDataExt


type alias Model =
    { itemCollections : WebData (List ItemCollection.ItemCollection)
    , itemCollectionPreviews : WebData (List ItemCollectionPreview.ItemCollectionPreview)
    }


type Msg
    = ItemCollectionsResponse (WebData (List ItemCollection.ItemCollection))
    | ItemCollectionPreviewsResponse (WebData (List ItemCollectionPreview.ItemCollectionPreview))


init : ( Model, Cmd Msg )
init =
    { itemCollections = RemoteData.Loading
    , itemCollectionPreviews = RemoteData.Loading
    }
        ! [ ItemCollectionRequest.list ItemCollectionsResponse
          , ItemCollectionPreviewRequest.list ItemCollectionPreviewsResponse
          ]


update : Msg -> Model -> TransitionStatus Model Msg Home.Model
update msg model =
    asTransitionStatus <|
        case msg of
            ItemCollectionsResponse response ->
                { model | itemCollections = response } ! []

            ItemCollectionPreviewsResponse response ->
                { model | itemCollectionPreviews = response }
                    ! []


asTransitionStatus :
    ( Model, Cmd Msg )
    -> TransitionStatus Model Msg Home.Model
asTransitionStatus ( model, cmd ) =
    PageLoader.defaultDependencyStatusListHandler
        ( model, cmd )
        (dependencyStatuses model)
        (\() ->
            { itemCollections = RemoteData.withDefault [] model.itemCollections
            , itemCollectionPreviews = RemoteData.withDefault [] model.itemCollectionPreviews
            }
        )


dependencyStatuses : Model -> List DependencyStatus.Status
dependencyStatuses model =
    [ RemoteDataExt.asStatus model.itemCollections
    , RemoteDataExt.asStatus model.itemCollectionPreviews
    ]
