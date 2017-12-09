module Request.Helpers exposing (apiUrl)


apiUrl : String -> String
apiUrl =
    (++) "http://localhost:8080/api"
