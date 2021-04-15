module Page exposing (..)

import Page.Comic as Comic
import Route exposing (Route(..))


type Page
    = CounterPage
    | PlayerPage
    | ComicPage Comic.Model



-- view : Element msg -> Browser.Document msg
-- view content =
--     { title = "This is a title"
--     , body =
--         [ layout [] <|
--             column [ height fill, width fill, spacing 10 ]
--                 [ viewHeader
--                 , Navbar.view model.page
--                 ]
--         ]
--     }
