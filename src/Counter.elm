module Counter exposing (..)

import Html exposing (Html, br, button, section, span, text)
import Html.Events exposing (onClick)


type Model
    = Count Int


init : Model
init =
    Count 0


type Msg
    = IncrementCounter
    | DecrementCounter
    | ResetCounter


update : Msg -> Model -> Model
update msg (Count count) =
    case msg of
        IncrementCounter ->
            Count (count + 1)

        DecrementCounter ->
            Count (count - 1)

        ResetCounter ->
            Count 0


view : Model -> Html Msg
view (Count count) =
    section []
        [ button [ onClick DecrementCounter ] [ text "Decrement" ]
        , span [] [ text (String.fromInt count) ]
        , button [ onClick IncrementCounter ] [ text "Increment" ]
        , br [] []
        , button [ onClick ResetCounter ] [ text "Reset" ]
        ]
