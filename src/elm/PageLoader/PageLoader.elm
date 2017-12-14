module PageLoader.PageLoader
    exposing
        ( PageState(..)
        , TransitionStatus(..)
        , visualPage
        , defaultTransitionHandler
        , defaultListTransitionHandler
        )

import PageLoader.DependencyStatus.DependencyStatus as DependencyStatus


type PageState page loader
    = Loaded page
    | Transitioning page loader


visualPage : PageState page loader -> page
visualPage pageState =
    case pageState of
        Loaded page ->
            page

        Transitioning page _ ->
            page


type TransitionStatus model msg data
    = Pending ( model, Cmd msg ) DependencyStatus.Progression
    | Success data
    | Failed String


defaultListTransitionHandler :
    ( model, Cmd msg )
    -> List DependencyStatus.Status
    -> (() -> successData)
    -> TransitionStatus model msg successData
defaultListTransitionHandler ( model, cmd ) dependencyStatuses onSuccessCallback =
    defaultTransitionHandler
        ( model, cmd )
        (DependencyStatus.combine dependencyStatuses)
        onSuccessCallback


defaultTransitionHandler :
    ( model, Cmd msg )
    -> DependencyStatus.Status
    -> (() -> successData)
    -> TransitionStatus model msg successData
defaultTransitionHandler ( model, cmd ) dependencyStatus onSuccessCallback =
    case dependencyStatus of
        DependencyStatus.Failed ->
            Failed "Some requests failed"

        DependencyStatus.Pending progression ->
            Pending ( model, cmd ) progression

        DependencyStatus.Success ->
            Success (onSuccessCallback ())
