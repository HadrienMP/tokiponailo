module Main exposing (..)

import Browser
import Day exposing (Day(..))
import Dictionary exposing (Language(..), Word)
import Html exposing (Html, button, div, form, h1, h2, header, img, input, p, span, text)
import Html.Attributes exposing (autofocus, id, placeholder, src, type_, value)
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
    case model.previousQuestion of
        Just previousQuestion ->
            if Question.wasRight previousQuestion then
                questionHtml model

            else
                errorHtml previousQuestion

        Nothing ->
            questionHtml model


questionHtml model =
    case model.question of
        Just question ->
            [ p [ id "toTranslate" ]
                [ text "Traduisez "
                , span
                    [ id "to-translate" ]
                    [ question |> (\q -> q.questionProp q.word) |> text ]
                ]
            , form
                [ onSubmit Check ]
                [ input
                    [ type_ "text"
                    , placeholder "toki pona"
                    , onInput ActualChanged
                    , question |> (\q -> q.actual) |> value
                    , autofocus True
                    ]
                    []
                , button
                    [ type_ "submit" ]
                    [ text "Vérifier" ]
                ]
            ]

        Nothing ->
            [ p [] [ text "Loading" ] ]


errorHtml previousQuestion =
    [ div
        [ id "message", onClick NextQuestion ]
        [ p [ id "toTranslate" ]
            [ text "Traduisez "
            , span
                [ id "to-translate" ]
                [ previousQuestion |> (\q -> q.questionProp q.word) |> text ]
            ]
        , p [ id "wrong" ]
            [ previousQuestion |> (\q -> q.actual) |> text ]
        , p [ id "right" ]
            [ previousQuestion |> (\q -> q.answerProp q.word) |> text ]
        , button [] [ text "Question suivante" ]
        ]
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
