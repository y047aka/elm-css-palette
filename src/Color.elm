module Color exposing
    ( Color
    , rgba, rgb, hsla, hsl, oklaba, oklab
    , toCssString
    )

{-|

@docs Color
@docs rgba, rgb, hsla, hsl, oklaba, oklab
@docs toCssString

-}


type Color
    = Rgba255 Float Float Float Float
    | Hsla360 Float Float Float Float
    | Oklab Float Float Float Float


rgba : Float -> Float -> Float -> Float -> Color
rgba r g b a =
    Rgba255 r g b a


rgb : Float -> Float -> Float -> Color
rgb r g b =
    rgba r g b 1.0


hsla : Float -> Float -> Float -> Float -> Color
hsla hue sat light alpha =
    Hsla360 hue sat light alpha


hsl : Float -> Float -> Float -> Color
hsl h s l =
    hsla h s l 1.0


oklaba : Float -> Float -> Float -> Float -> Color
oklaba l a b alpha =
    Oklab l a b alpha


oklab : Float -> Float -> Float -> Color
oklab l a b =
    oklaba l a b 1.0


toCssString : Color -> String
toCssString c =
    let
        pct x =
            ((x * 10000) |> round |> toFloat) / 100

        roundTo x =
            ((x * 1000) |> round |> toFloat) / 1000
    in
    case c of
        Rgba255 r g b a ->
            cssFunction "rgba"
                [ String.fromFloat (roundTo r)
                , String.fromFloat (roundTo g)
                , String.fromFloat (roundTo b)
                , String.fromFloat (roundTo a)
                ]

        Hsla360 h s l a ->
            cssFunction "hsla"
                [ String.fromFloat (roundTo h)
                , String.fromFloat (pct s) ++ "%"
                , String.fromFloat (pct l) ++ "%"
                , String.fromFloat (roundTo a)
                ]

        Oklab l a b alpha ->
            cssFunction "oklab"
                [ String.fromFloat (roundTo l)
                , String.fromFloat (roundTo a)
                , String.fromFloat (roundTo b)
                , String.fromFloat (roundTo alpha)
                ]


cssFunction : String -> List String -> String
cssFunction funcName args =
    funcName
        ++ "("
        ++ String.join "," args
        ++ ")"
