module Day exposing (..)

type Day
    = One
    | Two

fromString : String -> Maybe Day
fromString string =
    case string of
        "One" -> Just One
        "Two" -> Just Two
        _ -> Nothing
