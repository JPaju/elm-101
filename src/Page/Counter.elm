module Page.Counter exposing (Model, Msg, init, update, view)

import Counter exposing (Msg)
import Element exposing (Element, centerX, centerY, column, el, row, spacing, text)
import Element.Font as Font
import Ui exposing (primaryButton)


type alias Model =
    { count : Int
    , modifiedCount : Int
    }


type Msg
    = Increment
    | Decrement
    | Reset


init : Model
init =
    { count = 0
    , modifiedCount = 0
    }


view : (Msg -> msg) -> Model -> Element msg
view toMsg model =
    column [ spacing 10, centerX, centerY ]
        [ row [ centerX ] [ el [ Font.size 50 ] <| text (String.fromInt model.count) ]
        , row [ centerX, spacing 10 ]
            [ primaryButton [] "-" (Decrement |> toMsg)
            , primaryButton [] "Reset" (Reset |> toMsg)
            , primaryButton [] "+" (Increment |> toMsg)
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }, Cmd.none )

        Decrement ->
            ( { model | count = model.count - 1 }, Cmd.none )

        Reset ->
            ( { model | count = 0 }, Cmd.none )
