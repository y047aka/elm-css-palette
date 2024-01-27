# elm-css-palette

```elm
light : Palette Hsl360
light =
    { background = Just (hsl 0 0 1)
    , color = Just (hsl 0 0 0.4)
    , border = Just (hsl 0 0 0.7)
    }


dark : Palette Hsl360
dark =
    { background = Just (hsl 0 0 0.2)
    , color = Just (hsl 0 0 0.9)
    , border = Just (hsl 0 0 0.6)
    }


primaryButton : Palette Hsl360
primaryButton =
    { background = Just (hsl 210 1 0.5)
    , color = Just (hsl 0 0 1)
    , border = Just (hsl 210 1 0.6)
    }


secondaryButton : Palette Hsl360
secondaryButton =
    { primaryButton
        | background = primaryButton.color
        , color = primaryButton.background
        , border = Just (hsl 210 1 0.6)
    }
```
