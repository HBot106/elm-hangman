module HangmanViews exposing (characterButtonsView, hangmanArtView, hangmanPhraseView, mainButtonsView, phraseInputView, titleView)

import Array
import Css exposing (alignItems, center, fontSize, lineHeight, padding4, pct, px, textAlign)
import HangmanHelpers exposing (addCharactersToSpan, coloredCharacterButton, hiddenPhraseString, hidePhraseCharacters, numIncorrectGuesses)
import HangmanTypes exposing (Model, Msg(..))
import HangmanSourceTexts exposing (alphabet, hangmanArtAlive, hangmanArtDead)
import HangmanStyles exposing (styledButtonMain, styledInput)
import Html.Styled exposing (Html, div, h1, pre, text)
import Html.Styled.Attributes exposing (css, id, type_, value)
import Html.Styled.Events exposing (onClick, onInput)



-- html components


titleView : Html Msg
titleView =
    div
        [ css
            [ textAlign center
            , fontSize (px 32)
            ]
        ]
        [ h1 [] [ text "Hangman Game" ] ]


phraseInputView : Model -> Html Msg
phraseInputView model =
    div
        [ css
            [ textAlign center
            , alignItems center
            ]
        ]
        [ div [ css [ fontSize (px 24) ] ] [ text "Input Phrase" ]
        , styledInput
            [ id "input"
            , type_ "text"
            , onInput SaveInputSoFar
            , value model.inputField
            ]
            []
        ]


mainButtonsView : Html Msg
mainButtonsView =
    div
        [ css
            [ textAlign center
            , alignItems center
            , padding4 (px 2) (px 2) (px 2) (px 2)
            ]
        ]
        [ styledButtonMain
            [ type_ "button"
            , onClick GenerateRandomTextIndex
            ]
            [ text "Random Phrase" ]
        , styledButtonMain
            [ type_ "button"
            , onClick SaveHangmanPhrase
            ]
            [ text "Submit Phrase" ]
        , styledButtonMain
            [ type_ "button"
            , onClick Reset
            ]
            [ text "Reset Game" ]
        ]


characterButtonsView : Model -> Html Msg
characterButtonsView model =
    alphabet
        |> List.map (coloredCharacterButton model)
        |> div
            [ css
                [ textAlign center
                , alignItems center
                ]
            ]


hangmanPhraseView : Model -> Html Msg
hangmanPhraseView model =
    model.hangmanPhrase
        |> String.split ""
        |> List.map (hidePhraseCharacters model)
        |> List.map addCharactersToSpan
        |> div
            [ css
                [ textAlign center
                , alignItems center
                ]
            ]


hangmanArtView : Model -> Html Msg
hangmanArtView model =
    case Array.get (numIncorrectGuesses model) hangmanArtAlive of
        Nothing ->
            div [] deadHangmanHtml

        Just hangmanAscii ->
            if String.contains "_" (hiddenPhraseString model) then
                div [] (livingHangmanHtml hangmanAscii)

            else if "\u{00A0}\u{00A0}\u{00A0}" == hiddenPhraseString model then
                div [] (initialHangmanHtml hangmanAscii)

            else
                div [] (winningHangmanHtml hangmanAscii)


initialHangmanHtml : String -> List (Html Msg)
initialHangmanHtml asciiArt =
    [ Html.Styled.pre
        [ css
            [ textAlign center
            , alignItems center
            , fontSize (px 32)
            , lineHeight (pct 50)
            ]
        ]
        [ text asciiArt ]
    , Html.Styled.pre
        [ css
            [ textAlign center
            , alignItems center
            , fontSize (px 32)
            , lineHeight (pct 50)
            ]
        ]
        [ text "Choose Phrase" ]
    ]


winningHangmanHtml : String -> List (Html Msg)
winningHangmanHtml asciiArt =
    [ Html.Styled.pre
        [ css
            [ textAlign center
            , alignItems center
            , fontSize (px 32)
            , lineHeight (pct 50)
            ]
        ]
        [ text asciiArt ]
    , Html.Styled.pre
        [ css
            [ textAlign center
            , alignItems center
            , fontSize (px 32)
            , lineHeight (pct 50)
            ]
        ]
        [ text "You Win!" ]
    ]


livingHangmanHtml : String -> List (Html Msg)
livingHangmanHtml asciiArt =
    [ Html.Styled.pre
        [ css
            [ textAlign center
            , alignItems center
            , fontSize (px 32)
            , lineHeight (pct 50)
            ]
        ]
        [ text asciiArt ]
    , Html.Styled.pre
        [ css
            [ textAlign center
            , alignItems center
            , fontSize (px 32)
            , lineHeight (pct 50)
            ]
        ]
        [ text "Keep Playing" ]
    ]


deadHangmanHtml : List (Html Msg)
deadHangmanHtml =
    [ Html.Styled.pre
        [ css
            [ textAlign center
            , alignItems center
            , fontSize (px 32)
            , lineHeight (pct 50)
            ]
        ]
        [ text hangmanArtDead ]
    , Html.Styled.pre
        [ css
            [ textAlign center
            , alignItems center
            , fontSize (px 32)
            , lineHeight (pct 50)
            ]
        ]
        [ text "You Lose!" ]
    ]