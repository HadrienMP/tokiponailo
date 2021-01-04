module Main exposing (..)

import Browser
import Day exposing (Day(..))
import Debug exposing (toString)
import Dictionary exposing (Language(..), Word)
import Html exposing (Html, button, div, form, h1, h2, header, input, label, option, p, select, span, text)
import Html.Attributes exposing (autofocus, for, id, placeholder, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Random
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
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { day = One
      , word = "big"
      , expected = "suli"
      , actual = ""
      , previousWord = ""
      , previousActual = ""
      , previousExpected = ""
      , right = Nothing
      }
    , pickWord One
    )



-- UPDATE


type Msg
    = Check
    | TokiPonaChanged String
    | SelectedQuestion (Maybe ( Word, String ))
    | SelectDay (Maybe Day)


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
              }
            , pickWord model.day
            )

        SelectDay (Just day) ->
            ( { model | day = day }, pickWord day )

        SelectedQuestion (Just ( word, meaning )) ->
            ( { model | word = meaning, expected = word.tokiPona }, Cmd.none )

        _ ->
            ( model, Cmd.none )


pickWord day =
    Day.randomize day
        |> Random.andThen pickWordFromDay
        |> Random.andThen pickMeaning
        |> Random.generate SelectedQuestion


pickWordFromDay : Day -> Random.Generator ( Maybe Word, List Word )
pickWordFromDay day =
    ValueList.get day Dictionary.all
        |> Maybe.withDefault []
        |> Random.List.choose


pickMeaning : ( Maybe Word, List Word ) -> Random.Generator (Maybe ( Word, String ))
pickMeaning ( mWord, _ ) =
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
        [ div [ id "main" ]
            [ header
                []
                [ h1 [] [ text "Toki Pona" ]
                , h2 [] [ text "12 days, vocabulary"]
                ]
            , p [ id "haha" ]
                [ text "Traduisez "
                , span [ id "to-translate" ] [ text model.word ]
                , text " en toki pona"
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
            , p [] [ text <| message model ]
            , form
                []
                [ label [ for "day" ] [ text "Day" ]
                , select
                    [ id "day", placeholder "Day", onInput (\dayStr -> Day.fromString dayStr |> SelectDay) ]
                    (List.map dayOption Day.all)
                ]
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
