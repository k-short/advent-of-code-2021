port module Main exposing (Day, main)

import DayOne
import DayTwo
import Json.Decode as Decode
import Json.Encode
import Platform exposing (Program)


port get : (Json.Encode.Value -> msg) -> Sub msg


port put : Json.Encode.Value -> Cmd msg


main : Program Flags Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    ()


type Msg
    = Input (Result Decode.Error Day)


type alias Flags =
    ()


type Day
    = DayOne (List Int)
    | DayTwo (List String)


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( (), Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input input ->
            case input of
                Ok value ->
                    case value of
                        DayOne data ->
                            ( model, put (DayOne.output data) )

                        DayTwo data ->
                            ( model, put (DayTwo.output data) )

                Err _ ->
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    get (Decode.decodeValue dayDecoder >> Input)



-- Day input decoding to determine what day we're processing


dayDecoder : Decode.Decoder Day
dayDecoder =
    tagDecoder
        |> Decode.andThen getDayFromTag


tagDecoder : Decode.Decoder String
tagDecoder =
    Decode.field "tag" Decode.string


getDayFromTag : String -> Decode.Decoder Day
getDayFromTag tag =
    case tag of
        "day-1" ->
            dayOneDecoder

        "day-2" ->
            dayTwoDecoder

        _ ->
            Decode.fail ("Invalid tag: " ++ tag)



-- Day one decoding


dayOneDecoder : Decode.Decoder Day
dayOneDecoder =
    Decode.map DayOne dayOneInputDecoder


dayOneInputDecoder : Decode.Decoder (List Int)
dayOneInputDecoder =
    Decode.field "input" (Decode.list Decode.int)



-- Day two decoding


dayTwoDecoder : Decode.Decoder Day
dayTwoDecoder =
    Decode.map DayTwo dayTwoInputDecoder


dayTwoInputDecoder : Decode.Decoder (List String)
dayTwoInputDecoder =
    Decode.field "input" (Decode.list Decode.string)
