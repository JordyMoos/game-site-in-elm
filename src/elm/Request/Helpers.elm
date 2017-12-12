module Request.Helpers exposing (apiUrl)


apiUrl : String -> String
apiUrl =
    (++) "http://127.0.0.1:8888/api"
