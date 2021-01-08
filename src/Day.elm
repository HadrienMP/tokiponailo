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


dayLabels =
    [ ( One, "One" )
    , ( Two, "Two" )
    , ( Three, "Three" )
    , ( Four, "Four" )
    , ( Five, "Five" )
    , ( Six, "Six" )
    , ( Seven, "Seven" )
    ]


toString : Day -> String
toString day =
    List.filter (\( value, _ ) -> value == day) dayLabels
        |> List.head
        |> Maybe.map Tuple.second
        |> Maybe.withDefault ""


fromString : String -> Maybe Day
fromString string =
    List.filter (\( _, name ) -> name == string) dayLabels
        |> List.head
        |> Maybe.map Tuple.first


toInt day =
    case day of
        One ->
            1

        Two ->
            2

        Three ->
            3

        Four ->
            4

        Five ->
            5

        Six ->
            6

        Seven ->
            7
