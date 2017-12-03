module Routing exposing (Route(..), fromLocation)

import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = Home
    | UserAgreement
    | AllItemCollections
    | ItemCollection String


fromLocation : Location -> Maybe Route
fromLocation =
    parseHash matchers


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map Home top
        , map UserAgreement (s "user-agreement")
        , map AllItemCollections (s "all-categories")
        , map ItemCollection (s "category" </> string)
        ]
