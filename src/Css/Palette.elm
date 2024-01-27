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
type alias Palette color =
    { background : Maybe color
    , color : Maybe color
    , border : Maybe color
    }


{-| -}
init : Palette (ColorValue c)
init =
    { background = Nothing
    , color = Nothing
    , border = Nothing
    }


{-| -}
palette : Palette (ColorValue c) -> Style
palette p =
    [ Maybe.map Css.backgroundColor p.background
    , Maybe.map Css.color p.color
    , Maybe.map Css.borderColor p.border
    ]
        |> List.filterMap identity
        |> Css.batch


type alias Options color =
    { background : color -> Style
    , color : color -> Style
    , border : color -> Style
    }


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
paletteWithBackground : (ColorValue c -> Style) -> Palette (ColorValue c) -> Style
paletteWithBackground fn p =
    paletteWith { default | background = fn } p


{-| -}
paletteWithColor : (ColorValue c -> Style) -> Palette (ColorValue c) -> Style
paletteWithColor fn p =
    paletteWith { default | color = fn } p


{-| -}
paletteWithBorder : (ColorValue c -> Style) -> Palette (ColorValue c) -> Style
paletteWithBorder fn =
    paletteWith { default | border = fn }



-- SETTER


{-| -}
setBackground : color -> Palette color -> Palette color
setBackground c p =
    { p | background = Just c }


{-| -}
setColor : color -> Palette color -> Palette color
setColor c p =
    { p | color = Just c }


{-| -}
setBorder : color -> Palette color -> Palette color
setBorder c p =
    { p | border = Just c }
