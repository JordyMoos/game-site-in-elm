module Request.Helpers exposing (apiUrl)


apiUrl : String -> String
apiUrl =
    (++) "http://localhost:8888/api"
