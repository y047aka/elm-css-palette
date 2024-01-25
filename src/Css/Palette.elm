module Css.Palette exposing
    ( Palette, init
    , palette
    , paletteWithBackground, paletteWithColor, paletteWithBorder
    , setBackground, setColor, setBorder
    )

{-|

@docs Palette, init
@docs palette
@docs paletteWithBackground, paletteWithColor, paletteWithBorder
@docs setBackground, setColor, setBorder

-}

import Css exposing (ColorValue, Style)


{-| -}
type alias Palette compatible =
    { background : Maybe (ColorValue compatible)
    , color : Maybe (ColorValue compatible)
    , border : Maybe (ColorValue compatible)
    }


{-| -}
init : Palette compatible
init =
    { background = Nothing
    , color = Nothing
    , border = Nothing
    }


{-| -}
palette : Palette compatible -> Style
palette p =
    [ Maybe.map Css.backgroundColor p.background
    , Maybe.map Css.color p.color
    , Maybe.map Css.borderColor p.border
    ]
        |> List.filterMap identity
        |> Css.batch


type alias Options compatible =
    { background : ColorValue compatible -> Style
    , color : ColorValue compatible -> Style
    , border : ColorValue compatible -> Style
    }


paletteWith : Options compatible -> Palette compatible -> Style
paletteWith fn p =
    [ Maybe.map fn.background p.background
    , Maybe.map fn.color p.color
    , Maybe.map fn.border p.border
    ]
        |> List.filterMap identity
        |> Css.batch


default : Options compatible
default =
    { background = Css.backgroundColor
    , color = Css.color
    , border = Css.borderColor
    }


{-| -}
paletteWithBackground : (ColorValue compatible -> Style) -> Palette compatible -> Style
paletteWithBackground fn p =
    paletteWith { default | background = fn } p


{-| -}
paletteWithColor : (ColorValue compatible -> Style) -> Palette compatible -> Style
paletteWithColor fn p =
    paletteWith { default | color = fn } p


{-| -}
paletteWithBorder : (ColorValue compatible -> Style) -> Palette compatible -> Style
paletteWithBorder fn =
    paletteWith { default | border = fn }



-- SETTER


{-| -}
setBackground : ColorValue compatible -> Palette compatible -> Palette compatible
setBackground c p =
    { p | background = Just c }


{-| -}
setColor : ColorValue compatible -> Palette compatible -> Palette compatible
setColor c p =
    { p | color = Just c }


{-| -}
setBorder : ColorValue compatible -> Palette compatible -> Palette compatible
setBorder c p =
    { p | border = Just c }
