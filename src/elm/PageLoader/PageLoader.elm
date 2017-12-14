module PageLoader.PageLoader exposing (TransitionStatus(..))

import PageLoader.DependencyStatus.DependencyStatus as DependencyStatus


type TransitionStatus model msg data
    = Pending ( model, Cmd msg ) DependencyStatus.Progression
    | Success data
    | Failed String
