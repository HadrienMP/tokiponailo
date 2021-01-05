module Day exposing (..)

import Random
type Day
    = One
    | Two
    | Three
    | Four

fromString : String -> Maybe Day
fromString string =
    case string of
        "One" -> Just One
        "Two" -> Just Two
        "Three" -> Just Three
        "Four" -> Just Four
        _ -> Nothing

all = [One, Two, Three, Four]


randomize : Day -> Random.Generator Day
randomize day =
    case day of
        One ->
            Random.constant One

        Two ->
            Random.weighted ( 80, Two ) [ ( 20, One ) ]

        Three ->
            Random.weighted ( 70, Three ) [ ( 20, Two ), (10, One) ]

        Four ->
            Random.weighted ( 70, Four ) [ ( 20, Three ), ( 5, Two ), (5, One) ]