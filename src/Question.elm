module Question exposing (..)

import Day exposing (Day)
import Dictionary exposing (Language(..), Word)
import Random exposing (Generator)
import Random.List
import ValueList


type alias Question =
    { questionProp : Word -> String
    , answerProp : Word -> String
    , word : Word
    , actual : String
    }


type alias AnswerProp =
    Word -> String


type alias WeighedWord =
    ( Int, Word )


wasRight : Question -> Bool
wasRight question =
    (question.answerProp question.word) == question.actual


updateActual : String -> Question -> Question
updateActual actual question =
    { question | actual = actual }


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


weigh : List Word -> List WeighedWord
weigh words =
    List.map (\word -> ( 1 * Day.toInt word.day, word )) words


answer : Question -> List ( Int, Word ) -> List ( Int, Word )
answer question weighed =
    weighed
        |> List.map
            (\( odd, word ) ->
                if question.answerProp word == question.actual then
                    ( (newOdd (question.answerProp word) question.actual) odd, word )

                else
                    ( odd, word )
            )


newOdd : a -> a -> (Int -> Int)
newOdd expected actual =
    if expected == actual then
        \x -> x - 1

    else
        (+) 2
