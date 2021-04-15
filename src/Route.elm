module Route exposing (Route(..), fromUrl, href)

import Url exposing (Url)
import Url.Parser as Parser


type Route
    = Counter
    | Player
    | FunStuff


routeParser : Parser.Parser (Route -> a) a
routeParser =
    Parser.oneOf
        [ Parser.map Counter (Parser.s "counter")
        , Parser.map Player (Parser.s "player")
        , Parser.map FunStuff (Parser.s "fun")
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

        FunStuff ->
            "/fun"
