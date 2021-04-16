module Navbar exposing (view, ActivePage(..))

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
import Element.Region as Region
import Route exposing (Route)
import Ui exposing (blue)


-- This is only used to determine what navigation link should be rendered as active
type ActivePage
    = Player
    | Counter
    | Comic


view : ActivePage -> Element msg
view currPage =
    let
        navLink =
            navElement currPage
    in
    row
        [ width fill
        , paddingEach { top = 0, right = 5, bottom = 20, left = 5 }
        , spacing 5
        , Region.navigation
        ]
        [ navLink Route.Player "Player"
        , navLink Route.Counter "Counter"
        , navLink Route.Comic "Comic"
        ]


navElement : ActivePage -> Route -> String -> Element msg
navElement currPage route label =
    let
        isActivePage =
            isActive route currPage

        backgroundColor =
            if isActivePage then
                Background.color Ui.red

            else
                Background.color blue
    in
    Element.link
        [ centerX
        , width fill
        , backgroundColor
        , Border.rounded 3
        , paddingXY 20 10
        , pointer
        ]
        { url = Route.href route, label = Element.text label }


isActive : Route -> ActivePage -> Bool
isActive route page =
    case ( route, page ) of
        ( Route.Counter, Counter ) ->
            True

        ( Route.Player, Player ) ->
            True

        ( Route.Comic, Comic ) ->
            True

        _ ->
            False
