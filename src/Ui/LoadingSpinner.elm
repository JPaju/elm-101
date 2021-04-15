module Ui.LoadingSpinner exposing (loadingSpinner)

import Element exposing (Attribute, Element, el)
import Widget exposing (circularProgressIndicator)
import Widget.Material exposing (defaultPalette, progressIndicator)


loadingSpinner : List (Attribute msg) -> Element msg
loadingSpinner attrs =
    circularProgressIndicator styles Nothing
        |> el attrs


styles =
    progressIndicator defaultPalette
