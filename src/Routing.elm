module Routing exposing (Route(..), fromLocation)

import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = Home
    | AllItemCollections
    | UserAgreement


fromLocation : Location -> Maybe Route
fromLocation =
    parseHash matchers


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map Home top
        , map AllItemCollections (s "all-categories")
        , map UserAgreement (s "user-agreement")
        ]
