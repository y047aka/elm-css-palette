module Css.PalettesByState exposing
    ( PalettesByState, initPalettes
    , palettesByState
    , palettesByStateWithBackground, palettesByStateWithColor, palettesByStateWithBorder
    )

{-|

@docs PalettesByState, initPalettes
@docs palettesByState
@docs palettesByStateWithBackground, palettesByStateWithColor, palettesByStateWithBorder

-}

import Css exposing (ColorValue, Style)
import Css.Palette as Palette exposing (Palette, palette)


{-| -}
type alias PalettesByState color =
    { default : Palette color
    , selected : Maybe ( Bool, Palette color )
    , link : Maybe (Palette color)
    , visited : Maybe (Palette color)
    , hover : Maybe (Palette color)
    , focus : Maybe (Palette color)
    , active : Maybe (Palette color)
    }


{-| -}
initPalettes : PalettesByState (ColorValue c)
initPalettes =
    { default = Palette.init
    , selected = Nothing
    , link = Nothing
    , visited = Nothing
    , hover = Nothing
    , focus = Nothing
    , active = Nothing
    }


{-| -}
palettesByState : PalettesByState (ColorValue c) -> Style
palettesByState ps =
    [ case ps.selected of
        Just ( True, selected ) ->
            Just (palette selected)

        _ ->
            Just (palette ps.default)

    -- https://meyerweb.com/eric/css/link-specificity.html
    , Maybe.map (\p -> Css.link [ palette p ]) ps.link
    , Maybe.map (\p -> Css.visited [ palette p ]) ps.visited
    , Maybe.map (\p -> Css.hover [ palette p ]) ps.hover
    , Maybe.map (\p -> Css.focus [ palette p ]) ps.focus
    , Maybe.map (\p -> Css.active [ palette p ]) ps.active
    ]
        |> List.filterMap identity
        |> Css.batch


type alias Options color =
    { background : color -> Style
    , color : color -> Style
    , border : color -> Style
    }


palettesByStateWith : Options color -> PalettesByState color -> Style
palettesByStateWith fn ps =
    [ case ps.selected of
        Just ( True, selected ) ->
            Just (paletteWith fn selected)

        _ ->
            Just (paletteWith fn ps.default)
    , Maybe.map (\p -> Css.link [ paletteWith fn p ]) ps.link
    , Maybe.map (\p -> Css.visited [ paletteWith fn p ]) ps.visited
    , Maybe.map (\p -> Css.hover [ paletteWith fn p ]) ps.hover
    , Maybe.map (\p -> Css.focus [ paletteWith fn p ]) ps.focus
    , Maybe.map (\p -> Css.active [ paletteWith fn p ]) ps.active
    ]
        |> List.filterMap identity
        |> Css.batch


paletteWith : Options color -> Palette color -> Style
paletteWith fn p =
    [ Maybe.map fn.background p.background
    , Maybe.map fn.color p.color
    , Maybe.map fn.border p.border
    ]
        |> List.filterMap identity
        |> Css.batch


default : Options (ColorValue c)
default =
    { background = Css.backgroundColor
    , color = Css.color
    , border = Css.borderColor
    }


{-| -}
palettesByStateWithBackground : (ColorValue c -> Style) -> PalettesByState (ColorValue c) -> Style
palettesByStateWithBackground fn =
    palettesByStateWith { default | background = fn }


{-| -}
palettesByStateWithColor : (ColorValue c -> Style) -> PalettesByState (ColorValue c) -> Style
palettesByStateWithColor fn =
    palettesByStateWith { default | color = fn }


{-| -}
palettesByStateWithBorder : (ColorValue c -> Style) -> PalettesByState (ColorValue c) -> Style
palettesByStateWithBorder fn =
    palettesByStateWith { default | border = fn }
