#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.14.1
 Auteur:         yann83 https://github.com/yann83

 #ce ----------------------------------------------------------------------------
#include-once

Func _FileInstallFromResource($sResName, $sDest, $isCompressed = False, $iUncompressedSize = Default)
    Local $bBytes = _GetResourceAsBytes($sResName, $isCompressed, $iUncompressedSize)
    If @error Then Return SetError(@error, 0, 0)
    FileDelete($sDest)
    FileWrite($sDest, $bBytes)
EndFunc

Func _GetResourceAsBytes($sResName, $isCompressed = False, $iUncompressedSize = Default)

    Local $hMod = _WinAPI_GetModuleHandle(Null)
    Local $hRes = _WinAPI_FindResource($hMod, 10, $sResName)
    If @error Or Not $hRes Then Return SetError(1, 0, 0)
    Local $dSize = _WinAPI_SizeOfResource($hMod, $hRes)
    If @error Or Not $dSize Then Return SetError(2, 0, 0)
    Local $hLoad = _WinAPI_LoadResource($hMod, $hRes)
    If @error Or Not $hLoad Then Return SetError(3, 0, 0)
    Local $pData = _WinAPI_LockResource($hLoad)
    If @error Or Not $pData Then Return SetError(4, 0, 0)
    Local $tBuffer = DllStructCreate("byte[" & $dSize & "]")
    _WinAPI_MoveMemory(DllStructGetPtr($tBuffer), $pData, $dSize)
    If $isCompressed Then
        Local $oBuffer
       _WinAPI_LZNTDecompress($tBuffer, $oBuffer, $iUncompressedSize)
        If @error Then Return SetError(5, 0, 0)
        $tBuffer = $oBuffer
    EndIf
    Return DllStructGetData($tBuffer, 1)
EndFunc

Func _WinAPI_LZNTDecompress(ByRef $tInput, ByRef $tOutput, $iUncompressedSize = Default)
    ; if no uncompressed size given, use 16x the input buffer
    If $iUncompressedSize = Default Then $iUncompressedSize = 16 * DllStructGetSize($tInput)
    Local $tBuffer, $ret
    $tOutput = 0
    $tBuffer = DllStructCreate("byte[" & $iUncompressedSize & "]")
    If @error Then Return SetError(1, 0, 0)
    $ret = DllCall("ntdll.dll", "long", "RtlDecompressBuffer", "ushort", 2, "struct*", $tBuffer, "ulong", $iUncompressedSize, "struct*", $tInput, "ulong", DllStructGetSize($tInput), "ulong*", 0)
    If @error Then Return SetError(2, 0, 0)
    If $ret[0] Then Return SetError(3, $ret[0], 0)
    $tOutput = DllStructCreate("byte[" & $ret[6] & "]")
    If Not _WinAPI_MoveMemory(DllStructGetPtr($tOutput), DllStructGetPtr($tBuffer), $ret[6]) Then
        $tOutput = 0
        Return SetError(4, 0, 0)
    EndIf
    Return $ret[6]
EndFunc
