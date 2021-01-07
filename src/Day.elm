module Day exposing (..)

import Random
type Day
    = One
    | Two
    | Three
    | Four
    | Five
    | Six

fromString : String -> Maybe Day
fromString string =
    case string of
        "One" -> Just One
        "Two" -> Just Two
        "Three" -> Just Three
        "Four" -> Just Four
        "Five" -> Just Five
        "Six" -> Just Six
        _ -> Nothing

toInt day =
    case day of
        One -> 1
        Two -> 2
        Three -> 3
        Four -> 4
        Five -> 5
        Six -> 6

all = [One, Two, Three, Four, Five, Six]


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

        Five ->
            Random.weighted ( 70, Five ) [ ( 15, Four ), ( 5, Three ), ( 5, Two ), (5, One) ]

        Six ->
            Random.weighted ( 70, Six ) [ ( 10, Five ), (5, Four), ( 5, Three ), ( 5, Two ), (5, One) ]