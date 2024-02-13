module Css.PalettesByState exposing
    ( PalettesByState, initPalettes
    , palettesByState
    )

{-|

@docs PalettesByState, initPalettes
@docs palettesByState

-}

import Css exposing (ColorValue, Style)
import Css.Palette as Palette exposing (Palette, palette)


{-| -}
type alias PalettesByState color =
    { -- Group 0
      default : Palette color
    , selected : Maybe ( Bool, Palette color )

    -- Group 1
    , link : Maybe (Palette color)
    , visited : Maybe (Palette color)

    -- Group 2
    , hover : Maybe (Palette color)

    -- Group 3
    , default_ : Maybe (Palette color)
    , focusWithin : Maybe (Palette color)
    , focus : Maybe (Palette color)
    , focusVisible : Maybe (Palette color)
    , checked : Maybe (Palette color)
    , disabled : Maybe (Palette color)
    , enabled : Maybe (Palette color)
    , readOnly : Maybe (Palette color)
    , readWrite : Maybe (Palette color)
    , required : Maybe (Palette color)
    , optional : Maybe (Palette color)
    , invalid : Maybe (Palette color)
    , userInvalid : Maybe (Palette color)
    , valid : Maybe (Palette color)
    , userValid : Maybe (Palette color)
    , inRange : Maybe (Palette color)
    , outOfRange : Maybe (Palette color)
    , indeterminate : Maybe (Palette color)
    , placeholderShown : Maybe (Palette color)
    , empty : Maybe (Palette color)
    , target : Maybe (Palette color)

    -- Group 4
    , active : Maybe (Palette color)
    , defined : Maybe (Palette color)

    -- Group 5
    , others : List ( List Style -> Style, Palette color )
    }


{-| -}
initPalettes : PalettesByState (ColorValue c)
initPalettes =
    { default = Palette.init
    , selected = Nothing
    , link = Nothing
    , visited = Nothing
    , hover = Nothing
    , default_ = Nothing
    , focusWithin = Nothing
    , focus = Nothing
    , focusVisible = Nothing
    , checked = Nothing
    , disabled = Nothing
    , enabled = Nothing
    , readOnly = Nothing
    , readWrite = Nothing
    , required = Nothing
    , optional = Nothing
    , invalid = Nothing
    , userInvalid = Nothing
    , valid = Nothing
    , userValid = Nothing
    , inRange = Nothing
    , outOfRange = Nothing
    , indeterminate = Nothing
    , placeholderShown = Nothing
    , empty = Nothing
    , target = Nothing
    , active = Nothing
    , defined = Nothing
    , others = []
    }


{-| -}
palettesByState : PalettesByState (ColorValue c) -> Style
palettesByState ps =
    let
        group_0 =
            case ps.selected of
                Just ( True, selected ) ->
                    palette selected

                _ ->
                    palette ps.default

        groups =
            [ -- Group 1
              Maybe.map (\p -> Css.link [ palette p ]) ps.link
            , Maybe.map (\p -> Css.visited [ palette p ]) ps.visited

            -- Group 2
            , Maybe.map (\p -> Css.hover [ palette p ]) ps.hover

            -- Group 3
            , Maybe.map (\p -> Css.pseudoClass "default" [ palette p ]) ps.default_
            , Maybe.map (\p -> Css.pseudoClass "focus-within" [ palette p ]) ps.focusWithin
            , Maybe.map (\p -> Css.focus [ palette p ]) ps.focus
            , Maybe.map (\p -> Css.pseudoClass "focus-visible" [ palette p ]) ps.focusVisible
            , Maybe.map (\p -> Css.checked [ palette p ]) ps.checked
            , Maybe.map (\p -> Css.disabled [ palette p ]) ps.disabled
            , Maybe.map (\p -> Css.enabled [ palette p ]) ps.enabled
            , Maybe.map (\p -> Css.pseudoClass "read-only" [ palette p ]) ps.readOnly
            , Maybe.map (\p -> Css.readWrite [ palette p ]) ps.readWrite
            , Maybe.map (\p -> Css.required [ palette p ]) ps.required
            , Maybe.map (\p -> Css.optional [ palette p ]) ps.optional
            , Maybe.map (\p -> Css.invalid [ palette p ]) ps.invalid
            , Maybe.map (\p -> Css.pseudoClass "user-invalid" [ palette p ]) ps.userInvalid
            , Maybe.map (\p -> Css.valid [ palette p ]) ps.valid
            , Maybe.map (\p -> Css.pseudoClass "user-valid" [ palette p ]) ps.userValid
            , Maybe.map (\p -> Css.pseudoClass "in-range" [ palette p ]) ps.inRange
            , Maybe.map (\p -> Css.outOfRange [ palette p ]) ps.outOfRange
            , Maybe.map (\p -> Css.indeterminate [ palette p ]) ps.indeterminate
            , Maybe.map (\p -> Css.pseudoClass "placeholder-shown" [ palette p ]) ps.placeholderShown
            , Maybe.map (\p -> Css.empty [ palette p ]) ps.empty
            , Maybe.map (\p -> Css.target [ palette p ]) ps.target

            -- Group 4
            , Maybe.map (\p -> Css.active [ palette p ]) ps.active
            , Maybe.map (\p -> Css.pseudoClass "defined" [ palette p ]) ps.defined
            ]
                |> List.filterMap identity

        group_5 =
            List.map (\( pseudoClass, p ) -> pseudoClass [ palette p ]) ps.others
    in
    (group_0 :: groups ++ group_5)
        |> Css.batch
