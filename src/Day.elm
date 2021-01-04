module Day exposing (..)

import Random
type Day
    = One
    | Two
    | Three

fromString : String -> Maybe Day
fromString string =
    case string of
        "One" -> Just One
        "Two" -> Just Two
        "Three" -> Just Three
        _ -> Nothing

all = [One, Two, Three]


randomize : Day -> Random.Generator Day
randomize day =
    case day of
        One ->
            Random.constant One

        Two ->
            Random.weighted ( 80, Two ) [ ( 20, One ) ]

        Three ->
            Random.weighted ( 70, Three ) [ ( 20, Two ), (10, One) ]