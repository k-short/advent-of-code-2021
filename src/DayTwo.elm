module DayTwo exposing (output)

import Json.Encode as Encode


type Depth
    = Depth Int


type Horizontal
    = Horizontal Int


type Aim
    = Aim Int


type Position
    = Position Depth Horizontal


type PositionWithAim
    = PositionWithAim Depth Horizontal Aim


output : List String -> Encode.Value
output commands =
    Encode.object
        [ ( "part-1", Encode.int (solvePart1 commands) )
        , ( "part-2", Encode.int (solvePart2 commands) )
        ]


solvePart1 : List String -> Int
solvePart1 =
    List.foldl applyCommand (Position (Depth 0) (Horizontal 0)) >> multiplyPosition


applyCommand : String -> Position -> Position
applyCommand command (Position (Depth depth) (Horizontal horizontal)) =
    let
        parts =
            String.split " " command
    in
    case parts of
        "forward" :: value :: [] ->
            Position (Depth depth) (Horizontal (horizontal + getValue value))

        "down" :: value :: [] ->
            Position (Depth (depth + getValue value)) (Horizontal horizontal)

        "up" :: value :: [] ->
            Position (Depth (depth - getValue value)) (Horizontal horizontal)

        _ ->
            Position (Depth depth) (Horizontal horizontal)


solvePart2 : List String -> Int
solvePart2 =
    List.foldl applyAimCommand (PositionWithAim (Depth 0) (Horizontal 0) (Aim 0)) >> multiplyPositionWithAim


applyAimCommand : String -> PositionWithAim -> PositionWithAim
applyAimCommand command (PositionWithAim (Depth depth) (Horizontal horizontal) (Aim aim)) =
    let
        parts =
            String.split " " command
    in
    case parts of
        "forward" :: value :: [] ->
            PositionWithAim (Depth (depth + (aim * getValue value))) (Horizontal (horizontal + getValue value)) (Aim aim)

        "down" :: value :: [] ->
            PositionWithAim (Depth depth) (Horizontal horizontal) (Aim (aim + getValue value))

        "up" :: value :: [] ->
            PositionWithAim (Depth depth) (Horizontal horizontal) (Aim (aim - getValue value))

        _ ->
            PositionWithAim (Depth depth) (Horizontal horizontal) (Aim aim)


getValue : String -> Int
getValue stringValue =
    Maybe.withDefault 0 (String.toInt stringValue)


multiplyPosition : Position -> Int
multiplyPosition (Position (Depth depth) (Horizontal horizontal)) =
    depth * horizontal


multiplyPositionWithAim : PositionWithAim -> Int
multiplyPositionWithAim (PositionWithAim (Depth depth) (Horizontal horizontal) aim) =
    depth * horizontal
