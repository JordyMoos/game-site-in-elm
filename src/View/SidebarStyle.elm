module View.SidebarStyle exposing (Styles(..), styles)

import Style exposing (..)


type Styles
    = None


styles : List (Style Styles variation)
styles =
    [ style None [] ]
