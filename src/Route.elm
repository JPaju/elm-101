module Route exposing (Route(..), fromUrl, href)

import Url exposing (Url)
import Url.Parser as Parser


-- This is used to represent all the valid routes in the app
type Route
    = Counter
    | Player
    | Comic


routeParser : Parser.Parser (Route -> a) a
routeParser =
    Parser.oneOf
        [ Parser.map Counter (Parser.s "counter")
        , Parser.map Player (Parser.s "player")
        , Parser.map Comic (Parser.s "comic")
        ]


fromUrl : Url -> Maybe Route
fromUrl =
    Parser.parse routeParser


href : Route -> String
href route =
    case route of
        Counter ->
            "/counter"

        Player ->
            "/player"

        Comic ->
            "/comic"
