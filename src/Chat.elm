module Chat exposing (..)

import Html exposing (img)
import Html.Attributes exposing (alt, class, src)


type Sender
    = Student
    | Teacher


type alias Board =
    List Message


type alias Message =
    { sender : Sender
    , content : String
    }


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
