module Layout exposing (PageInfo, view)

import Browser
import Element exposing (Element, centerX, column, el, fill, height, image, layout, minimum, padding, shrink, spacing, width)
import Element.Background as Background
import Element.Font as Font
import Route exposing (Route(..))
import Ui


type alias PageInfo msg =
    { title : String
    , content : Element msg
    }


view : Element msg -> (a -> msg) -> PageInfo a -> Browser.Document msg
view navBar toMsg details =
    { title = appTitle details.title
    , body =
        [ layout [ Font.family [ Ui.defaultFont ] ] <|
            column [ height fill, width fill, spacing 10 ]
                [ banner
                , navBar
                , Element.map toMsg details.content
                ]
        ]
    }


appTitle : String -> String
appTitle title =
    title ++ " | Awesome Elm"


banner : Element msg
banner =
    el [ width fill ] <|
        column [ width fill, Background.color Ui.lightBlue, spacing 20, padding 20 ]
            [ logo 200
            , Ui.appTitle [ centerX ] "Awesome Elm app"
            ]


logo : Int -> Element msg
logo size =
    image [ centerX, height (shrink |> minimum size) ] { src = "/logo.svg", description = "Elm logo" }
