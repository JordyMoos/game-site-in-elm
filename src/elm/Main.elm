module Main exposing (..)

import Html exposing (Html)
import Routing
import Page.NotFound as NotFound
import Page.Blank as Blank
import Page.Error as Error
import Page.Home.LoadingHome as LoadingHome
import Page.Home.Home as Home
import Page.ItemCollection.LoadingItemCollection as LoadingItemCollection
import Page.ItemCollection.ItemCollection as ItemCollection
import Page.UserAgreement as UserAgreement
import PageLoader exposing (PageState(Loaded, Transitioning), TransitionStatus(..))
import PageLoader.Progression as Progression
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
    | ErrorPage Error.Model
    | HomePage Home.Model
    | UserAgreementPage
    | ItemCollectionPage ItemCollection.Model


type Loading
    = LoadingHome LoadingHome.Model Progression.Progression
    | LoadingItemCollection LoadingItemCollection.Model Progression.Progression


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
            setRoute (Routing.fromLocation location) model

        ( LoadingHomeMsg subMsg, Transitioning oldPage (LoadingHome subModel _) ) ->
            processLoadingHome oldPage (LoadingHome.update subMsg subModel)
                |> updatePageState model

        ( LoadingItemCollectionMsg subMsg, Transitioning oldPage (LoadingItemCollection subModel _) ) ->
            processLoadingItemCollection oldPage (LoadingItemCollection.update subMsg subModel)
                |> updatePageState model

        ( _, _ ) ->
            ( model, Cmd.none )


setRoute : Maybe Routing.Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    let
        oldPage =
            PageLoader.visualPage model.pageState
    in
        case maybeRoute of
            Nothing ->
                { model | pageState = Loaded NotFoundPage } ! []

            Just Routing.Home ->
                processLoadingHome oldPage LoadingHome.init
                    |> updatePageState model

            Just (Routing.ItemCollection slug page) ->
                processLoadingItemCollection oldPage (LoadingItemCollection.init slug page)
                    |> updatePageState model

            Just Routing.AllItemCollections ->
                model ! []

            Just Routing.UserAgreement ->
                { model | pageState = Loaded UserAgreementPage } ! []


processLoadingHome : Page -> TransitionStatus LoadingHome.Model LoadingHome.Msg Home.Model -> ( PageState Page Loading, Cmd Msg )
processLoadingHome =
    PageLoader.defaultProcessLoading ErrorPage LoadingHome LoadingHomeMsg HomePage Home.init (\_ -> NoOp)


processLoadingItemCollection : Page -> TransitionStatus LoadingItemCollection.Model LoadingItemCollection.Msg ItemCollection.Model -> ( PageState Page Loading, Cmd Msg )
processLoadingItemCollection =
    PageLoader.defaultProcessLoading ErrorPage LoadingItemCollection LoadingItemCollectionMsg ItemCollectionPage ItemCollection.init (\_ -> NoOp)


updatePageState : Model -> ( PageState Page Loading, Cmd msg ) -> ( Model, Cmd msg )
updatePageState model ( pageState, cmd ) =
    ( { model | pageState = pageState }, cmd )


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

        ErrorPage model ->
            Error.view model

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
