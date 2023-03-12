#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.14.1
 Auteur:         yann83 https://github.com/yann83

 #ce ----------------------------------------------------------------------------

; #FUNCTION# ====================================================================================================================
; Name ..........: _MeltingPot
; Description ...:
; Syntax ........: _MeltingPot( , )
; Parameters ....:
; Return values..:
; Author.........: Autoit
; Modified ......:
; Remarks .......: Random
;					Copyright (C) 1997 - 2002, Makoto Matsumoto and Takuji Nishimura, All rights reserved.
;					Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
;					1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
;					2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
;					3. The names of its contributors may not be used to endorse or promote products derived from this software without specific prior written permission.
;					THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
; Example........:
;
; ===============================================================================================================================
#include-once

Func _MeltingPot($HardwareID,$UserPasswordID)

	Local $HexUserPasswordID = _StringToHex($UserPasswordID) ; Convert the string to a hex string.

	Local $NEWID = $HardwareID & $HexUserPasswordID
	Local $MaxChr = StringLen($NEWID) ; ex 32 + 6 = 38
	Local $MaxRand = ($MaxChr - 32) + 1 ; ex 38 - 32 = 6
	Local $RandomStart = Random(1, $MaxRand, 1) ; ex chiffre au hazard compris entre 1 et 6 = 4

	$NEWID = StringMid($NEWID, $RandomStart, 32) ; ex extraction de l'ID à partir de la lettre 4 jusqu'à la 32ième lettre, de cette façon on depasse par 38 lettres

	Return($NEWID)

EndFunc   ;==>Example



