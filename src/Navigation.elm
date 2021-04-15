module Navigation exposing (Page(..), navBar)

import Element
    exposing
        ( Element
        , centerX
        , fill
        , paddingEach
        , paddingXY
        , pointer
        , row
        , spacing
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Element.Region exposing (navigation)
import Ui.Colors exposing (blue)


type Page
    = UserPage
    | CounterPage


navBar : Page -> (Page -> msg) -> Element msg
navBar activePage toMsg =
    row
        [ width fill
        , paddingEach { top = 0, right = 5, bottom = 20, left = 5 }
        , spacing 5
        , navigation
        ]
        ([ UserPage, CounterPage ]
            |> List.map (\p -> ( p, p == activePage ))
            |> List.map (navElement toMsg))


navElement : (Page -> msg) -> ( Page, Bool ) -> Element msg
navElement toMsg ( page, isActivePage ) =
    let
        backgroundColor =
            if isActivePage then
                Background.color Ui.Colors.red

            else
                Background.color blue

        label =
            navLabel page
    in
    Input.button
        [ centerX
        , width fill
        , backgroundColor
        , Border.rounded 3
        , paddingXY 20 10
        , pointer
        ]
        { onPress = Just (toMsg page), label = Element.text label }


navLabel : Page -> String
navLabel v =
    case v of
        CounterPage ->
            "Counter"

        UserPage ->
            "User"
