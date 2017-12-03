module Module.Paginator.Paginator exposing (Config, Page, paginator)


type alias Config =
    { currentPage : Int
    , totalPages : Int
    , pagesAroundCurrent : Int
    , linkStrategy : Int -> String
    }


type alias Page =
    { content : String
    , link : String
    , isCurrent : Bool
    }


paginator : Config -> List Page
paginator rawConfig =
    doPaginator (validate rawConfig)


doPaginator : Config -> List Page
doPaginator config =
    let
        from =
            max 1 (config.currentPage - config.pagesAroundCurrent)

        to =
            min config.totalPages (config.currentPage + config.pagesAroundCurrent)

        pages =
            List.map (createPage config) (List.range from to)
    in
        pages


createPage : Config -> Int -> Page
createPage config number =
    { content = toString number
    , link = config.linkStrategy number
    , isCurrent = config.currentPage == number
    }


validate : Config -> Config
validate config =
    { config
        | pagesAroundCurrent = max 1 config.pagesAroundCurrent
    }
