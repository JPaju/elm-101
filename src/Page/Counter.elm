module Page.Counter exposing (Model, Msg, init, update, view)

import Element exposing (alignTop, centerX, centerY, column, el, fill, height, row, spacing, text)
import Element.Font as Font
import Layout
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


view : Model -> Layout.PageInfo Msg
view model =
    { title = "Count: " ++ String.fromInt model.count
    , content =
        column [ spacing 10, centerX, centerY, height fill ]
            [ Ui.pageHeader [ alignTop, centerX ] "Counter"
            , row [ centerX, centerY ] [ el [ Font.size 50 ] <| text (String.fromInt model.count) ]
            , row [ centerX, centerY, spacing 10 ]
                [ primaryButton [] { label = "-", enabled = True, onClick = Decrement }
                , primaryButton [] { label = "Reset", enabled = True, onClick = Reset }
                , primaryButton [] { label = "+", enabled = True, onClick = Increment }
                ]
            ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }, Cmd.none )

        Decrement ->
            ( { model | count = model.count - 1 }, Cmd.none )

        Reset ->
            ( { model | count = 0 }, Cmd.none )
