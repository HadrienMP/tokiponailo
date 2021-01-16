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
    List.map (\word -> ( 1 * Day.toInt word.day, word )) words



-- PICK


pickWord : List WeightedWord -> Random.Generator (Maybe Word)
pickWord words =
    words
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
                    ( oddUpdate odd, w )

                else
                    ( odd, w )
            )
