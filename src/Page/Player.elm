module Page.Player exposing (Model, Msg, Player, PlayerId, init, update, view)

import Element exposing (alignTop, centerX, centerY, column, fill, height, spacing, width)
import Layout
import Ui


type PlayerId
    = PlayerId String


type Player
    = Anonymous



-- | Known
--     { name : String
--     , id : PlayerId
--     }


type alias Model =
    { nameInput : String
    , player : Player
    }


type Msg
    = NameChanged String
    | SubmitClicked


init : Model
init =
    { nameInput = ""
    , player = Anonymous
    }



---- UPDATE ----


update : Msg -> Model -> Model
update msg model =
    case msg of
        NameChanged name ->
            { model | nameInput = name }

        SubmitClicked ->
            model



---- VIEW ----


view : Model -> Layout.PageInfo Msg
view model =
    { title = "Player page"
    , content =
        column [ height fill, width fill, spacing 40 ]
            [ Ui.pageHeader [ alignTop, centerX ] "Player Information"
            , Ui.textInput [ centerX, centerY ] "Player" NameChanged model.nameInput
            , Ui.primaryButton [ centerX, centerY ]
                { label = "Continue"
                , enabled = validName model.nameInput
                , onClick = SubmitClicked
                }
            ]
    }



---- HELPERS ----


validName : String -> Bool
validName name =
    (not << String.isEmpty) name
        && String.length name
        > 2
