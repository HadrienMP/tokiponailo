module Question2 exposing (..)

import Dictionary exposing (Language(..), Word)
import Random
import ValueList
import WeightedWords


type alias Question =
    { word: Word
    , type_: Type
    , toTranslate: String
    }

type alias Answer = String


type Type
    = TokTokiPona
    | FromTokiPona

pickQuestion: Word -> Random.Generator (Maybe Question)
pickQuestion word =
    pickQuestionType
    |> Random.andThen (toQuestion word)

toQuestion word type_=
    pickToTranslate word type_
    |> Random.map (Maybe.map (Question word type_))

pickToTranslate: Word -> Type -> Random.Generator (Maybe String)
pickToTranslate word type_ =
    case type_ of
        TokTokiPona ->
            WeightedWords.pickMeaning2 word
        FromTokiPona ->
            Random.constant <| Just <| word.tokiPona


pickQuestionType: Random.Generator Type
pickQuestionType = Random.uniform TokTokiPona [FromTokiPona]

isRight: Answer -> Question -> Bool
isRight answer question =
    case question.type_ of
        TokTokiPona ->
            answer == question.word.tokiPona
        FromTokiPona ->
            String.split "," answer
            |> List.map String.trim
            |> List.map (\answerWord -> hasMeaning answerWord question.word)
            |> List.foldr (&&) True

expected: Question -> String
expected question =
    case question.type_ of
        TokTokiPona ->
            question.word.tokiPona
        FromTokiPona ->
            question.word.meanings
            |> ValueList.get French
            |> Maybe.withDefault []
            |> List.foldr (\a b -> a ++ ", " ++ b) ""

hasMeaning: String -> Word -> Bool
hasMeaning meaning word =
    ValueList.get French word.meanings
    |> Maybe.map (\meanings -> List.member meaning meanings)
    |> Maybe.withDefault False