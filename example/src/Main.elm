module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Css exposing (..)
import Css.Color as Color exposing (Hsl360)
import Css.Palette as Palette exposing (Palette, paletteWithBorder)
import Html.Styled exposing (Html, div, li, text, toUnstyled, ul)
import Html.Styled.Attributes exposing (css)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view >> toUnstyled
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    {}


init : () -> ( Model, Cmd Msg )
init _ =
    ( {}, Cmd.none )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- PALETTE


light : Palette Hsl360
light =
    { background = Just (Color.hsl 0 0 1)
    , color = Just (Color.hsl 0 0 0.4)
    , border = Just (Color.hsl 0 0 0.7)
    }


dark : Palette Hsl360
dark =
    { background = Just (Color.hsl 0 0 0.2)
    , color = Just (Color.hsl 0 0 0.9)
    , border = Just (Color.hsl 0 0 0.6)
    }


primaryButton : Palette Hsl360
primaryButton =
    { background = Just (Color.hsl 210 1 0.5)
    , color = Just (Color.hsl 0 0 1)
    , border = Just (Color.hsl 210 1 0.6)
    }


secondaryButton : Palette Hsl360
secondaryButton =
    { primaryButton
        | background = primaryButton.color
        , color = primaryButton.background
        , border = Just (Color.hsl 210 1 0.6)
    }



-- VIEW


view : Model -> Html Msg
view model =
    div [ css [ displayFlex, property "column-gap" "10px" ] ]
        [ box { label = "Light", palette = light }
        , box { label = "Dark", palette = dark }
        , box { label = "Primary Button", palette = primaryButton }
        , box { label = "Secondary Button", palette = secondaryButton }
        ]


box : { label : String, palette : Palette Hsl360 } -> Html msg
box props =
    let
        p =
            props.palette

        heading : String -> Html msg
        heading label_ =
            div [ css [ fontWeight bold ] ] [ text label_ ]

        listItem : String -> Maybe Hsl360 -> Html msg
        listItem name maybeColor =
            li [ css [ displayFlex, property "column-gap" "0.5em" ] ]
                [ div [ css [ after [ property "content" (qt " :") ] ] ] [ text name ]
                , maybeColor
                    |> Maybe.map cellWithColorValue
                    |> Maybe.withDefault (text "-")
                ]
    in
    div
        [ css
            [ minWidth (em 18)
            , padding (em 1)
            , displayFlex
            , flexDirection column
            , property "row-gap" "0.5em"
            , borderRadius (px 10)
            , paletteWithBorder (border3 (px 1) solid) p
            ]
        ]
        [ heading props.label
        , ul [ css [ listStyle none, margin zero, padding zero ] ]
            [ listItem "background" p.background
            , listItem "color" p.color
            , listItem "border" p.border
            ]
        ]


cellWithColorValue : Hsl360 -> Html msg
cellWithColorValue c =
    div
        [ css
            [ displayFlex
            , property "column-gap" "0.5em"
            , alignItems center
            , before
                [ property "content" (qt "")
                , width (em 1)
                , height (em 1)
                , borderRadius (px 2)
                , backgroundColor c
                , border3 (px 1) solid currentColor
                ]
            ]
        ]
        [ text c.value ]
