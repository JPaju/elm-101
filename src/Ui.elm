module Ui exposing (blue, lightBlue, loadingSpinner, primaryButton, red)

import Element exposing (Attribute, Color, Element, el)
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



---- BUTTONS ----


primaryButton : List (Attribute msg) -> String -> msg -> Element msg
primaryButton attrs label msg =
    el attrs <|
        textButton (Material.containedButton Material.defaultPalette)
            { text = label
            , onPress = Just msg
            }



---- SPINNER ----


spinnerStyles =
    progressIndicator defaultPalette


loadingSpinner : List (Attribute msg) -> Element msg
loadingSpinner attrs =
    circularProgressIndicator spinnerStyles Nothing
        |> el attrs
