module Main exposing (..)

import Browser
import Counter
import Element
    exposing
        ( Color
        , DeviceClass(..)
        , Element
        , alignRight
        , centerX
        , centerY
        , column
        , el
        , fill
        , height
        , html
        , image
        , layout
        , minimum
        , padding
        , paddingXY
        , pointer
        , px
        , row
        , shrink
        , spacing
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (bold)
import Element.Input as Input
import Element.Region exposing (heading, navigation)
import Html exposing (Html)
import Ui.Button exposing (testButton)
import Ui.Colors exposing (blue)
import User exposing (update, view)



-- UI-komponentit kirjastosta
-- Layout gridillä ja flexboxilla
-- TODO
-- 1. Käyttäjän pitää ensin syöttää nimimerkki
-- 2. Generoidaan käyttäjälle ID (myöhemmin backendissä)
-- 3. Tallennetaan ylemmät local storageen (josta ne ladataan uudestaan jos sivu päivitetään uudestaan)
-- 4. Ala hahmottelemaan pelilautaa ja laivoja


type View
    = UserView
    | CounterView


type alias Model =
    { counter : Counter.Model
    , user : User.Model
    , view : View
    }


init : ( Model, Cmd Msg )
init =
    ( { counter = Counter.init
      , user = User.init
      , view = UserView
      }
    , Cmd.none
    )


type Msg
    = Counter Counter.Msg
    | User User.Msg
    | ViewChanged View
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Counter counterMsg ->
            ( { model | counter = Counter.update counterMsg model.counter }, Cmd.none )

        User usrMsg ->
            ( { model | user = User.update usrMsg model.user }, Cmd.none )

        ViewChanged newView ->
            ( { model | view = newView }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


explain : Element.Attribute msg
explain =
    Element.explain Debug.todo


viewHeader : Element msg
viewHeader =
    column [ width fill, spacing 20, padding 50 ]
        [ image [ centerX, height (shrink |> minimum 200) ] { src = "/logo.svg", description = "Elm logo" }
        , el [ centerX, Font.size 30, heading 1, bold ] (Element.text "Your Elm App is working!")
        ]


navElement : ( String, View ) -> Element View
navElement ( label, msg ) =
    Input.button
        [ centerX
        , Background.color blue
        , paddingXY 20 10
        , Border.rounded 20
        , pointer
        ]
        { onPress = Just msg, label = Element.text label }


navbar : Element View
navbar =
    row
        [ width fill, padding 10, spacing 30, navigation ]
        (List.map navElement [ ( "User", UserView ), ( "Counter", CounterView ) ])


viewContent : Model -> Element Msg
viewContent model =
    html <|
        case model.view of
            UserView ->
                Html.map User (User.view model.user)

            CounterView ->
                Html.map Counter (Counter.view model.counter)


view : Model -> Html Msg
view model =
    layout [] <|
        column [ height fill, width fill, paddingXY 30 10 ]
            [ viewHeader
            , Element.map ViewChanged navbar
            , viewContent model
            , testButton "Test" NoOp
            ]


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
