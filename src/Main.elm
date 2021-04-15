module Main exposing (..)

import Browser
import Browser.Navigation as Nav
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
        , image
        , layout
        , minimum
        , none
        , padding
        , shrink
        , spacing
        , width
        )
import Element.Background as Background
import Element.Font as Font exposing (bold)
import Element.Region exposing (heading)
import Navbar
import Page as Page exposing (Page(..))
import Page.Comic as Comic
import Page.Counter as Counter
import Route exposing (Route(..), fromUrl)
import Ui exposing (lightBlue)
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
    , counter : Counter.Model
    }


init : Url -> Nav.Key -> ( Model, Cmd Msg )
init _ key =
    ( { key = key
      , user = Anonymous -- TODO -- from flags
      , page = Page.CounterPage -- TODO -- From url
      , counter = Counter.init
      }
    , Cmd.none
    )


type Msg
    = NoOp
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | CounterMsg Counter.Msg
    | UserMsg User.Msg
    | ComicMsg Comic.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( LinkClicked request, _ ) ->
            linkClicked model request

        ( UrlChanged url, _ ) ->
            urlChanged model url

        ( CounterMsg counterMsg, CounterPage ) ->
            Counter.update counterMsg model.counter
                |> stepCounter model

        ( UserMsg _, PlayerPage ) ->
            ( model, Cmd.none )

        ( ComicMsg comicMsg, ComicsPage comicsModel ) ->
            Comic.update comicMsg comicsModel
                |> stepComic model

        ( _, _ ) ->
            ( model, Cmd.none )


stepCounter : Model -> ( Counter.Model, Cmd Counter.Msg ) -> ( Model, Cmd Msg )
stepCounter model ( counterModel, counterCmd ) =
    ( { model | page = Page.CounterPage, counter = counterModel }
    , Cmd.map CounterMsg counterCmd
    )


stepComic : Model -> ( Comic.Model, Cmd Comic.Msg ) -> ( Model, Cmd Msg )
stepComic model ( comicsModel, comicCmd ) =
    ( { model | page = Page.ComicsPage comicsModel }
    , Cmd.map ComicMsg comicCmd
    )


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
            ( { model | page = Page.CounterPage }, Cmd.none )

        Just Route.Player ->
            ( { model | page = Page.PlayerPage }, Cmd.none )

        Just Route.Comics ->
            stepComic model Comic.init

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


viewContent : Element Msg -> Element Msg
viewContent =
    -- el [ centerX, centerY ]
    el []


view : Model -> Browser.Document Msg
view model =
    { title = "This is a title"
    , body =
        [ layout [] <|
            column [ height fill, width fill, spacing 10 ]
                [ viewHeader
                , Navbar.view model.page
                , el [ width fill, height fill ] <|
                    case model.page of
                        Page.CounterPage ->
                            Counter.view CounterMsg model.counter

                        Page.PlayerPage ->
                            none

                        Page.ComicsPage comicModel ->
                            Comic.view comicModel
                                |> Element.map ComicMsg
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
