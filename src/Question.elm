module Question exposing (..)

import Dictionary exposing (Language(..), Word)

type alias Question =
    { questionProp : Word -> String
    , answerProp : Word -> String
    , word : Word
    , actual : String
    }


type alias QuestionProp =
    Word -> String
type alias AnswerProp =
    Word -> String

wasRight : Question -> Bool
wasRight question =
    (question.answerProp question.word) == question.actual


updateActual : String -> Question -> Question
updateActual actual question =
    { question | actual = actual }
