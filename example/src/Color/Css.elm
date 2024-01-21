module Color.Css exposing (backgroundColor, border3)

import Color exposing (Color, toCssString)
import Css exposing (BorderStyle, Length, Style, Value, property)


backgroundColor : Color -> Style
backgroundColor c =
    property "background-color" (Color.toCssString c)


border3 : Length compatibleA unitsA -> BorderStyle compatibleB -> Color -> Style
border3 =
    prop3 "border"


prop3 : String -> Value a -> Value b -> Color -> Style
prop3 key argA argB argC =
    property key (argA.value ++ " " ++ argB.value ++ " " ++ toCssString argC)
