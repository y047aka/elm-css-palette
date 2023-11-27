module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Css exposing (..)
import Css.Palette as Palette exposing (Palette, paletteWith)
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
        heading : String -> Html msg
        heading label_ =
            div [ css [ fontWeight bold ] ] [ text label_ ]
    in
    div
        [ css
            [ minWidth (em 18)
            , padding (em 1)
            , displayFlex
            , flexDirection column
            , property "row-gap" "0.5em"
            , borderRadius (px 10)
            , paletteWith (border3 (px 1) solid) props.palette
            ]
        ]
        [ heading props.label
        , ul [ css [ listStyle none, margin zero, padding zero ] ]
            [ propertyPreview "background" props.palette.background
            , propertyPreview "color" props.palette.color
            , propertyPreview "border" props.palette.border
            ]
        ]


propertyPreview : String -> Maybe Color -> Html msg
propertyPreview name maybeColor =
    let
        coloredCell c =
            div
                [ css
                    [ width (em 1)
                    , height (em 1)
                    , borderRadius (px 2)
                    , backgroundColor c
                    , border3 (px 1) solid currentColor
                    ]
                ]
                []
    in
    li [ css [ displayFlex, property "column-gap" "0.5em", alignItems center ] ]
        [ div [ css [ after [ property "content" "' :'" ] ] ] [ text name ]
        , maybeColor |> Maybe.map coloredCell |> Maybe.withDefault (text "")
        , div []
            [ text
                (maybeColor
                    |> Maybe.map .value
                    |> Maybe.withDefault "_"
                )
            ]
        ]
