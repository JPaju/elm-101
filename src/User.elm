module User exposing (Model, Msg, init, update, view)

import Html exposing (Html, div, input, section, text)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onInput)



-- type alias UserId =
--     String


type alias Model =
    { name : String

    -- , id : UserId
    }


init : Model
init =
    { name = "" }


type Msg
    = UserName String


update : Msg -> Model -> Model
update msg _ =
    case msg of
        UserName name ->
            { name = name }


view : Model -> Html Msg
view model =
    section []
        [ div [] [ text ("Hello " ++ model.name) ]
        , input [ placeholder "What's your name?", value model.name, onInput UserName ] []
        ]
