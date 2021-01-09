module Main exposing (..)

import Browser
import Day exposing (Day(..), toString)
import Dictionary exposing (Language(..), Word)
import Html exposing (Html, button, div, form, h1, h2, header, img, input, option, p, span, text)
import Html.Attributes exposing (autofocus, classList, id, placeholder, src, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Question exposing (WeighedWord)
import Random exposing (Generator)
import Random.List
import ValueList



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
    , word : String
    , expected : String
    , actual : String
    , previousWord : String
    , previousActual : String
    , previousExpected : String
    , right : Maybe Bool
    , words : List WeighedWord
    }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        model =
            { day = One
            , word = "big"
            , expected = "suli"
            , actual = ""
            , previousWord = ""
            , previousActual = ""
            , previousExpected = ""
            , right = Nothing
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
    | TokiPonaChanged String
    | SelectedQuestion (Maybe ( Word, String ))
    | SelectDay (Maybe Day)
    | NextQuestion


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TokiPonaChanged tokiPona ->
            ( { model | actual = tokiPona }, Cmd.none )

        Check ->
            ( { model
                | actual = ""
                , right = Just <| model.actual == model.expected
                , previousActual = model.actual
                , previousExpected = model.expected
                , previousWord = model.word
                , words = Question.answer .tokiPona model.expected model.actual model.words
              }
            , pickWord model.words
            )

        SelectDay (Just day) ->
            ( { model | day = day }, pickWord model.words )

        SelectedQuestion (Just ( word, meaning )) ->
            ( { model | word = meaning, expected = word.tokiPona }, Cmd.none )

        NextQuestion ->
            ( { model | right = Nothing }, Cmd.none )

        _ ->
            ( model, Cmd.none )


pickWord2 : List WeighedWord -> Generator (Maybe Word)
pickWord2 words =
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


pickWord words =
    pickWord2 words
        |> Random.andThen pickMeaning
        |> Random.generate SelectedQuestion


pickWordFromDay : Day -> Random.Generator ( Maybe Word, List Word )
pickWordFromDay day =
    Dictionary.all
        |> List.filter (\it -> it.day == day)
        |> Random.List.choose


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
    if model.right /= Just False then
        [ p [ id "toTranslate" ]
            [ text "Traduisez "
            , span [ id "to-translate" ] [ text model.word ]
            ]
        , form
            [ onSubmit Check ]
            [ input
                [ type_ "text"
                , placeholder "toki pona"
                , onInput TokiPonaChanged
                , value model.actual
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
            , classList [ ( "empty", model.right == Nothing ) ]
            , onClick NextQuestion
            ]
            [ p [ id "toTranslate" ]
                [ text "Traduisez "
                , span [ id "to-translate" ] [ text model.previousWord ]
                ]
            , p [id "wrong"] [ text <| model.previousActual ]
            , p [id "right"] [ text <| model.previousExpected ]
            , button [] [ text "Question suivante" ]
            ]
        ]


dayOption : Day -> Html Msg
dayOption day =
    option [ value <| toString day ] [ text <| toString day ]


message : Model -> String
message model =
    case model.right of
        Nothing ->
            ""

        Just True ->
            "Exact !"

        _ ->
            model.previousActual ++ " -> Oups. " ++ capitalize model.previousWord ++ " se dit " ++ model.previousExpected


capitalize : String -> String
capitalize word =
    String.uncons word
        |> Maybe.map (Tuple.mapFirst Char.toUpper)
        |> Maybe.map (\( h, t ) -> String.cons h t)
        |> Maybe.withDefault word



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
