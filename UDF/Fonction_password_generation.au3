#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.14.1
 Auteur:         yann83 https://github.com/yann83

 #ce ----------------------------------------------------------------------------

; #FUNCTION# ====================================================================================================================
; Name ..........: _GeneratePassword
; Description ...:
; Syntax ........: _GeneratePassword( , )
; Parameters ....:
; Return values..:
; Author.........: Autoit
; Modified ......:
; Remarks .......:
; Example........:
; ===============================================================================================================================
#include-once

Func RandomPassword($Length, $Fmt = 0)
    Local $buff
    Local $i
    Local $n

    Local Const $Alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    Local Const $ADigits = "0123456789"
    Local Const $Special = "!#$%&'()*+,-./:;<=>?@[\]^_`{|}~"
    ;Password include file
    Local $pwsMask = ""

    ;Do password formatting
    Select
        Case $Fmt = 0
            $pwsMask = $Alpha
        Case $Fmt = 1
            $pwsMask = StringLower($Alpha)
        Case $Fmt = 2
            $pwsMask = $ADigits
        Case $Fmt = 3
            $pwsMask = $Alpha & StringLower($Alpha) & $ADigits
        Case $Fmt
            $pwsMask = $Alpha & StringLower($Alpha) & $ADigits & $Special
    EndSelect

    ;This creates the random password.
    For $i = 1 To $Length
        ;Pick a random chat between 1 and the pwsMask Length
        $n = Int(Random(1, StringLen($pwsMask)))
        ;Concat each chat that has been picked out of pwsMask to $buff
        $buff = $buff & StringMid($pwsMask, $n, 1)
    Next
    Return $buff
EndFunc   ;==>RandomPassword
