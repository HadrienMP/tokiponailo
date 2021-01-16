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
