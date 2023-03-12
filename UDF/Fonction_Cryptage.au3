#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.14.1
 Auteur:         yann83 https://github.com/yann83

 #ce ----------------------------------------------------------------------------

; #FUNCTION# ====================================================================================================================
; Name ..........: _StringEncryptDecrypt
; Description ...:
; Syntax ........: _StringEncryptDecrypt( , , )
; Parameters ....:
; Return values..:
; Author.........: Autoit
; Modified ......:
; Remarks .......:
; Example........:
; ===============================================================================================================================
#include-once

Func _StringEncryptDecrypt($bEncrypt, $sData, $sPassword)
    _Crypt_Startup()
    Local $sReturn = ''
    If $bEncrypt Then ; Si $bEncrypt = True on encrypte si c'est False on decrypte
        $sReturn = _Crypt_EncryptData($sData, $sPassword, $CALG_AES_256)
	Else
        $sReturn = BinaryToString(_Crypt_DecryptData($sData, $sPassword, $CALG_AES_256))
    EndIf
    _Crypt_Shutdown()
    Return $sReturn
EndFunc   ;==>StringEncryptDecrypt
