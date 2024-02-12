module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Css exposing (..)
import Css.Color as Color exposing (Hsl360)
import Css.Palette as Palette exposing (Palette, paletteWithBorder)
import Html.Styled exposing (Html, dd, div, dl, dt, text, toUnstyled)
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
    div [ css [ displayFlex, flexWrap wrap , property "gap" "10px" ] ]
        [ box { label = "Light", palette = light }
        , box { label = "Dark", palette = dark }
        , box { label = "Primary Button", palette = primaryButton }
        , box { label = "Secondary Button", palette = secondaryButton }
        ]


box : { label : String, palette : Palette (ColorValue color) } -> Html msg
box props =
    let
        p =
            props.palette

        heading : String -> Html msg
        heading label_ =
            div [ css [ fontWeight bold ] ] [ text label_ ]
    in
    div
        [ css
            [ minWidth (em 19)
            , padding (em 1)
            , displayFlex
            , flexDirection column
            , property "row-gap" "1em"
            , borderRadius (px 10)
            , paletteWithBorder (border3 (px 1) solid) p
            ]
        ]
        [ heading props.label
        , definitionList
            [ ( "background", p.background )
            , ( "color", p.color )
            , ( "border", p.border )
            ]
        ]


colorcCell : ColorValue color -> Html msg
colorcCell c =
    div
        [ css
            [ width (em 1.5)
            , height (em 1.5)
            , borderRadius (em 0.25)
            , backgroundColor c
            , border3 (px 1) solid currentColor
            ]
        ]
        []


definitionList : List ( String, Maybe (ColorValue color) ) -> Html msg
definitionList pairs =
    let
        dtdd : ( String, Maybe (ColorValue color) ) -> List (Html msg)
        dtdd ( name, maybeColor ) =
            [ dt [ css [ textAlign right ] ] [ text name ]
            , dd [ css [ margin zero ] ]
                [ maybeColor
                    |> Maybe.map colorcCell
                    |> Maybe.withDefault (text "-")
                ]
            , dd [ css [ margin zero ] ]
                [ maybeColor
                    |> Maybe.map (.value >> text)
                    |> Maybe.withDefault (text "")
                ]
            ]
    in
    dl
        [ css
            [ margin zero
            , property "display" "grid"
            , property "grid-template-columns" "auto auto 1fr"
            , alignItems center
            , property "row-gap" "0.25em"
            , property "column-gap" "0.5em"
            ]
        ]
        (pairs |> List.map dtdd |> List.concat)
