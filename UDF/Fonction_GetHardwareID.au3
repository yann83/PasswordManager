#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.14.1
 Auteur:         yann83 https://github.com/yann83

 #ce ----------------------------------------------------------------------------

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetHardwareID
; Description ...: Generates a unique hardware identifier (ID) for the local computer.
; Syntax ........: _GetHardwareID([$iFlags = Default])
; Parameters ....: $iFlags   - [optional] The flags that specifies what information would be used to generate ID.
;                            This parameter can be one or more of the following values.
;
;                            $UHID_MB (0)
;                            Uses information about your motherboard. This flag is used by default regardless of whether specified or not.
;
;                            $UHID_BIOS (1)
;                            Uses information about the BIOS.
;
;                            $UHID_CPU (2)
;                            Uses information about the processor(s).
;
;                            $UHID_HDD (4)
;                            Uses information about the installed hard drives. Any change in the configuration disks will change ID
;                            returned by this function. Taken into account only non-removable disks.
;
;                            $UHID_All (7)
;                            The sum of all the previous flags. Default is $UHID_MB (0).
;
;                  $fIs64Bit            - [optional] Search the 64-bit section of the registry. Default is dependant on AutoIt bit version.
;                            Note: 64-bit can't be searched when running the 32-bit version of AutoIt.
; Return values..: Success - The string representation of the ID. @extended returns the value that contains a combination of flags
;                            specified in the $iFlags parameter. If flag is set, appropriate information is received successfully,
;                            otherwise fails. The function checks only flags that were specified in the $iFlags parameter.
;                  Failure - Empty string and sets @error to non-zero.
; Author.........: guinness with the idea by Yashied (_WinAPI_UniqueHardwareID() - WinAPIDiag.au3)
; Modified ......: Additional suggestions by SmOke_N.
; Remarks .......: The constants above can be found in APIDiagConstant.au3. It also requires StringConstants.au3 and Crypt.au3 to be included.
; Example........: Yes
; URL............: https://www.autoitscript.com/forum/topic/146724-_gethardwareid-generates-a-unique-hardware-identifier-id-for-the-local-computer/?do=findComment&comment=1039064
; ===============================================================================================================================
#include-once

Func _GetHardwareID($iFlags = Default, $fIs64Bit = Default)
    Local $sBit = ''
    If @AutoItX64 Then
        $sBit = '64'
    EndIf
    If Not ($fIs64Bit = Default) Then
        $sBit = '' ; Reset to 32-bit.
        If $fIs64Bit And @AutoItX64 Then
            $sBit = '64' ; Use 64-bit if $fIs64Bit is True and AutoIt is a 64-bit process.
        EndIf
    EndIf

    If $iFlags = Default Then
        $iFlags = $UHID_MB
    EndIf
    Local $aSystem = ['Identifier', 'VideoBiosDate', 'VideoBiosVersion'], _
            $iResult = 0, _
            $sHKLM = 'HKEY_LOCAL_MACHINE' & $sBit, $sOutput = '', $sText = ''

    For $i = 0 To UBound($aSystem) - 1
        $sOutput &= RegRead($sHKLM & '\HARDWARE\DESCRIPTION\System\', $aSystem[$i])
    Next
    $sOutput &= @CPUArch
    $sOutput = StringStripWS($sOutput, $STR_STRIPALL)

    If BitAND($iFlags, $UHID_BIOS) Then
        Local $aBIOS = ['BaseBoardManufacturer', 'BaseBoardProduct', 'BaseBoardVersion', 'BIOSVendor', 'BIOSReleaseDate']
        $sText = ''
        For $i = 0 To UBound($aBIOS) - 1
            $sText &= RegRead($sHKLM & '\HARDWARE\DESCRIPTION\System\BIOS\', $aBIOS[$i])
        Next
        $sText = StringStripWS($sText, $STR_STRIPALL)
        If $sText Then
            $iResult += $UHID_BIOS
            $sOutput &= $sText
        EndIf
    EndIf
    If BitAND($iFlags, $UHID_CPU) Then
        Local $aProcessor = ['ProcessorNameString', '~MHz', 'Identifier', 'VendorIdentifier']
        $sText = ''
        For $i = 0 To UBound($aProcessor) - 1
            $sText &= RegRead($sHKLM & '\HARDWARE\DESCRIPTION\System\CentralProcessor\0\', $aProcessor[$i])
        Next
        For $i = 0 To UBound($aProcessor) - 1
            $sText &= RegRead($sHKLM & '\HARDWARE\DESCRIPTION\System\CentralProcessor\1\', $aProcessor[$i])
        Next
        $sText = StringStripWS($sText, $STR_STRIPALL)
        If $sText Then
            $iResult += $UHID_CPU
            $sOutput &= $sText
        EndIf
    EndIf
    If BitAND($iFlags, $UHID_HDD) Then
        $sText = ''
        Local $aDrives = DriveGetDrive('FIXED')
        If @error = 0 Then
            For $i = 1 To $aDrives[0]
                $sText &= DriveGetSerial($aDrives[$i])
            Next
        EndIf
        $sText = StringStripWS($sText, $STR_STRIPALL)
        If $sText Then
            $iResult += $UHID_HDD
            $sOutput &= $sText
        EndIf
    EndIf
    Local $sHash = StringTrimLeft(_Crypt_HashData($sOutput, $CALG_MD5), StringLen('0x'))
    If $sHash = '' Then
        Return SetError(4, 0, '')
    EndIf
    Return SetExtended($iResult, StringRegExpReplace($sHash, '([[:xdigit:]]{8})([[:xdigit:]]{4})([[:xdigit:]]{4})([[:xdigit:]]{4})([[:xdigit:]]{12})', '\1\2\3\4\5'))
EndFunc   ;==>_GetHardwareID
