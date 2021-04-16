module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Layout
import Navbar exposing (ActivePage(..))
import Page.Comic as Comic
import Page.Counter as Counter
import Page.Player as Player
import Route exposing (fromUrl)
import Url exposing (Url)
import User exposing (update)



-- TODO
-- 1. Käyttäjän pitää ensin syöttää nimimerkki
-- 2. Generoidaan käyttäjälle ID (myöhemmin backendissä)
-- 3. Tallennetaan ylemmät local storageen (josta ne ladataan uudestaan jos sivu päivitetään uudestaan)
-- 4. Ala hahmottelemaan pelilautaa ja laivoja


type alias Model =
    { key : Nav.Key
    , page : Page
    , counter : Counter.Model
    }


init : Url -> Nav.Key -> ( Model, Cmd Msg )
init _ key =
    ( { key = key
      , page = PlayerPage Player.init -- TODO -- From url
      , counter = Counter.init
      }
    , Cmd.none
    )


type Page
    = CounterPage
    | PlayerPage Player.Model
    | ComicPage Comic.Model


type Msg
    = NoOp
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | CounterMsg Counter.Msg
    | PlayerMsg Player.Msg
    | ComicMsg Comic.Msg


toActivePage : Page -> Navbar.ActivePage
toActivePage page =
    case page of
        CounterPage ->
            Counter

        PlayerPage _ ->
            Player

        ComicPage _ ->
            Comic



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( LinkClicked request, _ ) ->
            linkClicked model request

        ( UrlChanged url, _ ) ->
            urlChanged model url

        ( CounterMsg counterMsg, CounterPage ) ->
            Counter.update counterMsg model.counter
                |> updateCounter model

        ( PlayerMsg playerMsg, PlayerPage playerModel ) ->
            Player.update playerMsg playerModel
                |> updatePlayer model

        ( ComicMsg comicMsg, ComicPage comicModel ) ->
            Comic.update comicMsg comicModel
                |> updateComic model

        ( _, _ ) ->
            ( model, Cmd.none )


updateCounter : Model -> ( Counter.Model, Cmd Counter.Msg ) -> ( Model, Cmd Msg )
updateCounter model ( counterModel, counterCmd ) =
    ( { model | page = CounterPage, counter = counterModel }
    , Cmd.map CounterMsg counterCmd
    )


updatePlayer : Model -> Player.Model -> ( Model, Cmd Msg )
updatePlayer model playerModel =
    ( { model | page = PlayerPage playerModel }
    , Cmd.none
    )


updateComic : Model -> ( Comic.Model, Cmd Comic.Msg ) -> ( Model, Cmd Msg )
updateComic model ( comicModel, comicCmd ) =
    ( { model | page = ComicPage comicModel }
    , Cmd.map ComicMsg comicCmd
    )


linkClicked : Model -> Browser.UrlRequest -> ( Model, Cmd msg )
linkClicked model urlRequest =
    case urlRequest of
        -- TODO -- Check that user has given their information
        Browser.Internal url ->
            ( model, Nav.pushUrl model.key (Url.toString url) )

        Browser.External extUrl ->
            ( model, Nav.load extUrl )


urlChanged : Model -> Url -> ( Model, Cmd Msg )
urlChanged model url =
    case fromUrl url of
        Just Route.Counter ->
            ( { model | page = CounterPage }, Cmd.none )

        Just Route.Player ->
            ( { model | page = PlayerPage Player.init }, Cmd.none )

        Just Route.Comic ->
            updateComic model Comic.init

        Nothing ->
            ( Debug.log ("Route for url '" ++ Url.toString url ++ "' not found") model, Cmd.none )



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    let
        navBar =
            toActivePage model.page |> Navbar.view

        toPage =
            Layout.view navBar
    in
    case model.page of
        CounterPage ->
            toPage CounterMsg (Counter.view model.counter)

        PlayerPage playerModel ->
            toPage PlayerMsg (Player.view playerModel)

        ComicPage comicModel ->
            toPage ComicMsg (Comic.view comicModel)



---- MAIN ----


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
