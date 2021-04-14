module Ui.Button exposing (..)

import Element exposing (Element)
import Widget exposing (textButton)
import Widget.Material as Material


testButton : String -> msg -> Element msg
testButton label msg =
    textButton (Material.textButton Material.defaultPalette)
        { text = label
        , onPress = Just msg
        }



-- |> always "Ignore this line"
