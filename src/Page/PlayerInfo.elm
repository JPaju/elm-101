module Page.PlayerInfo exposing (..)
import Element exposing (el)
import Element exposing (none)
import Html exposing (Html)
import Element exposing (layout)
import Element exposing (Element)
import Element exposing (height)
import Element exposing (fill)
import Element exposing (width)
import Element exposing (text)
import Element exposing (centerX)
import Element exposing (centerY)

view : Element msg
view =
    el [height fill, width fill, centerX, centerY] (text "Enter username:")
