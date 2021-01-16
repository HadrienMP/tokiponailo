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
    | Eight
    | Nine


type alias DayMap =
    { day : Day
    , label : String
    , value : Int
    }


dayLabels : List DayMap
dayLabels =
    [ DayMap One "One" 1
    , DayMap Two "Two" 2
    , DayMap Three "Three" 3
    , DayMap Four "Four" 4
    , DayMap Five "Five" 5
    , DayMap Six "Six" 6
    , DayMap Seven "Seven" 7
    , DayMap Eight "Eight" 8
    , DayMap Nine "Nine" 9
    ]


toString : Day -> String
toString day =
    dayLabels
        |> List.filter (\it -> it.day == day)
        |> List.head
        |> Maybe.map .label
        |> Maybe.withDefault ""


fromString : String -> Maybe Day
fromString string =
    dayLabels
        |> List.filter (\it -> it.label == string)
        |> List.head
        |> Maybe.map .day


toInt : Day -> Int
toInt day =
    dayLabels
        |> List.filter (\it -> it.day == day)
        |> List.head
        |> Maybe.map .value
        |> Maybe.withDefault 0
