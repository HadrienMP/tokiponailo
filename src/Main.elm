module Main exposing (..)

import Browser
import Day exposing (Day(..))
import Dictionary exposing (Language(..), Word)
import Html exposing (Html, button, div, form, h1, h2, header, img, input, p, span, text)
import Html.Attributes exposing (autofocus, id, placeholder, src, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Question2
import Random exposing (Generator)
import WeightedWords exposing (WeightedWord)



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
    , question : Maybe Question2.Question
    , previousQuestion : Maybe Question2.Question
    , actual: String
    , previousActual: String
    , words : List WeightedWord
    }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        model =
            { day = One
            , question = Nothing
            , previousQuestion = Nothing
            , actual = ""
            , previousActual = ""
            , words =
                Dictionary.all
                    |> WeightedWords.weigh
            }
    in
    ( model
    , pickQuestion model.words
    )



-- UPDATE


type Msg
    = Check
    | ActualChanged String
    | SelectedQuestion (Maybe Question2.Question)
    | SelectDay (Maybe Day)
    | NextQuestion


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.question ) of
        ( ActualChanged actual, _ ) ->
            ( { model | actual = actual }, Cmd.none )

        ( Check, Just question ) ->
            let
                updater = if Question2.isRight model.actual question then (\it -> it - 1) else (+) 2
                updatedWords = WeightedWords.update question.word updater model.words
            in
            ( { model
                | question = Nothing
                , previousQuestion = model.question
                , actual = ""
                , previousActual = model.actual
                , words = updatedWords
              }
            , pickQuestion model.words
            )

        ( SelectDay (Just day), _ ) ->
            ( { model | day = day }, pickQuestion model.words )

        ( SelectedQuestion question, _ ) ->
            ( { model | question = question }, Cmd.none )

        ( NextQuestion, _ ) ->
            ( { model | previousQuestion = Nothing }, Cmd.none )

        _ ->
            ( model, Cmd.none )


pickQuestion words =
    WeightedWords.pickWord2 words
    |> Random.andThen jojo
    |> Random.generate SelectedQuestion

jojo mWord =
    case mWord of
        Just word ->
            Question2.pickQuestion word
        Nothing ->
            Random.constant Nothing

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
            if Question2.isRight model.previousActual previousQuestion then
                questionHtml model

            else
                errorHtml model

        Nothing ->
            questionHtml model


questionHtml: Model -> List (Html Msg)
questionHtml model =
    case model.question of
        Just question ->
            [ p [ id "toTranslate" ]
                [ text "Traduisez "
                , span
                    [ id "to-translate" ]
                    [ question.toTranslate |> text ]
                ]
            , form
                [ onSubmit Check ]
                [ input
                    [ type_ "text"
                    , placeholder "toki pona"
                    , onInput ActualChanged
                    , model.actual |> value
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


errorHtml: Model -> List (Html Msg)
errorHtml model =
    [ div
        [ id "message", onClick NextQuestion ]
        [ p [ id "toTranslate" ]
            [ text "Traduisez "
            , span
                [ id "to-translate" ]
                [ model.previousQuestion |> Maybe.map .toTranslate |> Maybe.withDefault "No Question wut ???" |> text ]
            ]
        , p [ id "wrong" ]
            [ model.previousActual |> text ]
        , p [ id "right" ]
            [ model.previousQuestion |> Maybe.map Question2.expected |> Maybe.withDefault "No Question wut ???" |> text ]
        , button [] [ text "Question suivante" ]
        ]
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
