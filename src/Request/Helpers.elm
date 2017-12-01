module Request.Helpers exposing (apiUrl)


apiUrl : String -> String
apiUrl =
    (++) "http://localhost:5000/api"
