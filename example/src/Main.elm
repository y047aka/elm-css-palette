module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Color exposing (Color, hsl, toCssString)
import Color.Css exposing (backgroundColor, border3)
import Css exposing (after, alignItems, before, bold, borderRadius, center, column, currentColor, displayFlex, em, flexDirection, fontWeight, height, listStyle, margin, minWidth, none, padding, property, px, qt, solid, width, zero)
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


light : Palette
light =
    { background = Just (hsl 0 0 1)
    , color = Just (hsl 0 0 0.4)
    , border = Just (hsl 0 0 0.7)
    }


dark : Palette
dark =
    { background = Just (hsl 0 0 0.2)
    , color = Just (hsl 0 0 0.9)
    , border = Just (hsl 0 0 0.6)
    }


primaryButton : Palette
primaryButton =
    { background = Just (hsl 210 1 0.5)
    , color = Just (hsl 0 0 1)
    , border = Just (hsl 210 1 0.6)
    }


secondaryButton : Palette
secondaryButton =
    { primaryButton
        | background = primaryButton.color
        , color = primaryButton.background
        , border = Just (hsl 210 1 0.6)
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


box : { label : String, palette : Palette } -> Html msg
box props =
    let
        p =
            props.palette

        heading : String -> Html msg
        heading label_ =
            div [ css [ fontWeight bold ] ] [ text label_ ]

        listItem : String -> Maybe Color -> Html msg
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


cellWithColorValue : Color -> Html msg
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
                , Css.border3 (px 1) solid currentColor
                ]
            ]
        ]
        [ text (toCssString c) ]
