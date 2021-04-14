module OldMain exposing (..)

-- import Html exposing (..)
-- import Html.Attributes exposing (src)
-- import Html.Events exposing (onClick)
-- import Html exposing (Html)

import Browser
import Counter
import Css exposing (display, height, pct, px)
import Css.Media exposing (grid)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, src)
import Html.Styled.Events exposing (onClick)
import User exposing (update, view)



-- import User exposing (updateUser)
-- UI-komponentit kirjastosta
-- Layout gridillä ja flexboxilla
-- TODO
-- 1. Käyttäjän pitää ensin syöttää nimimerkki
-- 2. Generoidaan käyttäjälle ID (myöhemmin backendissä)
-- 3. Tallennetaan ylemmät local storageen (josta ne ladataan uudestaan jos sivu päivitetään uudestaan)
-- 4. Ala hahmottelemaan pelilautaa ja laivoja


type View
    = UserView
    | CounterView


type alias Model =
    { counter : Counter.Model
    , user : User.Model
    , view : View
    }


init : ( Model, Cmd Msg )
init =
    ( { counter = Counter.init
      , user = User.init
      , view = UserView
      }
    , Cmd.none
    )


type Msg
    = Counter Counter.Msg
    | User User.Msg
    | ChangeView View


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Counter counterMsg ->
            ( { model | counter = Counter.update counterMsg model.counter }, Cmd.none )

        User usrMsg ->
            ( { model | user = User.update usrMsg model.user }, Cmd.none )

        ChangeView newView ->
            ( { model | view = newView }, Cmd.none )


view : Model -> Html Msg
view model =
    div
        -- [ css
        --     [ height (pct 100)
        --     ]
        -- ]
        [ css
            [ height (pct 100)
            , display
            ]
        ]
        [ viewHeader
        , Html.Styled.map ChangeView viewNavigation
        , viewContent model
        ]


viewHeader : Html Msg
viewHeader =
    header []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        ]


viewNavigation : Html View
viewNavigation =
    nav []
        [ a [ onClick UserView ] [ text "User" ]
        , a [ onClick CounterView ] [ text "Counter" ]
        ]


viewContent : Model -> Html Msg
viewContent model =
    main_ []
        [ case model.view of
            UserView ->
                Html.Styled.map User (User.view model.user)

            CounterView ->
                Html.Styled.map Counter (Counter.view model.counter)
        ]


main : Program () Model Msg
main =
    Browser.element
        { view = view >> toUnstyled
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
