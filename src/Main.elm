module Main exposing (..)

import Browser
import Counter
import Element
    exposing
        ( DeviceClass(..)
        , Element
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
        , shrink
        , spacing
        , width
        )
import Element.Background as Background
import Element.Font as Font exposing (bold)
import Element.Region exposing (heading)
import Html exposing (Html)
import Navigation as Nav
import Ui.Colors exposing (lightBlue)
import User exposing (update, view)



-- UI-komponentit kirjastosta
-- Layout gridillä ja flexboxilla
-- TODO
-- 1. Käyttäjän pitää ensin syöttää nimimerkki
-- 2. Generoidaan käyttäjälle ID (myöhemmin backendissä)
-- 3. Tallennetaan ylemmät local storageen (josta ne ladataan uudestaan jos sivu päivitetään uudestaan)
-- 4. Ala hahmottelemaan pelilautaa ja laivoja


type alias Model =
    { counter : Counter.Model
    , user : User.Model
    , page : Nav.Page
    }


init : ( Model, Cmd Msg )
init =
    ( { counter = Counter.init
      , user = User.init
      , page = Nav.UserPage
      }
    , Cmd.none
    )


type Msg
    = Counter Counter.Msg
    | User User.Msg
    | PageChanged Nav.Page
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Counter counterMsg ->
            ( { model | counter = Counter.update counterMsg model.counter }, Cmd.none )

        User usrMsg ->
            ( { model | user = User.update usrMsg model.user }, Cmd.none )

        PageChanged newPage ->
            ( { model | page = newPage }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


explain : Element.Attribute msg
explain =
    Element.explain Debug.todo


viewHeader : Element msg
viewHeader =
    el [ width fill ] <|
        column [ width fill, Background.color lightBlue, spacing 20, padding 20 ]
            [ logo 200
            , el [ centerX, Font.size 30, heading 1, bold ] (Element.text "Your Elm App is working!")
            ]


logo : Int -> Element msg
logo size =
    image [ centerX, height (shrink |> minimum size) ] { src = "/logo.svg", description = "Elm logo" }


viewContent : Model -> Element Msg
viewContent model =
    el [ centerX, centerY ] <|
        html <|
            case model.page of
                Nav.UserPage ->
                    Html.map User (User.view model.user)

                Nav.CounterPage ->
                    Html.map Counter (Counter.view model.counter)


view : Model -> Html Msg
view model =
    layout [] <|
        column [ height fill, width fill, spacing 10 ]
            [ viewHeader
            , Nav.navBar model.page PageChanged
            , viewContent model
            ]


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
