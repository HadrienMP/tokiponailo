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


pickWord : List WeightedWord -> Random.Generator (Maybe ( Word, String ))
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
        |> Random.andThen pickMeaning

pickWord2 : List WeightedWord -> Random.Generator (Maybe Word)
pickWord2 words =
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


pickMeaning : Maybe Word -> Random.Generator (Maybe ( Word, String ))
pickMeaning mWord =
    case mWord of
        Just word ->
            ValueList.get French word.meanings
                |> Maybe.withDefault []
                |> Random.List.choose
                |> Random.map (\chosenMeaning -> duo word chosenMeaning)

        Nothing ->
            Random.constant Nothing

pickMeaning2 : Word -> Random.Generator (Maybe String)
pickMeaning2 word =
    ValueList.get French word.meanings
        |> Maybe.withDefault []
        |> Random.List.choose
        |> Random.map Tuple.first


duo : Word -> ( Maybe String, List String ) -> Maybe ( Word, String )
duo word ( mMeaning, _ ) =
    case mMeaning of
        Just meaning ->
            Just ( word, meaning )

        Nothing ->
            Nothing



-- UPDATE


update : Word -> (Int -> Int) -> List ( Int, Word ) -> List ( Int, Word )
update word oddUpdate weighed =
    weighed
        |> List.map
            (\( odd, w ) ->
                if word.tokiPona == w.tokiPona then
                    ( oddUpdate odd, word )

                else
                    ( odd, word )
            )

