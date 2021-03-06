module HangmanViews exposing (characterButtonsView, gameButtonsView, hangmanArtView, hangmanPhraseView, phraseButtonsView, phraseInputView, titleView)

import Array
import Css exposing (alignItems, center, fontSize, lineHeight, padding4, pct, px, textAlign)
import HangmanHelpers exposing (addCharactersToSpan, coloredCharacterButton, hiddenPhraseString, hidePhraseCharacters, numIncorrectGuesses)
import HangmanSourceTexts exposing (alphabet, hangmanArtAlive, hangmanArtDead, longWords, mediumWords, sourceText)
import HangmanStyles exposing (styledButtonMain, styledGenerateButton, styledInput)
import HangmanTypes exposing (Model, Msg(..))
import Html.Styled exposing (Html, div, h1, pre, text)
import Html.Styled.Attributes exposing (css, id, type_, value)
import Html.Styled.Events exposing (onClick, onInput)
import HangmanSourceTexts exposing (firstKeyRow)
import HangmanSourceTexts exposing (secondKeyRow)
import HangmanSourceTexts exposing (thirdKeyRow)



-- html components


titleView : Html Msg
titleView =
    div
        [ css
            [ textAlign center
            , fontSize (px 18)
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


gameButtonsView : Html Msg
gameButtonsView =
    div
        [ css
            [ textAlign center
            , alignItems center
            , padding4 (px 2) (px 2) (px 2) (px 2)
            ]
        ]
        [ styledButtonMain
            [ type_ "button"
            , onClick Reset
            ]
            [ text "Reset Game" ]
        , styledButtonMain
            [ type_ "button"
            , onClick SaveHangmanPhrase
            ]
            [ text "Submit Phrase" ]
        , styledButtonMain
            [ type_ "button"
            , onClick RevealPhrase
            ]
            [ text "Reveal Phrase" ]
        ]


phraseButtonsView : Html Msg
phraseButtonsView =
    div
        [ css
            [ textAlign center
            , alignItems center
            , padding4 (px 2) (px 2) (px 2) (px 2)
            ]
        ]
        [ styledGenerateButton
            [ type_ "button"
            , onClick (GenerateRandomTextIndex sourceText 5)
            ]
            [ text "Randomly Generate Easy" ]
        , styledGenerateButton
            [ type_ "button"
            , onClick (GenerateRandomTextIndex sourceText 3)
            ]
            [ text "Randomly Generate Medium" ]
        , styledGenerateButton
            [ type_ "button"
            , onClick (GenerateRandomTextIndex longWords 1)
            ]
            [ text "Randomly Generate Hard" ]
        , styledGenerateButton
            [ type_ "button"
            , onClick (GenerateRandomTextIndex mediumWords 1)
            ]
            [ text "Randomly Generate Very Hard" ]
        ]


characterButtonsView : Model -> Html Msg
characterButtonsView model =
    div [] [
        firstKeyRow
        |> List.map (coloredCharacterButton model)
        |> div
            [ css
                [ textAlign center
                , alignItems center
                ]
            ]
        , secondKeyRow
        |> List.map (coloredCharacterButton model)
        |> div
            [ css
                [ textAlign center
                , alignItems center
                ]
            ]
        , thirdKeyRow
        |> List.map (coloredCharacterButton model)
        |> div
            [ css
                [ textAlign center
                , alignItems center
                ]
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
