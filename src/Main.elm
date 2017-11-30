module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href)
import Routing exposing (..)
import Page.Home as HomePage
import Page.AllItemCollections as AllItemCollectionsPage
import Page.UserAgreement as UserAgreementPage
import Page.NotFound as NotFoundPage
import Navigation
import Data.ItemCollection as ItemCollection
import RemoteData exposing (WebData)
import Command.FetchItemCollections as FetchItemCollectionsCommand


type alias Model =
    { route : Route
    , itemCollections : WebData (List ItemCollection.ItemCollection)
    }


initialModel : Route -> Model
initialModel route =
    { route = route
    , itemCollections = RemoteData.Loading
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        ( initialModel currentRoute, FetchItemCollectionsCommand.fetchItemCollections OnFetchItemCollections )


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }


type Msg
    = NoOp
    | OnFetchItemCollections (WebData (List ItemCollection.ItemCollection))
    | OnLocationChange Navigation.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        OnFetchItemCollections response ->
            ( { model | itemCollections = response }, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ navView
        , pageView model
        , itemCollectionsView model.itemCollections
        ]


navView : Html Msg
navView =
    ul []
        [ li [] [ a [ href "#" ] [ text "Home" ] ]
        , li [] [ a [ href "#all-categories" ] [ text "All categories" ] ]
        ]


pageView : Model -> Html Msg
pageView model =
    case model.route of
        HomeRoute ->
            HomePage.view model

        AllItemCollectionsRoute ->
            AllItemCollectionsPage.view model

        UserAgreementRoute ->
            UserAgreementPage.view model

        NotFoundRoute ->
            NotFoundPage.view model


itemCollectionsView : WebData (List ItemCollection.ItemCollection) -> Html Msg
itemCollectionsView itemCollectionsWebData =
    case itemCollectionsWebData of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success itemCollections ->
            List.map itemCollectionView itemCollections |> ul []

        RemoteData.Failure error ->
            text (toString error)


itemCollectionView : ItemCollection.ItemCollection -> Html Msg
itemCollectionView itemCollection =
    li [] [ text itemCollection.title ]
