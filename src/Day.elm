module Day exposing (..)

import Random
type Day
    = One
    | Two
    | Three
    | Four
    | Five
    | Six
    | Seven

fromString : String -> Maybe Day
fromString string =
    case string of
        "One" -> Just One
        "Two" -> Just Two
        "Three" -> Just Three
        "Four" -> Just Four
        "Five" -> Just Five
        "Six" -> Just Six
        "Seven" -> Just Seven
        _ -> Nothing

toInt day =
    case day of
        One -> 1
        Two -> 2
        Three -> 3
        Four -> 4
        Five -> 5
        Six -> 6
        Seven -> 7