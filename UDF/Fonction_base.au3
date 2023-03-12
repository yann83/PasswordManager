#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.14.1
 Auteur:         yann83 https://github.com/yann83

 #ce ----------------------------------------------------------------------------

; #FUNCTION# ====================================================================================================================
; Name ..........: _BaseStartup
; Description ...:
; Syntax ........: _BaseStartup( )
; Parameters ....:
; Return values..:
; Author.........: Autoit
; Modified ......:
; Remarks .......:
; Example........:
;
; ===============================================================================================================================
#include-once
#include "Fonction_GetHardwareID.au3"
#include "Fonction_MasterPassword.au3"
#include "Fonction_Cryptage.au3"

Func _BaseStartup($UserFile,$UserFirstPassword,$SqlDLLPath)

	Local $dbFile = @ScriptDir & "\" & $UserFile
	Local $BaseNomProg = StringTrimRight(@ScriptName,4)
	Local $BaseManagerLogfile = @ScriptDir & "\" & $BaseNomProg & ".log"

	If FileExists($dbFile) = 0 Then

		Local $PCUniqueID = _GetHardwareID($UHID_All);master password
		local $PCMasterPassword = _MeltingPot($PCUniqueID,$UserFirstPassword)

		Local $CryptageMasterPassword = _StringEncryptDecrypt(True, $PCMasterPassword, $UserFirstPassword)

		Local $CryptageLogin = _StringEncryptDecrypt(True, "admin", $UserFirstPassword)
		Local $CryptagePassword = _StringEncryptDecrypt(True, $UserFirstPassword, $UserFirstPassword)

		Local $sSQliteDll = _SQLite_Startup($SqlDLLPath, True, 1)
		If @error Then
			_FileWriteLog($BaseManagerLogfile, "_BaseStartup : SQLite3.dll can't be loaded!")
			Exit -1
		EndIf

		If FileExists($dbFile) = 0 Then

			Local $hDskDb = _SQLite_Open($dbFile) ; Ouvre une base de données permanente
			If @error Then
				_FileWriteLog($BaseManagerLogfile,"_BaseStartup : can't open or create a permanent database!")
				Exit -1
			EndIf

			If Not _SQLite_Exec(-1, "CREATE TABLE manager (ID Integer PRIMARY KEY AUTOINCREMENT, NAME varchar(255) NOT NULL, PATH varchar(255), LOGIN varchar(255) NOT NULL,CODE varchar(255) NOT NULL);") = $SQLITE_OK Then _
				_FileWriteLog($BaseManagerLogfile, "_BaseStartup : CREATE TABLE manager error - " & _SQLite_ErrMsg())

			If Not _SQLite_Exec(-1, "CREATE TABLE access (ID Integer, LOGIN varchar(255) NOT NULL, CODE varchar(255) NOT NULL, MASTERPASSWORD varchar(255) NOT NULL);") = $SQLITE_OK Then _
				_FileWriteLog($BaseManagerLogfile, "_BaseStartup : CREATE TABLE access error - " & _SQLite_ErrMsg())

			If Not _SQLite_Exec(-1, "INSERT INTO access VALUES (1,'" & $CryptageLogin & "','" & $CryptagePassword & "','" & $CryptageMasterPassword & "');") = $SQLITE_OK Then _
				_FileWriteLog($BaseManagerLogfile, "_BaseStartup : INSERT INTO access error - " & _SQLite_ErrMsg())

			_SQLite_Close($hDskDb)

		EndIf

		_SQLite_Shutdown()

		$PCMasterPassword = ""
		$UserFirstPassword = ""

	Else

		_FileWriteLog($BaseManagerLogfile, "_BaseStartup : database " & $dbFile & " already exist.")

	EndIf

EndFunc   ;==>_BaseStartup
