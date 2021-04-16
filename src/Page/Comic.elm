module Page.Comic exposing (Model, Msg, init, update, view)

import Element exposing (Element, alignBottom, centerX, centerY, column, el, fill, height, image, maximum, paddingXY, spacing, text, width)
import Http
import Json.Decode as Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (required)
import Layout
import Random
import Ui
import Url.Builder


type alias Comic =
    { title : String
    , number : Int
    , imageUrl : String
    , description : String
    }


type Model
    = Loading
    | Success Comic
    | Failure String


type Msg
    = GotComicNumber Int
    | GotComic Comic
    | Error String
    | FetchNewComic


init : ( Model, Cmd Msg )
init =
    ( Loading, randomComicNumber )


randomComicNumber : Cmd Msg
randomComicNumber =
    Random.generate GotComicNumber (Random.int 1 2450)


comicUrl : Int -> String
comicUrl comicNumber =
    Url.Builder.crossOrigin "https://xkcd.vercel.app" [] [ Url.Builder.int "comic" comicNumber ]


fetchComic : Int -> Cmd Msg
fetchComic comicNumber =
    Http.get
        { url = comicUrl comicNumber
        , expect = Http.expectJson handleComicResult decoder
        }


decoder : Decoder Comic
decoder =
    Decode.succeed Comic
        |> required "title" string
        |> required "num" int
        |> required "img" string
        |> required "alt" string


handleComicResult : Result Http.Error Comic -> Msg
handleComicResult result =
    case result of
        Ok res ->
            GotComic res

        Err _ ->
            Error "Network error"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotComicNumber num ->
            ( model, fetchComic num )

        GotComic comic ->
            ( Success comic, Cmd.none )

        Error err ->
            ( Failure err, Cmd.none )

        FetchNewComic ->
            ( Loading, randomComicNumber )


view : Model -> Layout.PageInfo Msg
view model =
    { title = "Comic"
    , content =
        case model of
            Loading ->
                Ui.loadingSpinner [ centerX, centerY ]

            Success comic ->
                column [ width fill, height fill, paddingXY 10 20, spacing 30 ]
                    [ comicHeader comic
                    , image [ centerX, centerY, width (fill |> maximum 600) ]
                        { src = comic.imageUrl, description = comic.description }
                    , Ui.primaryButton [ alignBottom, centerX ] { label = "Next", enabled = True, onClick = FetchNewComic }
                    ]

            Failure err ->
                el [] (text ("Error: " ++ err))
    }


comicHeader : Comic -> Element msg
comicHeader { number, title } =
    "#" ++ String.fromInt number ++ " - " ++ title |> Ui.pageHeader [ centerX ]
