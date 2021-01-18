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
    | Eleven


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
    , DayMap Eleven "Eleven" 11
    ]


pick : List Day -> Random.Generator Day
pick days =
    let
        reversed = List.reverse days
        stuff : List (Maybe (List Day))
        stuff =
            [ List.head reversed |> Maybe.map (\a -> [a])
            , List.tail reversed |> Maybe.andThen List.head |> Maybe.map (\a -> [a])
            , List.tail reversed |> Maybe.andThen List.tail
            ]
    in
    stuff
        |> toto
        |> Maybe.map (\a -> Random.weighted (Tuple.first a) (Tuple.second a))
        |> Maybe.map (Random.andThen Random.choose)
        |> Maybe.map (Random.map Tuple.first)
        |> Maybe.map (Random.map (Maybe.withDefault Ten))
        |> Maybe.withDefault (Random.constant Ten)

toto : List (Maybe (List Day)) -> Maybe ((Float, List Day), List (Float, List Day))
toto jojo =
    case jojo of
        [Just first, Just second, Just others] ->
            Just ((6, first), [(3, second), (1, others)])
        [Just first, Just second, Nothing] ->
            Just ((2, first), [(1, second)])
        [Just first, Nothing, Nothing] ->
            Just ((1, first), [])
        _ -> Nothing

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
