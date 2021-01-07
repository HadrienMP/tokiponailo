module QuestionSpec exposing (..)

import Day
import Dictionary exposing (Language(..), Word)
import Expect
import Question exposing (answer, weigh)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Spec"
        [ describe "Weighing"
            [ test "words of the same day have an equal probability to be picked at the start" <|
                \_ ->
                    Expect.equal
                        [ ( 5, aWord "mi" ), ( 5, aWord "sina" ), ( 5, aWord "lipu" ) ]
                        (weigh [ aWord "mi", aWord "sina", aWord "lipu" ])
            ]
        , describe "Question"
            [ describe "Right answer"
                [ test "probability sinks after a right answer" <|
                    \_ ->
                        let
                            weighted =
                                answer .tokiPona "mi" "mi" (weigh [ aWord "mi", aWord "sina" ])
                        in
                        Expect.equal
                            [ ( 4, aWord "mi" ), ( 5, aWord "sina" ) ]
                            weighted
                , test "probability sinks after a right answer 2" <|
                    \_ ->
                        let
                            weighted =
                                answer .tokiPona "mi" "mi" (weigh [ aWord "mi", aWord "sina" ])
                                    |> answer .tokiPona "mi" "mi"
                        in
                        Expect.equal
                            [ ( 3, aWord "mi" ), ( 5, aWord "sina" ) ]
                            weighted
                ]
            , describe "Wrong answer"
                [ test "probability rises after a wrong answer" <|
                    \_ ->
                        let
                            weighted =
                                answer .tokiPona "mi" "ma" (weigh [ aWord "mi", aWord "sina" ])
                        in
                        Expect.equal
                            [ ( 7, aWord "mi" ), ( 5, aWord "sina" ) ]
                            weighted
                ]
            ]
        ]


aWord toki =
    aWord2 toki toki Day.One


aWord2 toki french day =
    { tokiPona = toki
    , meanings = [ ( French, [ french ] ) ]
    , day = day
    }
