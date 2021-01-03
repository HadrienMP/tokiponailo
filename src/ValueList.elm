module ValueList exposing (..)

get : k -> List (k, v) -> Maybe v
get key list = List.filter (\( k, _ ) -> k == key) list |> List.head |> Maybe.map Tuple.second