module WeightedWords exposing (..)

import Day
import Dictionary exposing (Language(..), Word)
import Random
import Random.List
import ValueList


type alias WeightedWord =
    ( Int, Word )


weigh : List Word -> List WeightedWord
weigh words =
    let
        max : Int
        max =
            words
                |> List.reverse
                |> List.head
                |> Maybe.map .day
                |> Maybe.map Day.toInt
                |> Maybe.withDefault 0
    in
    words
    |> List.map (\word -> (toOdd (Day.toInt word.day) max, word ))

toOdd : Int -> Int -> Int
toOdd number max =
    if number == max then
        6
    else if number == max - 1 then
        3
    else
        1





-- PICK


pick : List WeightedWord -> Day.Day -> Random.Generator (Maybe Word)
pick words day =
    Debug.log (Debug.toString day) words
        |> List.filter (\(_, word) -> word.day == day)
        |> List.map (\it -> Tuple.mapFirst toFloat it)
        |> (\it -> ( List.head it, List.tail it ))
        |> (\it ->
                case it of
                    ( Just head, Just tail ) ->
                        Random.weighted head tail
                            |> Random.map Just

                    ( _, _ ) ->
                        Random.constant Nothing
           )


pickMeaning : Word -> Random.Generator (Maybe String)
pickMeaning word =
    ValueList.get French word.meanings
        |> Maybe.withDefault []
        |> Random.List.choose
        |> Random.map Tuple.first



-- UPDATE


update : Word -> (Int -> Int) -> List ( Int, Word ) -> List ( Int, Word )
update word oddUpdate weighed =
    weighed
        |> List.map
            (\( odd, w ) ->
                if word.tokiPona == w.tokiPona then
                    ( max 0 <| oddUpdate odd, w )
                else
                    ( odd, w )
            )
        |> List.filter (\(weight, _) -> weight /= 0)