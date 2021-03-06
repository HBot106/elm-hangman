module Hangman exposing (main)

import Browser exposing (element)
import Css exposing (..)
import HangmanColors exposing (textColor)
import HangmanHelpers exposing (getRandomPhrase)
import HangmanModels exposing (alterCharacterSet, alterInputField, init, initWithHangmanPhrase, querryRandomTextIndex, revealPhrase)
import HangmanStyles exposing (styledForm)
import HangmanTypes exposing (Model, Msg(..))
import HangmanViews exposing (characterButtonsView, gameButtonsView, hangmanArtView, hangmanPhraseView, phraseButtonsView, phraseInputView, titleView)
import Html.Styled exposing (Html, div, toUnstyled)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onSubmit)


view : Model -> Html Msg
view model =
    div
        [ css
            [ color (hex textColor)
            , fontFamily sansSerif
            ]
        ]
        [ styledForm [ onSubmit SaveHangmanPhrase ]
            [ titleView
            , phraseInputView model
            , gameButtonsView
            , phraseButtonsView
            , characterButtonsView model
            , hangmanPhraseView model
            , hangmanArtView model
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        SaveInputSoFar inputText ->
            alterInputField model inputText

        SaveHangmanPhrase ->
            initWithHangmanPhrase model.inputField

        GuessButton char ->
            alterCharacterSet model char

        GenerateRandomTextIndex text count ->
            querryRandomTextIndex model text count

        NewRandomTextIndex index ->
            initWithHangmanPhrase (getRandomPhrase index model.selectedWordCount model.selectedSourceText)

        RevealPhrase ->
            revealPhrase model

        Reset ->
            init ()


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view >> toUnstyled
        , update = update
        , subscriptions = \_ -> Sub.none
        }
