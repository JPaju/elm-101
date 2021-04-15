module Ui.Button exposing (primaryButton)

import Element exposing (Attribute, Element, el)
import Widget exposing (textButton)
import Widget.Material as Material


primaryButton : List (Attribute msg) -> String -> msg -> Element msg
primaryButton attrs label msg =
    el attrs <|
        textButton (Material.containedButton Material.defaultPalette)
            { text = label
            , onPress = Just msg
            }
