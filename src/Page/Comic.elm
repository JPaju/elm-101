module Page.Comic exposing (Model, Msg, init, update, view)

import Element exposing (Element, alignBottom, alignTop, centerX, centerY, column, el, fill, height, image, maximum, padding, paddingXY, spacing, text, width)
import Element.Font as Font
import Element.Region as Region
import Http
import Json.Decode as Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (required)
import Process
import Random
import Task
import Ui.Button exposing (primaryButton)
import Ui.LoadingSpinner exposing (loadingSpinner)
import Url exposing (Url)
import Url.Builder


type alias Comics =
    { title : String
    , number : Int
    , imageUrl : String
    , description : String
    }


type Model
    = Loading
    | Success Comics
    | Failure String


type Msg
    = GotComicsNumber Int
    | GotComics Comics
    | Error String
    | FetchNewComic


init : ( Model, Cmd Msg )
init =
    ( Loading, randomComicNumber )


randomComicNumber =
    Random.generate GotComicsNumber (Random.int 1 2450)


comicUrl : Int -> String
comicUrl comicNumber =
    Url.Builder.crossOrigin "https://xkcd.vercel.app" [] [ Url.Builder.int "comic" comicNumber ]


fetchComic : Int -> Cmd Msg
fetchComic comicNumber =
    Http.get
        { url = comicUrl comicNumber
        , expect = Http.expectJson handleComicResult decoder
        }


decoder : Decoder Comics
decoder =
    Decode.succeed Comics
        |> required "title" string
        |> required "num" int
        |> required "img" string
        |> required "alt" string


handleComicResult : Result Http.Error Comics -> Msg
handleComicResult result =
    case result of
        Ok res ->
            GotComics res

        Err httpError ->
            Error "Network error"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotComicsNumber num ->
            ( model, fetchComic num )

        GotComics comic ->
            ( Success comic, Cmd.none )

        Error err ->
            ( Failure err, Cmd.none )

        FetchNewComic ->
            ( Loading, randomComicNumber )


view : Model -> Element Msg
view model =
    case model of
        Loading ->
            loadingSpinner [ centerX, centerY ]

        Success comic ->
            column [ width fill, height fill, paddingXY 10 20, spacing 30 ]
                [ comicTitle comic
                , image [ centerX, centerY, width (fill |> maximum 600) ]
                    { src = comic.imageUrl, description = comic.description }
                , primaryButton [ alignBottom, centerX ] "Next" FetchNewComic
                ]

        Failure err ->
            el [] (text ("Error: " ++ err))


comicTitle : Comics -> Element msg
comicTitle { number, title } =
    el [ centerX, Region.heading 1, Font.size 30, Font.bold ] (text ("#" ++ String.fromInt number ++ " - " ++ title))
