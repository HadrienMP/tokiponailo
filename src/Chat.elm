module Chat exposing (..)

import Html exposing (Html, div, img, p, text)
import Html.Attributes exposing (alt, class, src)


type Msg
    = Nope


type Sender
    = Student
    | Teacher


type alias Board =
    List Message


type alias Message =
    Html Msg


stringToMessage : Sender -> String -> Message
stringToMessage sender content =
    toMessage sender [ text content ]

toMessage : Sender -> List (Html Msg) -> Message
toMessage sender content =
    div
        [ class <| toString sender ++ " message" ]
        [ icon sender
        , p [ class "content" ] content
        ]


append : Board -> Board -> Board
append a b =
    b ++ a |> preserveSize


preserveSize : Board -> Board
preserveSize board =
    let
        over =
            max 0 (List.length board - 20)
    in
    List.drop over board


icon sender =
    case sender of
        Student ->
            img [ class "icon", alt "student", src "img/icons/ghost-line.svg" ] []

        Teacher ->
            img [ class "icon", alt "teacher", src "img/icons/emotion-laugh-line.svg" ] []


toString sender =
    case sender of
        Student ->
            "Student"

        Teacher ->
            "Teacher"
