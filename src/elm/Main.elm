module Main exposing (..)

import Html exposing (Html)
import Routing
import Page.NotFound.NotFound as NotFound
import Page.Blank.Blank as Blank
import Page.Errored.Errored as Errored
import Page.Home.LoadingHome as LoadingHome
import Page.Home.Home as Home
import Page.ItemCollection.LoadingItemCollection as LoadingItemCollection
import Page.ItemCollection.ItemCollection as ItemCollection
import Page.UserAgreement.UserAgreement as UserAgreement
import PageLoader.PageLoader as PageLoader exposing (PageState(Loaded, Transitioning))
import Navigation
import Element
import Style
import View.Component.Header as Header
import View.Component.Navbar as Navbar
import View.Component.Footer as Footer
import View.Component.Main as Main
import View.Layout as Layout
import Style.Sheet as Sheet
import Util.Util exposing (keepMsg, keepVariation)


type Page
    = BlankPage
    | NotFoundPage
    | ErroredPage Errored.Model
    | HomePage Home.Model
    | UserAgreementPage
    | ItemCollectionPage ItemCollection.Model


type Loading
    = LoadingHome LoadingHome.Model
    | LoadingItemCollection LoadingItemCollection.Model


type alias Model =
    { pageState : PageState Page Loading
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    setRoute (Routing.fromLocation location) initModel


initModel : Model
initModel =
    { pageState = Loaded BlankPage }


main : Program Never Model Msg
main =
    Navigation.program ChangeLocation
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }


type Msg
    = NoOp
    | ChangeLocation Navigation.Location
    | LoadingHomeMsg LoadingHome.Msg
    | LoadingItemCollectionMsg LoadingItemCollection.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.pageState ) of
        ( ChangeLocation location, _ ) ->
            let
                newRoute =
                    Routing.fromLocation location

                _ =
                    Debug.log "new route" (toString newRoute)
            in
                setRoute newRoute model

        ( LoadingHomeMsg subMsg, Transitioning oldPage (LoadingHome subModel) ) ->
            let
                transitionStatus =
                    LoadingHome.update subMsg subModel

                ( newModel, newCmd ) =
                    case transitionStatus of
                        PageLoader.Pending ( resultModel, resultCmd ) progression ->
                            { model
                                | pageState =
                                    Transitioning
                                        oldPage
                                        (LoadingHome resultModel)
                            }
                                ! [ Cmd.map LoadingHomeMsg resultCmd ]

                        PageLoader.Success data ->
                            { model
                                | pageState = Loaded (HomePage data)
                            }
                                ! []

                        PageLoader.Failed error ->
                            { model
                                | pageState = Loaded (ErroredPage error)
                            }
                                ! []
            in
                ( newModel, newCmd )

        ( LoadingItemCollectionMsg subMsg, Transitioning oldPage (LoadingItemCollection subModel) ) ->
            let
                transitionStatus =
                    LoadingItemCollection.update subMsg subModel

                ( newModel, newCmd ) =
                    case transitionStatus of
                        PageLoader.Pending ( resultModel, resultCmd ) progression ->
                            { model
                                | pageState =
                                    Transitioning
                                        oldPage
                                        (LoadingItemCollection resultModel)
                            }
                                ! [ Cmd.map LoadingItemCollectionMsg resultCmd ]

                        PageLoader.Success data ->
                            { model
                                | pageState = Loaded (ItemCollectionPage data)
                            }
                                ! []

                        PageLoader.Failed error ->
                            { model
                                | pageState = Loaded (ErroredPage error)
                            }
                                ! []
            in
                ( newModel, newCmd )

        ( NoOp, _ ) ->
            ( model, Cmd.none )

        ( _, _ ) ->
            let
                _ =
                    Debug.log "wrong message for state" (toString ( msg, model.pageState ))
            in
                ( model, Cmd.none )


setRoute : Maybe Routing.Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    case maybeRoute of
        Nothing ->
            { model | pageState = Loaded NotFoundPage } ! []

        Just Routing.Home ->
            let
                oldPage =
                    PageLoader.visualPage model.pageState

                ( newModel, newCmd ) =
                    LoadingHome.init
            in
                { model | pageState = Transitioning oldPage (LoadingHome newModel) }
                    ! [ Cmd.map LoadingHomeMsg newCmd ]

        Just (Routing.ItemCollection slug page) ->
            let
                oldPage =
                    PageLoader.visualPage model.pageState

                ( newModel, newCmd ) =
                    LoadingItemCollection.init slug page
            in
                { model | pageState = Transitioning oldPage (LoadingItemCollection newModel) }
                    ! [ Cmd.map LoadingItemCollectionMsg newCmd ]

        Just Routing.AllItemCollections ->
            model ! []

        Just Routing.UserAgreement ->
            { model | pageState = Loaded UserAgreementPage } ! []


view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage page
                |> viewWrapContent

        Transitioning oldPage transitionData ->
            viewPage oldPage
                |> viewWrapContent



-- @todo add loading
--                |> viewLoading


viewPage : Page -> Element.Element Layout.Styles variation msg
viewPage page =
    case page of
        BlankPage ->
            Blank.view

        NotFoundPage ->
            NotFound.view

        ErroredPage model ->
            Errored.view model

        HomePage model ->
            Home.view model

        ItemCollectionPage model ->
            ItemCollection.view model

        UserAgreementPage ->
            UserAgreement.view


type Styles
    = None
    | HeaderStyles Header.Styles
    | NavbarStyles Navbar.Styles
    | FooterStyles Footer.Styles
    | ContentStyles Layout.Styles


styleSheet : Style.StyleSheet Styles variation
styleSheet =
    Style.styleSheet
        [ Style.style None []
        , Sheet.map HeaderStyles keepVariation Header.styles |> Sheet.merge
        , Sheet.map NavbarStyles keepVariation Navbar.styles |> Sheet.merge
        , Sheet.map FooterStyles keepVariation Footer.styles |> Sheet.merge
        , Sheet.map ContentStyles keepVariation Layout.styles |> Sheet.merge
        ]


viewWrapContent : Element.Element Layout.Styles variation msg -> Html msg
viewWrapContent content =
    Element.layout styleSheet <|
        Element.column
            None
            []
            [ Element.mapAll keepMsg HeaderStyles keepVariation Header.view
            , Element.mapAll keepMsg NavbarStyles keepVariation Navbar.view
            , Element.mainContent None [] (Element.mapAll keepMsg ContentStyles keepVariation content)
            , Element.mapAll keepMsg FooterStyles keepVariation Footer.view
            ]



-- This should add the delayed loading bar, cool to do with web components
--viewLoading : Element.Element Styles variation msg -> Element.Element Styles variation msg
--viewLoading content =
--    content
