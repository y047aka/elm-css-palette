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

import Css exposing (Color, Style)


{-| -}
type alias Palette =
    { background : Maybe Color
    , color : Maybe Color
    , border : Maybe Color
    }


{-| -}
init : Palette
init =
    { background = Nothing
    , color = Nothing
    , border = Nothing
    }


{-| -}
palette : Palette -> Style
palette p =
    [ Maybe.map Css.backgroundColor p.background
    , Maybe.map Css.color p.color
    , Maybe.map Css.borderColor p.border
    ]
        |> List.filterMap identity
        |> Css.batch


type alias Options =
    { background : Color -> Style
    , color : Color -> Style
    , border : Color -> Style
    }


paletteWith : Options -> Palette -> Style
paletteWith fn p =
    [ Maybe.map fn.background p.background
    , Maybe.map fn.color p.color
    , Maybe.map fn.border p.border
    ]
        |> List.filterMap identity
        |> Css.batch


default : Options
default =
    { background = Css.backgroundColor
    , color = Css.color
    , border = Css.borderColor
    }


{-| -}
paletteWithBackground : (Color -> Style) -> Palette -> Style
paletteWithBackground fn p =
    paletteWith { default | background = fn } p


{-| -}
paletteWithColor : (Color -> Style) -> Palette -> Style
paletteWithColor fn p =
    paletteWith { default | color = fn } p


{-| -}
paletteWithBorder : (Color -> Style) -> Palette -> Style
paletteWithBorder fn =
    paletteWith { default | border = fn }



-- SETTER


{-| -}
setBackground : Color -> Palette -> Palette
setBackground c p =
    { p | background = Just c }


{-| -}
setColor : Color -> Palette -> Palette
setColor c p =
    { p | color = Just c }


{-| -}
setBorder : Color -> Palette -> Palette
setBorder c p =
    { p | border = Just c }
