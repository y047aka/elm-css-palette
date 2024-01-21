module Color exposing
    ( Color
    , rgba, rgb, hsla, hsl, oklab
    , toCssString
    )

{-|

@docs Color
@docs rgba, rgb, hsla, hsl, oklab
@docs toCssString

-}


type Color
    = Rgba255 Float Float Float (Maybe Float)
    | Hsla360 Float Float Float (Maybe Float)
    | Oklab Float Float Float (Maybe Float)


rgba : Float -> Float -> Float -> Float -> Color
rgba r g b alpha =
    Rgba255 r g b (Just alpha)


rgb : Float -> Float -> Float -> Color
rgb r g b =
    Rgba255 r g b Nothing


hsla : Float -> Float -> Float -> Float -> Color
hsla h s l alpha =
    Hsla360 h s l (Just alpha)


hsl : Float -> Float -> Float -> Color
hsl h s l =
    Hsla360 h s l Nothing


oklab : Float -> Float -> Float -> Float -> Color
oklab l a b alpha =
    Oklab l a b (Just alpha)


toCssString : Color -> String
toCssString c =
    let
        pct x =
            ((x * 10000) |> round |> toFloat) / 100

        roundTo x =
            ((x * 1000) |> round |> toFloat) / 1000
    in
    case c of
        Rgba255 r g b alpha ->
            cssColorLevel4 "rgb"
                ( [ String.fromFloat (roundTo r)
                  , String.fromFloat (roundTo g)
                  , String.fromFloat (roundTo b)
                  ]
                , Maybe.map (roundTo >> String.fromFloat) alpha
                )

        Hsla360 h s l alpha ->
            cssColorLevel4 "hsl"
                ( [ String.fromFloat (roundTo h)
                  , String.fromFloat (pct s) ++ "%"
                  , String.fromFloat (pct l) ++ "%"
                  ]
                , Maybe.map (roundTo >> String.fromFloat) alpha
                )

        Oklab l a b alpha ->
            cssColorLevel4 "oklab"
                ( [ String.fromFloat (pct l) ++ "%"
                  , String.fromFloat (roundTo a)
                  , String.fromFloat (roundTo b)
                  ]
                , Maybe.map (roundTo >> String.fromFloat) alpha
                )


cssColorLevel4 : String -> ( List String, Maybe String ) -> String
cssColorLevel4 funcName ( args, maybeAlpha ) =
    let
        slashAndAplha =
            case maybeAlpha of
                Just a ->
                    [ "/", a ]

                Nothing ->
                    []
    in
    funcName
        ++ "("
        ++ String.join " " (args ++ slashAndAplha)
        ++ ")"
