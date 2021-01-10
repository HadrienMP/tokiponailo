module Main exposing (..)

import Browser
import Day exposing (Day(..))
import Dictionary exposing (Language(..), Word)
import Html exposing (Html, button, div, form, h1, h2, header, img, input, p, span, text)
import Html.Attributes exposing (autofocus, classList, id, placeholder, src, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Question exposing (Question, WeighedWord)
import Random exposing (Generator)



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { day : Day
    , question : Maybe Question
    , previousQuestion : Maybe Question
    , words : List WeighedWord
    }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        model =
            { day = One
            , question = Nothing
            , previousQuestion = Nothing
            , words =
                Dictionary.all
                    |> Question.weigh
            }
    in
    ( model
    , pickWord model.words
    )



-- UPDATE


type Msg
    = Check
    | ActualChanged String
    | SelectedQuestion (Maybe ( Word, String ))
    | SelectDay (Maybe Day)
    | NextQuestion


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.question ) of
        ( ActualChanged tokiPona, Just question ) ->
            ( { model | question = Just <| Question.updateActual tokiPona question }, Cmd.none )

        ( Check, Just question ) ->
            ( { model
                | question = Nothing
                , previousQuestion = model.question
                , words = Question.answer question model.words
              }
            , pickWord model.words
            )

        ( SelectDay (Just day), _ ) ->
            ( { model | day = day }, pickWord model.words )

        ( SelectedQuestion (Just ( word, meaning )), _ ) ->
            ( { model | question = Just <| Question (\_ -> meaning) .tokiPona word "" }, Cmd.none )

        ( NextQuestion, _ ) ->
            ( { model | previousQuestion = Nothing }, Cmd.none )

        _ ->
            ( model, Cmd.none )


pickWord words =
    Question.pickWord words |> Random.generate SelectedQuestion



-- VIEW


view : Model -> Html Msg
view model =
    div [ id "under" ]
        [ header
            []
            [ img [ src "logo2.png" ] []
            , div [ id "title" ]
                [ h1 [] [ text "Toki Pona" ]
                , h2 [] [ text "12 jours, vocabulaire" ]
                ]
            ]
        , div [ id "main" ] (mainHtml model)
        ]


mainHtml : Model -> List (Html Msg)
mainHtml model =
    if Maybe.map (\q -> Question.wasRight q) model.previousQuestion /= Just False then
        [ p [ id "toTranslate" ]
            [ text "Traduisez "
            , span
                [ id "to-translate" ]
                [ model.question |> Maybe.map (\q -> q.questionProp q.word) |> Maybe.withDefault "Wut no question ?" |> text ]
            ]
        , form
            [ onSubmit Check ]
            [ input
                [ type_ "text"
                , placeholder "toki pona"
                , onInput ActualChanged
                , model.question |> Maybe.map (\q -> q.actual) |> Maybe.withDefault "" |> value
                , autofocus True
                ]
                []
            , button
                [ type_ "submit" ]
                [ text "Vérifier" ]
            ]
        ]

    else
        [ div
            [ id "message"
            , classList [ ( "empty", model.previousQuestion == Nothing ) ]
            , onClick NextQuestion
            ]
            [ p [ id "toTranslate" ]
                [ text "Traduisez "
                , span
                    [ id "to-translate" ]
                    [ model.previousQuestion
                        |> Maybe.map (\q -> q.questionProp q.word)
                        |> Maybe.withDefault "Wut no question ?"
                        |> text
                    ]
                ]
            , p [ id "wrong" ]
                [ model.previousQuestion
                    |> Maybe.map (\q -> q.actual)
                    |> Maybe.withDefault "Wut no actual ?"
                    |> text
                ]
            , p [ id "right" ]
                [ model.previousQuestion
                    |> Maybe.map (\q -> q.answerProp q.word)
                    |> Maybe.withDefault "Wut no expected ?"
                    |> text
                ]
            , button [] [ text "Question suivante" ]
            ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
