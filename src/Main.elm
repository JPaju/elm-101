module Main exposing (..)

import Browser
import Browser.Navigation as Nav
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
        , text
        , width
        )
import Element.Background as Background
import Element.Font as Font exposing (bold)
import Element.Region exposing (heading)
import Html exposing (Html)
import Navbar
import Page as Page exposing (Page(..))
import Route exposing (Route(..), fromUrl)
import Ui.Colors exposing (lightBlue)
import Url exposing (Url)
import User exposing (update, view)



-- UI-komponentit kirjastosta
-- Layout gridillä ja flexboxilla
-- TODO
-- 1. Käyttäjän pitää ensin syöttää nimimerkki
-- 2. Generoidaan käyttäjälle ID (myöhemmin backendissä)
-- 3. Tallennetaan ylemmät local storageen (josta ne ladataan uudestaan jos sivu päivitetään uudestaan)
-- 4. Ala hahmottelemaan pelilautaa ja laivoja


type alias Player =
    { name : String
    , id : String
    }


type User
    = Anonymous
    | Known Player


type alias Model =
    { key : Nav.Key
    , user : User
    , page : Page
    }


init : Url -> Nav.Key -> ( Model, Cmd Msg )
init url key =
    ( { key = key
      , user = Anonymous -- TODO -- from flags
      , page = Page.Player -- TODO -- From url
      }
    , Cmd.none
    )


type Msg
    = NoOp
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | CounterMsg Counter.Msg
    | UserMsg User.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked request ->
            linkClicked model request

        UrlChanged url ->
            urlChanged model url

        CounterMsg counterMsg ->
            ( model, Cmd.none )

        UserMsg userMsg ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


linkClicked : Model -> Browser.UrlRequest -> ( Model, Cmd msg )
linkClicked model urlRequest =
    case urlRequest of
        Browser.Internal url ->
            ( model, Nav.pushUrl model.key (Url.toString url) )

        -- TODO -- Check that user has given their information
        Browser.External extUrl ->
            ( model, Nav.load extUrl )


urlChanged : Model -> Url -> ( Model, Cmd Msg )
urlChanged model url =
    case fromUrl url of
        Just Route.Counter ->
            ( { model | page = Page.Counter }, Cmd.none )

        Just Route.Player ->
            ( { model | page = Page.Player }, Cmd.none )

        Just Route.FunStuff ->
            ( { model | page = Page.Memes }, Cmd.none )

        Nothing ->
            ( Debug.log ("Route for url '" ++ Url.toString url ++ "' not found") model, Cmd.none )


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


viewContent : String -> Element Msg
viewContent content =
    el [ centerX, centerY ] <| text <| content


view : Model -> Browser.Document Msg
view model =
    { title = "This is a title"
    , body =
        [ layout [] <|
            column [ height fill, width fill, spacing 10 ]
                [ viewHeader
                , Navbar.view model.page
                , viewContent <|
                    case model.page of
                        Page.Counter ->
                            "Counter"

                        Page.Player ->
                            "Player"

                        Page.Memes ->
                            "Memes"
                ]
        ]
    }


main : Program () Model Msg
main =
    Browser.application
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
