port module Main exposing (..)

import Browser
import Chat exposing (Board, Message)
import Day exposing (Day(..))
import Dictionary exposing (Language(..), Word)
import Html exposing (Html, button, div, form, img, input, p, strong, text)
import Html.Attributes exposing (autofocus, class, id, placeholder, src, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Question
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


port chatMessage : String -> Cmd msg



-- MODEL


type alias Model =
    { day : Day
    , question : Maybe Question.Question
    , previousQuestion : Maybe Question.Question
    , actual : String
    , previousActual : String
    , words : List WeightedWord
    , chatBoard : Chat.Board
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
            , chatBoard =
                [ Chat.stringToMessage Chat.Teacher "Salut salut !"
                , Chat.stringToMessage Chat.Teacher "C'est parti, travaillons ton toki pona."
                ]
            }
    in
    ( model
    , pickQuestion model.words
    )



-- UPDATE


type Msg
    = Check
    | ActualChanged String
    | SelectedQuestion (Maybe Question.Question)
    | SelectDay (Maybe Day)
    | NextQuestion
    | ChatMsg Chat.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.question ) of
        ( ActualChanged actual, _ ) ->
            ( { model | actual = actual }, Cmd.none )

        ( Check, Just question ) ->
            let
                isRight =
                    Question.isRight model.actual question

                updater =
                    if isRight then
                        \_ -> 0

                    else
                        (+) 2

                updatedWords =
                    WeightedWords.update question.word updater model.words

                newMessages =
                    [ Chat.stringToMessage Chat.Student model.actual
                    , Chat.stringToMessage Chat.Teacher
                        (if isRight then
                            "C'est bon !"

                         else
                            "Raté. C'était " ++ Question.expected question
                        )
                    ]
            in
            ( { model
                | question = Nothing
                , previousQuestion = model.question
                , actual = ""
                , previousActual = model.actual
                , words = updatedWords
                , chatBoard = Chat.append newMessages model.chatBoard
              }
            , Cmd.batch [ chatMessage "", pickQuestion model.words ]
            )

        ( SelectDay (Just day), _ ) ->
            ( { model | day = day }, pickQuestion model.words )

        ( SelectedQuestion (Just question), _ ) ->
            ( { model
                | question = Just question
                , chatBoard =
                    Chat.append
                        [ translateHtml question.toTranslate ]
                        model.chatBoard
              }
            , chatMessage ""
            )

        ( NextQuestion, _ ) ->
            ( { model | previousQuestion = Nothing }, Cmd.none )

        _ ->
            ( model, Cmd.none )

translateHtml : String -> Message
translateHtml toTranslate =
    Chat.toMessage
        Chat.Teacher
        [ text "Traduis \""
        , strong [] [ text toTranslate ]
        , text "\""
        ]

pickQuestion words =
    WeightedWords.pickWord words
        |> Random.andThen pickQuestionProperty
        |> Random.generate SelectedQuestion


pickQuestionProperty mWord =
    case mWord of
        Just word ->
            Question.pickQuestion word

        Nothing ->
            Random.constant Nothing



-- VIEW


view : Model -> Html Msg
view model =
    div [ id "under" ]
        [ div [ id "main" ]
            [ chatBoard model
            , messageBox model
            ]
        ]


chatBoard : Model -> Html Msg
chatBoard model =
    div [ id "chat-board" ] model.chatBoard
        |> Html.map ChatMsg


messageBox model =
    form
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
            [ img [ src "img/icons/send-plane-2-fill.svg" ] [] ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
