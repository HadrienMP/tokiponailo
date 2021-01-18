module Day exposing (..)

import Random
import Random.List as Random


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
    | Ten


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
    , DayMap Ten "Ten" 10
    ]

pick : Random.Generator Day
pick =
    Random.weighted (6, [Ten]) [(3, [Nine]), (1, [One, Two, Three, Four, Five, Six, Seven, Eight])]
    |> Random.andThen Random.choose
    |> Random.map Tuple.first
    |> Random.map (Maybe.withDefault Ten)


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
