module WeightedWords exposing (..)

import Day
import Dictionary exposing (Language(..), Word)
import Question exposing (Question)
import Random
import Random.List
import ValueList


type alias WeighedWord =
    ( Int, Word )


weigh : List Word -> List WeighedWord
weigh words =
    List.map (\word -> ( 1 * Day.toInt word.day, word )) words



-- PICK


pickWord : List WeighedWord -> Random.Generator (Maybe ( Word, String ))
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


duo : Word -> ( Maybe String, List String ) -> Maybe ( Word, String )
duo word ( mMeaning, _ ) =
    case mMeaning of
        Just meaning ->
            Just ( word, meaning )

        Nothing ->
            Nothing



-- UPDATE


update : Question -> List ( Int, Word ) -> List ( Int, Word )
update question weighed =
    weighed
        |> List.map
            (\( odd, word ) ->
                if question.answerProp word == question.actual then
                    ( newOdd (question.answerProp word) question.actual odd, word )

                else
                    ( odd, word )
            )


newOdd : a -> a -> (Int -> Int)
newOdd expected actual =
    if expected == actual then
        \x -> x - 1

    else
        (+) 2
