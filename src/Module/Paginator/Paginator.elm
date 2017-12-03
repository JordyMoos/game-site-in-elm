module Module.Paginator.Paginator exposing (Config, Page, paginator)


type alias Config =
    { currentPage : Int
    , totalPages : Int
    , pagesAroundActive : Int
    , linkStrategy : Int -> String
    }


type alias Page =
    { content : String
    , link : String
    , isActive : Bool
    }


paginator : Config -> List Page
paginator rawConfig =
    doPaginator (validate rawConfig)


doPaginator : Config -> List Page
doPaginator config =
    let
        from =
            max 1 (config.currentPage - config.pagesAroundActive)

        to =
            min config.totalPages (config.currentPage + config.pagesAroundActive)

        pages =
            List.map (createPage config) (List.range from to)
    in
        pages


createPage : Config -> Int -> Page
createPage config number =
    { content = toString number
    , link = config.linkStrategy number
    , isActive = False
    }


validate : Config -> Config
validate config =
    { config
        | pagesAroundActive = max 1 config.pagesAroundActive
    }
