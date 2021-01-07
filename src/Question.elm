module Question exposing (..)

import Dictionary exposing (Word)


type alias Question =
    Word -> String

type alias WeighedWord = (Int, Word)

weigh : List Word -> List WeighedWord
weigh words =
    List.map (\word -> ( 5, word )) words


answer : Question -> String -> String -> List ( Int, Word ) -> List ( Int, Word )
answer question expected actual weighed =
    List.map
        (\( odd, word ) ->
            if question word == expected then
                ( newOdd expected actual odd, word )

            else
                ( odd, word )
        )
        weighed


newOdd : a -> a -> (Int -> Int)
newOdd expected actual =
    if expected == actual then
        \x -> x - 1

    else
        (+) 2
