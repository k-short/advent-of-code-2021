module DayOne exposing (output)

import Json.Encode as Encode


output : List Int -> Encode.Value
output numbers =
    Encode.object
        [ ( "part-1", Encode.int (solvePart1 numbers) )
        , ( "part-2", Encode.int (solvePart2 numbers) )
        ]


solvePart1 : List Int -> Int
solvePart1 numbers =
    case numbers of
        x :: xs ->
            calculateNumIncreases 0 x xs

        _ ->
            0


calculateNumIncreases : Int -> Int -> List Int -> Int
calculateNumIncreases total prev numbers =
    case numbers of
        x :: xs ->
            if x > prev then
                calculateNumIncreases (total + 1) x xs

            else
                calculateNumIncreases total x xs

        _ ->
            total


solvePart2 : List Int -> Int
solvePart2 numbers =
    case numbers of
        x1 :: x2 :: x3 :: xs ->
            calculateNumWindowIncreases 0 (x1 + x2 + x3) (x2 :: x3 :: xs)

        _ ->
            0


calculateNumWindowIncreases : Int -> Int -> List Int -> Int
calculateNumWindowIncreases total prev numbers =
    case numbers of
        x1 :: x2 :: x3 :: xs ->
            let
                windowTotal =
                    x1 + x2 + x3
            in
            if windowTotal > prev then
                calculateNumWindowIncreases (total + 1) windowTotal (x2 :: x3 :: xs)

            else
                calculateNumWindowIncreases total windowTotal (x2 :: x3 :: xs)

        _ ->
            total
