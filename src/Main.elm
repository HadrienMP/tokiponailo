module Main exposing (..)

import Browser
import Dictionary exposing (Language(..), Step(..), Word)
import Html exposing (Html, button, div, form, h1, h2, header, input, p, span, text)
import Html.Attributes exposing (autofocus, class, id, placeholder, type_, value)
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
    { step : Step
    , word : String
    , expected : String
    , actual : String
    , previousWord : String
    , previousActual : String
    , previousExpected: String
    , right : Maybe Bool
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { step = One
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
    | SelectedWord ( Maybe Word, List Word )
    | SelectedMeaning ( Maybe String, List String )


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
            , pickWord One
            )

        SelectedWord ( Just word, _ ) ->
            ( { model | expected = word.tokiPona }
            , ValueList.get French word.meanings
                |> Maybe.map (\meaning -> Random.List.choose meaning |> Random.generate SelectedMeaning)
                |> Maybe.withDefault Cmd.none
            )

        SelectedMeaning ( Just meaning, _ ) ->
            ( { model | word = meaning }, Cmd.none )

        _ ->
            ( model, Cmd.none )


pickWord step =
    ValueList.get step Dictionary.all
        |> Maybe.map (\words -> Random.List.choose words |> Random.generate SelectedWord)
        |> Maybe.withDefault Cmd.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ id "main" ]
        [ header
            []
            [ h1 [] [ text "Toki Pona" ]
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
        ]


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
    |> Maybe.map (\(h, t) -> String.cons h t)
    |> Maybe.withDefault word

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
