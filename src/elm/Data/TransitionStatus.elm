module Data.TransitionStatus exposing (..)


type alias Progression =
    { total : Int
    , finished : Int
    }


type TransitionStatus model msg data
    = Pending ( model, Cmd msg ) Progression
    | Success data
    | Failed String
