module Ui exposing (appTitle, blue, defaultFont, grey, lightBlue, loadingSpinner, pageHeader, primaryButton, red, textInput)

import Element exposing (Attribute, Color, Element, el, fill, maximum, text, width)
import Element.Font as Font exposing (Font)
import Element.Input as Input
import Element.Region as Region
import Html.Events exposing (onClick)
import Widget exposing (circularProgressIndicator, textButton)
import Widget.Material as Material exposing (defaultPalette, progressIndicator)



---- COLORS ----


blue : Color
blue =
    Element.rgb255 63 81 181


lightBlue : Color
lightBlue =
    Element.rgb255 95 171 220


red : Color
red =
    Element.rgb255 249 28 114


grey : Color
grey =
    Element.rgba255 0 0 0 0.54



---- TEXT ----


defaultFont : Font
defaultFont =
    Font.typeface "Poppins"


appTitle : List (Attribute msg) -> String -> Element msg
appTitle attributes title =
    el (attributes ++ [ Region.heading 1, Font.size 28, Font.semiBold ]) (text title)


pageHeader : List (Attribute msg) -> String -> Element msg
pageHeader attributes title =
    el (attributes ++ [ Region.heading 2, Font.size 32, Font.semiBold ]) (text title)



---- BUTTONS ----


type alias ButtonConfig msg =
    { label : String
    , enabled : Bool
    , onClick : msg
    }


primaryButton : List (Attribute msg) -> ButtonConfig msg -> Element msg
primaryButton attrs { label, enabled, onClick } =
    el attrs <|
        textButton (Material.containedButton Material.defaultPalette)
            { text = label
            , onPress =
                if enabled then
                    Just onClick

                else
                    Nothing
            }



---- INPUTS ----


textInput : List (Attribute msg) -> String -> (String -> msg) -> String -> Element msg
textInput attributes label onChange value =
    let
        defaultAttributes =
            [ width (fill |> maximum 300) ]

        labelText =
            text label
    in
    Input.text (attributes ++ defaultAttributes)
        { onChange = onChange
        , text = value
        , placeholder =
            labelText
                |> Input.placeholder []
                |> Just
        , label =
            labelText
                |> Input.labelAbove [ Font.size 12, Font.alignLeft, Font.color grey ]
        }



---- SPINNER ----


spinnerStyles : Widget.ProgressIndicatorStyle msg
spinnerStyles =
    progressIndicator defaultPalette


loadingSpinner : List (Attribute msg) -> Element msg
loadingSpinner attrs =
    circularProgressIndicator spinnerStyles Nothing
        |> el attrs
