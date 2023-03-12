#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=ICO\PW.ico
#AutoIt3Wrapper_Outfile=Password_Manager.exe
#AutoIt3Wrapper_Outfile_x64=Password_Manager_x64.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Res_Description=Password Manager
#AutoIt3Wrapper_Res_Fileversion=1.5
#AutoIt3Wrapper_Res_ProductName=Password Manager
#AutoIt3Wrapper_Res_ProductVersion=1.5
#AutoIt3Wrapper_Res_CompanyName=https://github.com/yann83
#AutoIt3Wrapper_Res_LegalCopyright=MIT licence
#AutoIt3Wrapper_Res_Language=1036
#AutoIt3Wrapper_Res_File_Add=.\Resources\sqlite3_x32.dll, RT_RCDATA, SQLITEX32
#AutoIt3Wrapper_Res_File_Add=.\Resources\sqlite3_x64.dll, RT_RCDATA, SQLITEX64
#AutoIt3Wrapper_Res_File_Add=.\Resources\licence.html, RT_RCDATA, LICENCE
#AutoIt3Wrapper_Res_File_Add=Resources\certif.png, RT_RCDATA, CERTIF, 0
#AutoIt3Wrapper_Res_File_Add=Resources\database.png, RT_RCDATA, OPEN, 0
#AutoIt3Wrapper_Res_File_Add=Resources\user.png, RT_RCDATA, USER, 0
#AutoIt3Wrapper_Res_File_Add=Resources\pass.png, RT_RCDATA, PASS, 0
#AutoIt3Wrapper_Res_File_Add=Resources\valid.png, RT_RCDATA, VALID, 0
#AutoIt3Wrapper_Res_File_Add=Resources\eye.png, RT_RCDATA, EYE, 0
#AutoIt3Wrapper_Res_File_Add=Resources\add.png, RT_RCDATA, ADD, 0
#AutoIt3Wrapper_Res_File_Add=Resources\mod.png, RT_RCDATA, MOD, 0
#AutoIt3Wrapper_Res_File_Add=Resources\del.png, RT_RCDATA, DEL, 0
#AutoIt3Wrapper_Res_File_Add=Resources\view.png, RT_RCDATA, VIEW, 0
#AutoIt3Wrapper_Res_File_Add=Resources\az.png, RT_RCDATA, AZ, 0
#AutoIt3Wrapper_Res_File_Add=Resources\za.png, RT_RCDATA, ZA, 0
#AutoIt3Wrapper_Res_File_Add=Resources\calc.png, RT_RCDATA, CALC, 0
#AutoIt3Wrapper_Res_File_Add=Resources\go.png, RT_RCDATA, GO, 0
#AutoIt3Wrapper_Res_File_Add=Resources\copy.png, RT_RCDATA, COPY, 0
#AutoIt3Wrapper_Res_File_Add=Resources\gen.png, RT_RCDATA, GEN, 0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.14.1
 Auteur:         yann83

 Fonction du Script :
	Generateur et coffre fort de mots de passe

; Note : passage en UTF8 via Fichier > encodage

; Le mot de passe Master est unique et ne change jamais
; Le mot de passe Master sert à crypter toutes les entrées
: Le mot de passe principale crypt le mot de passe Master, le login et lui-même
; Si on change le mot de passe principal il recrypte ses trois entrées
; Quand on decrypte une entrée le mot de passe principale decrypte le Master qui ensuite va decrypter l'entrée

Copyright (c) 2023 https://github.com/yann83
Licence Free MIT

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the « Software »), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED « AS IS », WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE

#ce ----------------------------------------------------------------------------
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GUIListBox.au3>
#include <GuiListView.au3>
#include <GuiComboBox.au3>
#include <GuiEdit.au3>

#include <APIDiagConstants.au3>
#include <Crypt.au3>
#include <StringConstants.au3>
#include <String.au3>
#include <Array.au3>
#include <Clipboard.au3>

#include <SQLite.dll.au3>
#include <SQLite.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>

#include <IE.au3>

#include <WinAPIRes.au3>
#include <WinAPIInternals.au3>

#include ".\UDF\Fonction_base.au3"
#include ".\UDF\Fonction_Cryptage.au3"
#include ".\UDF\Fonction_password_generation.au3"
#include ".\UDF\Fonction_FileInstall.au3"
#include ".\UDF\Fonction_Regex.au3"
#include ".\UDF\ResourcesEx.au3"
#include ".\UDF\Toast.au3"
Opt("GUIOnEventMode", 1);important pour gérer les fonctions et les gui

Global $ProgramVersion = "1.5.0"

;########################## Global GUI ###########################
Global $GUI1
Global $GUI1_Label1, $GUI1_Label2, $GUI1_Label3
Global $GUI1_Input1, $GUI1_Input2
Global $GUI1_Bouton1, $GUI1_Bouton2, $GUI1_Bouton3
Global $GUI1_Checkbox1
Global $GUI1_Pic1, $GUI1_Pic2
Global $GUI1_Group1

Global $GUI2 = 9999
Global $GUI2_Label1 = 9999, $GUI2_Label2 = 9999, $GUI2_Label3 = 9999
Global $GUI2_Input1 = 9999, $GUI2_Input2 = 9999, $GUI2_Input3 = 9999
Global $GUI2_Bouton1 = 9999
Global $GUI2_Checkbox1 = 9999
Global $GUI2_Pic1 = 9999

Global $GUI3 = 9998, $GUI3_Input1 = 9998, $GUI3_Label1 = 9998, $GUI3_Bouton1 = 9998

Global $GUI4 = 9997
Global $GUI4_List1 = 9997,$GUI4_ListViewHandle = 9997
Global $GUI4_Edit = 9997,$GUI4_EditHandle = 9997,$GUI4_Editsearch = 9997
Global $GUI4_Bouton1 = 9997, $GUI4_Bouton2 = 9997, $GUI4_Bouton3 = 9997, $GUI4_Bouton4 = 9997, $GUI4_Bouton5 = 9997, $GUI4_Bouton6 = 9997, $GUI4_Bouton7 = 9997

Global $GUI5 = 9996
Global $GUI5_Input1 = 9996, $GUI5_Input2 = 9996, $GUI5_Input3 = 9996, $GUI5_Input4 = 9996, $GUI5_Input5 = 9996
Global $GUI5_Label1 = 9996, $GUI5_Label2 = 9996, $GUI5_Label3 = 9996, $GUI5_Label4 = 9996, $GUI5_Label5 = 9996
Global $GUI5_Bouton1 = 9996

Global $GUI6 = 9995
Global $GUI6_Label1 = 9995, $GUI6_Label2 = 9995, $GUI6_Label3 = 9995, $GUI6_Label4 = 9995
Global $GUI6_Input1 = 9995, $GUI6_Input2 = 9995, $GUI6_Input3 = 9995, $GUI6_Input4 = 9995
Global $GUI6_Bouton1 = 9995
Global $GUI6_Checkbox1 = 9995
Global $GUI6_Pic1 = 9995

Global $GUI7 = 9994
Global $GUI7_Label1 = 9994,	$GUI7_Label2 = 9994, $GUI7_Label3 = 9994, $GUI7_Label4 = 9994
Global $GUI7_Input1 = 9994,	$GUI7_Input2 = 9994, $GUI7_Input3 = 9994, $GUI7_Input4 = 9994
Global $GUI7_Bouton1 = 9994, $GUI7_Bouton2 = 9994, $GUI7_Bouton3 = 9994
Global $GUI7_Checkbox1 = 9994
Global $GUI7_Pic1 = 9994

Global $GUI8 = 9993
Global $GUI8_Label1 = 9993, $GUI8_Label2 = 9993, $GUI8_Label3 = 9993, $GUI8_Label4 = 9993
Global $GUI8_Input1 = 9993,	$GUI8_Input2 = 9993
Global $GUI8_Edit1 = 9993
Global $GUI8_Bouton1 = 9993, $GUI8_Bouton2 = 9993
Global $GUI8_Combo1 = 9993

Global $GUI9 = 9992

Global $aPos[4] = [0,0,0,0]
;################################################################

;############### BDD CREATION PART ##############################
Global $Arch64 = @AutoItX64
Global $ret
Global $sLocalSQLiteDll
Global $AutoBackup
Global $TypeArchSQL

Global $NomProg = StringTrimRight(@ScriptName,4)
Global $SQLiniPath = @ScriptDir & "\" & $NomProg & ".ini"
Global $ManagerLogfile = @ScriptDir & "\" & $NomProg & ".log"
Global $Licence = @ScriptDir & "\licence.html"

If $Arch64 = 1 Then
	$AutoBackup = @ScriptDir&"\PWAutoBackup_x64.exe"
	$TypeArchSQL = "SQLITEX64"
	$sLocalSQLiteDll = @ScriptDir & "\sqlite3_x64.dll"
Else
	$AutoBackup = @ScriptDir&"\PWAutoBackup.exe"
	$TypeArchSQL = "SQLITEX32"
	$sLocalSQLiteDll = @ScriptDir & "\sqlite3_x32.dll"
EndIf

Global $FileSqlName,$FileSQLPath, $PasswdPAL, $PwdCheckcomplexity

Global $InputPasswordPhrase = "Entrez votre mot de passe principal." & @CRLF & _
								"Il doit contenir un chiffre." & @CRLF & _
								"Il doit contenir une majuscule." & @CRLF & _
								"Il doit être long d'au moins 20 caractères."

Global $LoginHint = IniRead($SQLiniPath,"Hint","Login","Modifiez le fichier ini")
Global $PasswordHint = IniRead($SQLiniPath,"Hint","Password","Modifiez le fichier ini")


If @Compiled Then
	$ret = _FileInstallFromResource("LICENCE",$Licence)
	If @error Then
		_FileWriteLog($ManagerLogfile,"_FileInstallFromResource : licence.html Error : " & @error)
		Exit
	EndIf
EndIf

If @Compiled Then
	$ret = _FileInstallFromResource($TypeArchSQL,$sLocalSQLiteDll)
	If @error Then
		_FileWriteLog($ManagerLogfile,"_FileInstallFromResource sqlite dll Error : " & @error)
		Exit
	EndIf
EndIf

If FileExists($SQLiniPath) = 0 Then

	$FileSqlName = InputBox("Base de données", "Entrez le nom de la base de données :", "", "", 190, 140)
	If @error = "1" Then
		Exit
	EndIf

	$PwdCheckcomplexity = 0
	While $PwdCheckcomplexity <> 1
		$PasswdPAL = InputBox("Mot de Passe", $InputPasswordPhrase, "", "*", 250, 170)
		If @error = "1" Then
			Exit
		EndIf
		$PwdCheckcomplexity = _PwdCheckComplexity($PasswdPAL)
		If $PwdCheckcomplexity = 0 Then
			Local $PwdMsgBox = MsgBox(16,"Erreur","Le mot de passe ne correspond pas à la régle de validation..")
			If $PwdMsgBox = 2 Then
				Exit
			EndIf
		EndIf
	WEnd

	IniWrite($SQLiniPath,"PATH","DBName",$FileSqlName)
	IniWrite($SQLiniPath,"Hint","Login","Modifiez le fichier ini")
	IniWrite($SQLiniPath,"Hint","Password","Modifiez le fichier ini")

	_BaseStartup($FileSqlName,$PasswdPAL,$sLocalSQLiteDll)

	$PasswdPAL = ""
	$FileSQLPath = @ScriptDir & "\" & $FileSqlName
Else
	$FileSqlName = IniRead($SQLiniPath,"PATH","DBName","")
	$FileSQLPath = @ScriptDir & "\" & $FileSqlName
EndIf
;################################################################

;#################### Initialization SQL #########################
Global $sSQliteDll = _SQLite_Startup($sLocalSQLiteDll, True, 1)
If @error Then
	_FileWriteLog($ManagerLogfile, "_SQLite_Startup : sqlite3_x??.dll can't be loaded!")
	Exit -1
EndIf

Global $OpenDb = _SQLite_Open($FileSQLPath)
If @error Then
	_FileWriteLog($ManagerLogfile,"_SQLite_Open : can't open or create a permanent database!")
	Exit -1
EndIf
;#################################################################

;######################## Variables du core ######################
Global $MyQuery, $MyQueryRow
Global $TempDataEncryptage, $TempDataDecryptage
Global $Input1_Read, $Input2_Read, $Input3_Read, $Input4_Read, $Input5_Read
Global $aSQLResult, $iRows, $iColumns, $iRval
Global $Nb_Rows, $aSearch_Rows, $aSearch
Global $GUI4_List1_Indice, $GUI4_List1_Item, $GUI4_List1_Check
Global $pCount, $LineCount, $len, $i, $RetBuff,$PwsFmt
;#################################################################
;Calcul de la position précédente
Global $GUI4x,$GUI4y
Global $RegistreKey = "HKCU\Software\PasswordManager"
$GUI4x = RegRead($RegistreKey,"GUI4X")
If @error Then RegWrite($RegistreKey,"GUI4X","REG_SZ","-1")
$GUI4y = RegRead($RegistreKey,"GUI4Y")
If @error Then RegWrite($RegistreKey,"GUI4Y","REG_SZ","-1")
$GUI4x = Number(RegRead($RegistreKey,"GUI4X"))
$GUI4y = Number(RegRead($RegistreKey,"GUI4Y"))
;#################################################################

GUI1_Principal()

Func GUI1_Principal();fenêtre principale
	$GUI1 = GUICreate("Password Manager", 230, 260,-1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close")

	$GUI1_Label1 = GUICtrlCreateLabel("Login :", 10, 10, 80, 20)
	GUICtrlSetTip($GUI1_Label1,$LoginHint)
	$GUI1_Label2 = GUICtrlCreateLabel("Mot de passe :", 10, 60, 80, 20)
	GUICtrlSetTip($GUI1_Label2,$PasswordHint)
	$GUI1_Label3 = GUICtrlCreateLabel("Build " & $ProgramVersion & " Copyright (c) 2023" & @CRLF & "Auteur : yann83", 30, 220, 130, 40)
	GUICtrlSetFont($GUI1_Label3, 8, 800, 0, "Garamond")

	$GUI1_Group1 = GUICtrlCreateGroup("Actions", 10, 110, 55, 100)

	$GUI1_Bouton1 = GUICtrlCreatePic("", 100, 135, 58, 58)
	GUICtrlSetFont($GUI1_Bouton1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetOnEvent($GUI1_Bouton1, "On_Button")
	GUICtrlSetTip($GUI1_Bouton1,"Ouvrir la base de données.")
	_Resource_SetToCtrlID($GUI1_Bouton1, 'OPEN')

	$GUI1_Bouton2 = GUICtrlCreatePic("", 22, 130, 34, 34)
	GUICtrlSetOnEvent($GUI1_Bouton2, "On_Button")
	GUICtrlSetTip($GUI1_Bouton2,"Changer le mot de passe principal.")
	_Resource_SetToCtrlID($GUI1_Bouton2, 'PASS')

	$GUI1_Bouton3 = GUICtrlCreatePic("", 22, 170, 34, 34)
	GUICtrlSetOnEvent($GUI1_Bouton3, "On_Button")
	GUICtrlSetTip($GUI1_Bouton3,"Changer le login.")
	_Resource_SetToCtrlID($GUI1_Bouton3, 'USER')

	$GUI1_Input1 = GUICtrlCreateInput("", 10, 30, 160, 25)
	GUICtrlSetState($GUI1_Input1, $GUI_FOCUS) ; permet de placer le curseur sur ce contrôle
    GUICtrlSetFont($GUI1_Input1, 12, 400, 0, "Arial")
	$GUI1_Input2 = GUICtrlCreateInput("", 10, 80, 160, 25, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
    GUICtrlSetFont($GUI1_Input2, 12, 400, 0, "Arial")

	$GUI1_Checkbox1 = GUICtrlCreateCheckbox("", 180, 82, 17, 17)
	GUICtrlSetOnEvent($GUI1_Checkbox1, "On_Checkbox")

	$GUI1_Pic1 = GUICtrlCreatePic("", 170, 220, 30, 30)
	GUICtrlSetTip($GUI1_Pic1,"Voir la licence.")
	GUICtrlSetOnEvent($GUI1_Pic1, "On_Button")
	_Resource_SetToCtrlID($GUI1_Pic1, 'CERTIF');ajout de l'image au contrôle

	$GUI1_Pic2 = GUICtrlCreatePic("", 200, 80, 21, 21)
	GUICtrlSetTip($GUI1_Pic2,"Voir le mot de passe.")
	GUICtrlSetOnEvent($GUI1_Pic2, "On_Button")
	_Resource_SetToCtrlID($GUI1_Pic2, 'EYE')

	;affectation de la touche entrée au bouton $GUI1_Bouton1
	Local $aAccelKeys[1][2] = [["{ENTER}", $GUI1_Bouton1]]
	GUISetAccelerators($aAccelKeys)

	GUISetState()

	While 1
        Sleep(10)
    WEnd
EndFunc   ;==>GUI1_Principal

Func GUI2_change_password();changer de mot de passe
	$GUI2 = GUICreate("Mot de passe principal", 260, 170, -1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close")

	$GUI2_Label1 = GUICtrlCreateLabel("Ancien Mot de passe :", 10, 10, 160, 20)
	$GUI2_Label2 = GUICtrlCreateLabel("Nouveau Mot de passe : ", 10, 60, 160, 20)
	$GUI2_Label3 = GUICtrlCreateLabel("Vérification Mot de passe :", 10, 110, 160, 20)

	$GUI2_Input1 = GUICtrlCreateInput("", 10, 30, 180, 25, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
	$GUI2_Input2 = GUICtrlCreateInput("", 10, 80, 180, 25, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
	$GUI2_Input3 = GUICtrlCreateInput("", 10, 130, 180, 25, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
    GUICtrlSetFont($GUI2_Input1, 12, 400, 0, "Arial")
    GUICtrlSetFont($GUI2_Input2, 12, 400, 0, "Arial")
    GUICtrlSetFont($GUI2_Input3, 12, 400, 0, "Arial")

	$GUI2_Bouton1 = GUICtrlCreatePic("", 210, 125, 34, 34)
	GUICtrlSetOnEvent($GUI2_Bouton1, "On_Button")
	GUICtrlSetTip($GUI2_Bouton1,"Valider le changement.")
	_Resource_SetToCtrlID($GUI2_Bouton1, 'VALID')

	$GUI2_Checkbox1 = GUICtrlCreateCheckbox("", 200, 32, 17, 17)
	GUICtrlSetOnEvent($GUI2_Checkbox1, "On_Checkbox")

	$GUI2_Pic1 = GUICtrlCreatePic("", 220, 30, 21, 21)
	GUICtrlSetTip($GUI2_Pic1,"Voir le mot de passe.")
	GUICtrlSetOnEvent($GUI2_Pic1, "On_Button")
	_Resource_SetToCtrlID($GUI2_Pic1, 'EYE')

	GUISetState()
EndFunc	;=>GUI2_change_password

Func GUI3_change_login();changer de login
	$GUI3 = GUICreate("Login", 260, 70, -1,-1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close")

	$GUI3_Label1 = GUICtrlCreateLabel("Nouveau Login :", 10, 10, 120, 20)

	$GUI3_Input1 = GUICtrlCreateInput("", 10, 30, 180, 25)
    GUICtrlSetFont($GUI3_Input1, 12, 400, 0, "Arial")

	$GUI3_Bouton1 = GUICtrlCreatePic("", 210, 25, 34, 34)
	GUICtrlSetOnEvent($GUI3_Bouton1, "On_Button")
	GUICtrlSetTip($GUI3_Bouton1,"Valider le changement.")
	_Resource_SetToCtrlID($GUI3_Bouton1, 'VALID')

	GUISetState()
EndFunc	;=>GUI3_change_login

Func GUI4_Manager(); Fenêtre principale liste des codes
	$GUI4 = GUICreate("Password Manager", 530, 310, $GUI4x, $GUI4y)
	GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close")

	$GUI4_List1 = GUICtrlCreateListView("", 16, 46, 426, 188,$LVS_OWNERDATA)
     GUICtrlSetFont($GUI4_List1, 12, 400, 0, "Arial")
	$GUI4_ListViewHandle = GUICtrlGetHandle($GUI4_List1)
	_GUICtrlListView_SetExtendedListViewStyle($GUI4_ListViewHandle, BitOR($LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES))
	_GUICtrlListView_InsertColumn($GUI4_ListViewHandle, 0, "ID", 50)
	_GUICtrlListView_InsertColumn($GUI4_ListViewHandle, 1, "NOM", 450)

	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

	$GUI4_Bouton1 = GUICtrlCreatePic("", 16, 246, 50, 50)
	GUICtrlSetOnEvent($GUI4_Bouton1, "On_Button")
	GUICtrlSetTip($GUI4_Bouton1,"Ajouter une entrée.")
	_Resource_SetToCtrlID($GUI4_Bouton1, 'ADD')

	$GUI4_Bouton2 = GUICtrlCreatePic("", 141, 246, 50, 50)
	GUICtrlSetOnEvent($GUI4_Bouton2, "On_Button")
	GUICtrlSetTip($GUI4_Bouton2,"Modifier une entrée.")
	_Resource_SetToCtrlID($GUI4_Bouton2, 'MOD')

	$GUI4_Bouton3 = GUICtrlCreatePic("", 266, 246, 50, 50)
	GUICtrlSetOnEvent($GUI4_Bouton3, "On_Button")
	GUICtrlSetTip($GUI4_Bouton3,"Effacer une entrée.")
	_Resource_SetToCtrlID($GUI4_Bouton3, 'DEL')

	$GUI4_Bouton4 = GUICtrlCreatePic("", 392, 246, 50, 50)
	GUICtrlSetOnEvent($GUI4_Bouton4, "On_Button")
	GUICtrlSetTip($GUI4_Bouton4,"Voir une entrée.")
	_Resource_SetToCtrlID($GUI4_Bouton4, 'VIEW')

	$GUI4_Bouton5 = GUICtrlCreatePic("", 464, 46, 50, 50)
	GUICtrlSetOnEvent($GUI4_Bouton5, "On_Button")
	GUICtrlSetTip($GUI4_Bouton5,"Trier de A à Z.")
	_Resource_SetToCtrlID($GUI4_Bouton5, 'AZ')

	$GUI4_Bouton6 = GUICtrlCreatePic("", 464, 182, 50, 50)
	GUICtrlSetOnEvent($GUI4_Bouton6, "On_Button")
	GUICtrlSetTip($GUI4_Bouton6,"Trier de Z à A.")
	_Resource_SetToCtrlID($GUI4_Bouton6, 'ZA')

	$GUI4_Bouton7 = GUICtrlCreatePic("", 464, 114, 50, 50)
	GUICtrlSetOnEvent($GUI4_Bouton7, "On_Button")
	GUICtrlSetTip($GUI4_Bouton7,"Générateur de mot de passe.")
	_Resource_SetToCtrlID($GUI4_Bouton7, 'CALC')

	$GUI4_Edit = GUICtrlCreateEdit( "", 16, 10, 426, 25, BitXOR( $GUI_SS_DEFAULT_EDIT, $WS_HSCROLL, $WS_VSCROLL ) )
    GUICtrlSetFont($GUI4_Edit, 12, 400, 0, "Arial")
	$GUI4_EditHandle = GUICtrlGetHandle($GUI4_Edit)
	$GUI4_Editsearch = GUICtrlCreateDummy()
	GUICtrlSendMsg($GUI4_Edit, $EM_SETCUEBANNER, True, "Rechercher...")
	GUICtrlSetOnEvent(-1, "On_Edit") ; Call a common button function

	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

	_CalculRecherche($aSQLResult)
	GUICtrlSendMsg( $GUI4_List1, $LVM_SETITEMCOUNT, $aSearch_Rows, 0 )

	GUISetState()
EndFunc	;=>GUI4_Manager

Func GUI5_Add(); ajouter une entrée
	$GUI5 = GUICreate("Ajouter", 260, 260, $aPos[0]-260, $aPos[1])
	GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close")

     GUIRegisterMsg($WM_WINDOWPOSCHANGING, 'WM_WINDOWPOSCHANGING')

	$GUI5_Label1 = GUICtrlCreateLabel("Nom de l'entrée :", 10, 10, 160, 20)
	$GUI5_Label5 = GUICtrlCreateLabel("Chemin (url/système) :", 10, 60, 160, 20)
	$GUI5_Label2 = GUICtrlCreateLabel("Login :", 10, 110, 160, 20)
	$GUI5_Label3 = GUICtrlCreateLabel("Mot de passe :", 10, 160, 160, 20)
	$GUI5_Label4 = GUICtrlCreateLabel("Vérification du Mot de passe :", 10, 210, 160, 20)

	$GUI5_Input1 = GUICtrlCreateInput("", 10, 30, 180, 25)
	$GUI5_Input5 = GUICtrlCreateInput("", 10, 80, 180, 25)
	$GUI5_Input2 = GUICtrlCreateInput("", 10, 130, 180, 25)
	$GUI5_Input3 = GUICtrlCreateInput("", 10, 180, 180, 25, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
	$GUI5_Input4 = GUICtrlCreateInput("", 10, 230, 180, 25, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
    GUICtrlSetFont($GUI5_Input1, 12, 400, 0, "Arial")
    GUICtrlSetFont($GUI5_Input2, 12, 400, 0, "Arial")
    GUICtrlSetFont($GUI5_Input3, 12, 400, 0, "Arial")
    GUICtrlSetFont($GUI5_Input4, 12, 400, 0, "Arial")
    GUICtrlSetFont($GUI5_Input5, 12, 400, 0, "Arial")

	$GUI5_Bouton1 = GUICtrlCreatePic("", 210, 225, 34, 34)
	GUICtrlSetOnEvent($GUI5_Bouton1, "On_Button")
	GUICtrlSetTip($GUI5_Bouton1,"Valider le changement.")
	_Resource_SetToCtrlID($GUI5_Bouton1, 'VALID')

	GUISetState()
EndFunc	;=>GUI5_Add

Func GUI6_MOD(); modifier une entrée
	$GUI6 = GUICreate("Modifier", 250, 250, $aPos[0]-250,$aPos[1])
	GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close")

     GUIRegisterMsg($WM_WINDOWPOSCHANGING, 'WM_WINDOWPOSCHANGING')

	$GUI6_Label1 = GUICtrlCreateLabel("Nom de l'entrée :", 10, 10, 160, 20)
	$GUI6_Label4 = GUICtrlCreateLabel("Chemin (url/système) :", 10, 60, 160, 20)
	$GUI6_Label2 = GUICtrlCreateLabel("Login", 10, 110, 160, 20)
	$GUI6_Label3 = GUICtrlCreateLabel("Mot de passe :", 10, 160, 160, 20)

	$GUI6_Input1 = GUICtrlCreateInput("", 10, 30, 180, 25)
	$GUI6_Input4 = GUICtrlCreateInput("", 10, 80, 180, 25)
	$GUI6_Input2 = GUICtrlCreateInput("", 10, 130, 180, 25)
	$GUI6_Input3 = GUICtrlCreateInput("", 10, 180, 180, 25, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
    GUICtrlSetFont($GUI6_Input1, 12, 400, 0, "Arial")
    GUICtrlSetFont($GUI6_Input2, 12, 400, 0, "Arial")
    GUICtrlSetFont($GUI6_Input3, 12, 400, 0, "Arial")
    GUICtrlSetFont($GUI6_Input4, 12, 400, 0, "Arial")

	$GUI6_Bouton1 = GUICtrlCreatePic("", 115, 210, 34, 34)
	GUICtrlSetOnEvent($GUI6_Bouton1, "On_Button")
	GUICtrlSetTip($GUI6_Bouton1,"Valider le changement.")
	_Resource_SetToCtrlID($GUI6_Bouton1, 'VALID')

	$GUI6_Checkbox1 = GUICtrlCreateCheckbox("", 200, 182, 17, 17)
	GUICtrlSetOnEvent($GUI6_Checkbox1, "On_Checkbox")

	$GUI6_Pic1 = GUICtrlCreatePic("", 220, 180, 21, 21)
	GUICtrlSetTip($GUI6_Pic1,"Voir le mot de passe.")
	GUICtrlSetOnEvent($GUI6_Pic1, "On_Button")
	_Resource_SetToCtrlID($GUI6_Pic1, 'EYE')

	GUISetState()
EndFunc	;=>GUI6_MOD

Func GUI7_VIEW(); voir une entrée
	$GUI7 = GUICreate("Voir entrée", 290, 210, $aPos[0]-290,$aPos[1])
	GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close")

     GUIRegisterMsg($WM_WINDOWPOSCHANGING, 'WM_WINDOWPOSCHANGING')

	$GUI7_Label1 = GUICtrlCreateLabel("Nom de l'entrée :", 10, 10, 160, 20)
	$GUI7_Label4 = GUICtrlCreateLabel("Chemin (url/système) :", 10, 60, 160, 20)
	$GUI7_Label2 = GUICtrlCreateLabel("Login :", 10, 110, 160, 20)
	$GUI7_Label3 = GUICtrlCreateLabel("Mot de passe :", 10, 160, 160, 20)

	$GUI7_Input1 = GUICtrlCreateInput("", 10, 30, 180, 25, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
	$GUI7_Input4 = GUICtrlCreateInput("", 10, 80, 180, 25, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
	$GUI7_Input2 = GUICtrlCreateInput("", 10, 130, 180, 25, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
	$GUI7_Input3 = GUICtrlCreateInput("", 10, 180, 180, 25, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD,$ES_READONLY))
    GUICtrlSetFont($GUI7_Input1, 12, 400, 0, "Arial")
    GUICtrlSetFont($GUI7_Input2, 12, 400, 0, "Arial")
    GUICtrlSetFont($GUI7_Input3, 12, 400, 0, "Arial")
    GUICtrlSetFont($GUI7_Input4, 12, 400, 0, "Arial")

	$GUI7_Bouton1 = GUICtrlCreatePic("", 250, 120, 34, 34)
	GUICtrlSetOnEvent($GUI7_Bouton1, "On_Button")
	GUICtrlSetTip($GUI7_Bouton1,"copier le contenu dans le presse-papier.")
	_Resource_SetToCtrlID($GUI7_Bouton1, 'COPY')

	$GUI7_Bouton2 = GUICtrlCreatePic("", 250, 170, 34, 34)
	GUICtrlSetOnEvent($GUI7_Bouton2, "On_Button")
	GUICtrlSetTip($GUI7_Bouton2,"copier le contenu dans le presse-papier.")
	_Resource_SetToCtrlID($GUI7_Bouton2, 'COPY')

	$GUI7_Bouton3 = GUICtrlCreatePic("", 200, 78, 34, 34)
	GUICtrlSetOnEvent($GUI7_Bouton3, "On_Button")
	GUICtrlSetTip($GUI7_Bouton3,"Ouvrir le chemin.")
	_Resource_SetToCtrlID($GUI7_Bouton3, 'GO')

	$GUI7_Checkbox1 = GUICtrlCreateCheckbox("", 200, 182, 17, 17)
	GUICtrlSetOnEvent($GUI7_Checkbox1, "On_Checkbox")

	$GUI7_Pic1 = GUICtrlCreatePic("", 220, 180, 21, 21)
	GUICtrlSetTip($GUI7_Pic1,"Voir le mot de passe.")
	GUICtrlSetOnEvent($GUI7_Pic1, "On_Button")
	_Resource_SetToCtrlID($GUI7_Pic1, 'EYE')

	GUISetState()
EndFunc	;=>GUI7_VIEW

Func GUI8_PASSGEN(); générateur de mot de passe
	$GUI8 = GUICreate("Généré Mot de passe", 240, 340, $aPos[0]+530,$aPos[1])
	GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close")

     GUIRegisterMsg($WM_WINDOWPOSCHANGING, 'WM_WINDOWPOSCHANGING')

	$GUI8_Label1 = GUICtrlCreateLabel("Nombre de Mot de passe à générer :", 10, 10, 180, 20)
	$GUI8_Label2 = GUICtrlCreateLabel("Longueur du Mot de passe :", 10, 40, 180, 20)
	$GUI8_Label3 = GUICtrlCreateLabel("Format du Mot de passe :", 10, 70, 180, 20)
	$GUI8_Label4 =  GUICtrlCreateLabel("Mot(s) de passe généré(s) :", 10, 120, 180, 20)

	$GUI8_Input1 = GUICtrlCreateInput("1", 200, 10, 30, 25)
	$GUI8_Input2 = GUICtrlCreateInput("20", 200, 40, 30, 25)
    GUICtrlSetFont($GUI8_Input1, 12, 400, 0, "Arial")
    GUICtrlSetFont($GUI8_Input2, 12, 400, 0, "Arial")

	$GUI8_Edit1 = GUICtrlCreateEdit("", 10, 140, 220, 140)
    GUICtrlSetFont($GUI8_Edit1, 12, 400, 0, "Arial")

	$GUI8_Bouton1 = GUICtrlCreatePic("", 10, 290, 34, 34)
	GUICtrlSetOnEvent($GUI8_Bouton1, "On_Button")
	GUICtrlSetTip($GUI8_Bouton1,"copier le contenu dans le presse-papier.")
	_Resource_SetToCtrlID($GUI8_Bouton1, 'COPY')

	$GUI8_Bouton2 = GUICtrlCreatePic("", 196, 290, 34, 34)
	GUICtrlSetOnEvent($GUI8_Bouton2, "On_Button")
	GUICtrlSetTip($GUI8_Bouton2,"Générer un ou des mot(s) de passe.")
	_Resource_SetToCtrlID($GUI8_Bouton2, 'GEN')

	$GUI8_Combo1 = GUICtrlCreateCombo("", 10, 90,220, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($GUI8_Combo1, "Lettres en majuscule|Lettres en minuscule|Chiffres seulement|Mix Lettres/Chiffres|Mix avec caractères spéciaux", "Mix Lettres/Chiffres")
	GUICtrlSetOnEvent($GUI8_Combo1, "On_Combobox")
	$PwsFmt = _GUICtrlComboBox_GetCurSel($GUI8_Combo1)

	GUISetState()
EndFunc	;=>GUI8_PASSGEN

Func GUI9_AIDE()

	Local $oIE = _IECreateEmbedded()
	$GUI9 = GUICreate("Licence", 690, 360, -1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close")

	GUICtrlCreateObj($oIE, 5, 5, 680, 350)
	_IENavigate($oIE, @ScriptDir & "\licence.html")
	_IEAction($oIE, "stop")

	GUISetState()
EndFunc	;=>	GUI9_AIDE

Func SetPos()
    $aPos = WinGetPos($GUI4)
EndFunc

Func On_Edit()

	Switch @GUI_CTRLID

		Case $GUI4_Editsearch
			Local $Recherche = GUICtrlRead($GUI4_Edit)
			If $Recherche = "" Then
				For $i = 0 To $Nb_Rows - 1
					$aSearch[$i] = $i
				Next
				$aSearch_Rows = $Nb_Rows
			Else
				$aSearch_Rows = 0
				For $i = 0 To $Nb_Rows - 1
					If StringInStr( $aSQLResult[$i][1], $Recherche ) Then ; Normal search
						$aSearch[$aSearch_Rows] = $i
						$aSearch_Rows += 1
					EndIf
				Next
			EndIf
			GUICtrlSendMsg( $GUI4_List1, $LVM_SETITEMCOUNT, $aSearch_Rows, 0 )
	EndSwitch

EndFunc   ;==>On_Edit

Func On_Button();gestion de tous les boutons

    Switch @GUI_CTRLID

		;GUI1
		Case $GUI1_Bouton1
			$Input1_Read = GUICtrlRead($GUI1_Input1)
			$Input2_Read = GUICtrlRead($GUI1_Input2)
			_SQLite_Query(-1, "SELECT CODE FROM access WHERE ID= '1';", $MyQuery)
			While _SQLite_FetchData($MyQuery, $MyQueryRow) = $SQLITE_OK
				$TempDataDecryptage = _StringEncryptDecrypt(False, $MyQueryRow[0], $Input2_Read)
			WEnd
			If $TempDataDecryptage = "ÿÿÿÿ" Then
				MsgBox(48,"Erreur de sécurité","Mauvais Mot de passe.",5)
				_FileWriteLog($ManagerLogfile, "GUI1 Access Wrong Password")
			Else
				_SQLite_Query(-1, "SELECT LOGIN FROM access WHERE ID= '1';", $MyQuery)
				While _SQLite_FetchData($MyQuery, $MyQueryRow) = $SQLITE_OK
					$TempDataDecryptage = _StringEncryptDecrypt(False, $MyQueryRow[0], $Input2_Read)
				WEnd
				If $TempDataDecryptage = $Input1_Read Then
					;################# Rafraichie la liste ################
					_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($GUI4_List1)); supprime les items de la liste
					$iRval = _SQLite_GetTable2d(-1, "SELECT ID,NAME FROM manager ORDER BY ID;", $aSQLResult, $iRows, $iColumns); requete SQL sur la table manager
					_ArrayDelete($aSQLResult,0);suppression ligne 0 : ID | Name
					_GUICtrlListView_AddArray($GUI4_List1, $aSQLResult); affichage de la requete
					;####################################################
					GUI4_Manager()
					GUISetState(@SW_HIDE,$GUI1)
				Else
					MsgBox(48,"Erreur de sécurité","Mauvais Login.",5)
					_FileWriteLog($ManagerLogfile, "GUI1 Access Wrong Login")
				EndIf
			EndIf
			$Input1_Read = ""
			$Input2_Read = ""
			$TempDataDecryptage = ""

        Case $GUI1_Bouton2
			GUICtrlSetState($GUI1_Bouton2,$GUI_DISABLE)
			GUI2_change_password()

		Case $GUI1_Bouton3
			GUICtrlSetState($GUI1_Bouton3,$GUI_DISABLE)
			GUI3_change_login()

		Case $GUI1_Pic1
			GUICtrlSetState($GUI1_Pic1,$GUI_DISABLE)
			GUI9_AIDE()

		;GUI2
		Case $GUI2_Bouton1
			$Input1_Read = GUICtrlRead($GUI2_Input1)
			$Input2_Read = GUICtrlRead($GUI2_Input2)
			$Input3_Read = GUICtrlRead($GUI2_Input3)
			_SQLite_Query(-1, "SELECT CODE FROM access WHERE ID= '1';", $MyQuery)
			While _SQLite_FetchData($MyQuery, $MyQueryRow) = $SQLITE_OK
				$TempDataDecryptage = _StringEncryptDecrypt(False, $MyQueryRow[0], $Input1_Read);decryptage de l'ancien mot de passe
			WEnd
			If $TempDataDecryptage = "ÿÿÿÿ" Then
				MsgBox(48,"Erreur de sécurité","Mauvais Mot de passe.",5)
				_FileWriteLog($ManagerLogfile, "GUI2 Change Password Wrong Password")
			Else
				If $Input2_Read <> $Input3_Read Then
					$PwdMsgBox = MsgBox(48,"Erreur de sécurité","Les mots de passe sont differents.")
				ElseIf $Input2_Read = $Input3_Read Then
					$TempDataEncryptage = _StringEncryptDecrypt(True, $Input2_Read, $Input2_Read);cryptage nouveau mot de passe
					If Not _SQLite_Exec(-1, "UPDATE access SET CODE='" & $TempDataEncryptage & "' WHERE ID= '1';") = $SQLITE_OK Then _
						_FileWriteLog($ManagerLogfile, "GUI2 UPDATE access 1 FAILURE");ecriture nouveau de passe dans la BDD

					_SQLite_Query(-1, "SELECT LOGIN FROM access WHERE ID= '1';", $MyQuery)
					While _SQLite_FetchData($MyQuery, $MyQueryRow) = $SQLITE_OK
						$TempDataDecryptage = _StringEncryptDecrypt(False, $MyQueryRow[0], $Input1_Read);decryptage du login avec l'ancien mot de passe
					WEnd
					$TempDataEncryptage = _StringEncryptDecrypt(True, $TempDataDecryptage, $Input2_Read);cryptage du login avec le nouveau mot de passe
					If Not _SQLite_Exec(-1, "UPDATE access SET LOGIN='" & $TempDataEncryptage & "' WHERE ID= '1';") = $SQLITE_OK Then _
						_FileWriteLog($ManagerLogfile, "GUI2 UPDATE access 2 FAILURE")

					_SQLite_Query(-1, "SELECT MASTERPASSWORD FROM access WHERE ID= '1';", $MyQuery)
					While _SQLite_FetchData($MyQuery, $MyQueryRow) = $SQLITE_OK
						$TempDataDecryptage = _StringEncryptDecrypt(False, $MyQueryRow[0], $Input1_Read);decryptage du masterpassword avec l'ancien mot de passe
					WEnd
					$TempDataEncryptage = _StringEncryptDecrypt(True, $TempDataDecryptage, $Input2_Read);cryptage du masterpassword avec le nouveau mot de passe
					If Not _SQLite_Exec(-1, "UPDATE access SET MASTERPASSWORD='" & $TempDataEncryptage & "' WHERE ID= '1';") = $SQLITE_OK Then _
						_FileWriteLog($ManagerLogfile, "GUI2 UPDATE access 3 FAILURE")
				EndIf
				MsgBox(64,"Sécurité","Mot de passe changé.",5)
				_FileWriteLog($ManagerLogfile, "GUI2 Master password has been changed.")
			EndIf
			$Input1_Read = ""
			$Input2_Read = ""
			$Input3_Read = ""
			$TempDataDecryptage = ""
			$TempDataEncryptage = ""
			GUICtrlSetState($GUI1_Bouton2,$GUI_ENABLE)
			GUIDelete($GUI2)
			$GUI2 = 9999
			$GUI2_Label1 = 9999
			$GUI2_Label2 = 9999
			$GUI2_Label3 = 9999
			$GUI2_Input1 = 9999
			$GUI2_Input2 = 9999
			$GUI2_Input3 = 9999
			$GUI2_Bouton1 = 9999
			$GUI2_Checkbox1 = 9999
			$GUI2_Pic1 = 9999

		;GUI3
		Case $GUI3_Bouton1
			$Input1_Read = GUICtrlRead($GUI3_Input1)
			$PasswdPAL = InputBox("Sécurité", "Entrez votre mot de passe principal :", "", "*", 190, 140)
			If @error <> "1" Then
				_SQLite_Query(-1, "SELECT LOGIN FROM access WHERE ID= '1';", $MyQuery)
				While _SQLite_FetchData($MyQuery, $MyQueryRow) = $SQLITE_OK
					$TempDataDecryptage = _StringEncryptDecrypt(False, $MyQueryRow[0], $PasswdPAL)
				WEnd
				If $TempDataDecryptage = "ÿÿÿÿ" Then
					MsgBox(48,"Erreur de sécurité","Mauvais Mot de passe.",5)
					_FileWriteLog($ManagerLogfile, "GUI3 Change Login Wrong Password")
				Else
					$TempDataEncryptage = _StringEncryptDecrypt(True, $Input1_Read, $PasswdPAL)
					If Not _SQLite_Exec(-1, "UPDATE access SET LOGIN='" & $TempDataEncryptage & "' WHERE ID= '1';") = $SQLITE_OK Then _
						_FileWriteLog($ManagerLogfile, "GUI3 UPDATE access 1 FAILURE")
				EndIf
			EndIf
			$Input1_Read = ""
			$PasswdPAL = ""
			$TempDataDecryptage = ""
			$TempDataEncryptage = ""
			GUICtrlSetState($GUI1_Bouton3,$GUI_ENABLE)
			GUIDelete($GUI3)
			$GUI3 = 9998
			$GUI3_Input1 = 9998
			$GUI3_Label1 = 9998
			$GUI3_Bouton1 = 9998

		;GUI4
        Case $GUI4_Bouton1 ; ajouter
            SetPos()
			GUICtrlSetState($GUI4_Bouton1,$GUI_DISABLE)
			GUI5_Add()

		Case $GUI4_Bouton2 ; modify
            SetPos()
			$GUI4_List1_Indice = Int(_GUICtrlListView_GetSelectedIndices($GUI4_List1)); récupére l'indice de l'item de la liste
			$GUI4_List1_Check = _GUICtrlListView_GetItemSelected( $GUI4_List1, $GUI4_List1_Indice); renvoie True si l'item est selectionné
			If $GUI4_List1_Check = True Then
				$PasswdPAL = InputBox("Sécurité", "Entrez votre mot de passe principal :", "", "*", 190, 140,$aPos[0]+100,$aPos[1]+100)
				If @error <> "1" Then
					_SQLite_Query(-1, "SELECT MASTERPASSWORD FROM access WHERE ID= '1';", $MyQuery)
					While _SQLite_FetchData($MyQuery, $MyQueryRow) = $SQLITE_OK
						$TempDataDecryptage = _StringEncryptDecrypt(False, $MyQueryRow[0], $PasswdPAL);decryptage du masterpassword avec le mot de passe
					WEnd
					If $TempDataDecryptage = "ÿÿÿÿ" Then
						MsgBox(48,"Erreur de sécurité","Mauvais Mot de passe.",5)
						_FileWriteLog($ManagerLogfile, "GUI4 Modify Wrong Password")
					Else
						$GUI4_List1_Item = _GUICtrlListView_GetItemTextArray($GUI4_List1, $GUI4_List1_Indice);récupére dans un tableau les données de l'item
						_SQLite_Query(-1, "SELECT NAME,PATH,LOGIN,CODE FROM manager WHERE ID=" & $GUI4_List1_Item[1] & ";", $MyQuery) ; the query sur l'ID de la colonne ID de la liste
						While _SQLite_FetchData($MyQuery, $MyQueryRow) = $SQLITE_OK
							$Input1_Read = $MyQueryRow[0]
							$Input2_Read = $MyQueryRow[1]
							$Input3_Read = _StringEncryptDecrypt(False, $MyQueryRow[2], $TempDataDecryptage)
							$Input4_Read = _StringEncryptDecrypt(False, $MyQueryRow[3], $TempDataDecryptage)
						WEnd
						_SQLite_QueryFinalize($MyQuery)
						GUICtrlSetState($GUI4_Bouton2,$GUI_DISABLE)
						GUI6_MOD()
						GUICtrlSetData($GUI6_Input1,$Input1_Read)
						GUICtrlSetData($GUI6_Input4,$Input2_Read)
						GUICtrlSetData($GUI6_Input2,$Input3_Read)
						GUICtrlSetData($GUI6_Input3,$Input4_Read)
					EndIf
				EndIf
			EndIf
			$PasswdPAL = ""

		Case $GUI4_Bouton3 ; delete
            SetPos()
			GUICtrlSetData($GUI4_Edit,"")
			$GUI4_List1_Indice = Int(_GUICtrlListView_GetSelectedIndices($GUI4_List1))
			$GUI4_List1_Check = _GUICtrlListView_GetItemSelected( $GUI4_List1, $GUI4_List1_Indice)
			If $GUI4_List1_Check = True Then
				$PasswdPAL = InputBox("Sécurité", "Entrez votre mot de passe principal :", "", "*", 190, 140,$aPos[0]+100,$aPos[1]+100)
				If @error <> "1" Then
					_SQLite_Query(-1, "SELECT MASTERPASSWORD FROM access WHERE ID= '1';", $MyQuery)
					While _SQLite_FetchData($MyQuery, $MyQueryRow) = $SQLITE_OK
						$TempDataDecryptage = _StringEncryptDecrypt(False, $MyQueryRow[0], $PasswdPAL);decryptage du masterpassword avec le mot de passe
					WEnd
					If $TempDataDecryptage = "ÿÿÿÿ" Then
						MsgBox(48,"Erreur de sécurité","Mauvais Mot de passe.",5)
						_FileWriteLog($ManagerLogfile, "GUI4 Delete Wrong Password")
					Else
						$GUI4_List1_Item = _GUICtrlListView_GetItemTextArray($GUI4_List1, $GUI4_List1_Indice)
						If Not _SQLite_Exec(-1, "DELETE FROM manager WHERE ID=" & $GUI4_List1_Item[1] & ";") = $SQLITE_OK Then _
							_FileWriteLog($ManagerLogfile, "GUI4 DELETE FAILURE")
						_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($GUI4_List1))
						$iRval = _SQLite_GetTable2d(-1, "SELECT ID,NAME FROM manager ORDER BY ID;", $aSQLResult, $iRows, $iColumns)
						_ArrayDelete($aSQLResult,0);suppression ligne 0 : ID | Name
						_CalculRecherche($aSQLResult)
						_GUICtrlListView_AddArray($GUI4_List1, $aSQLResult)
						GUICtrlSendMsg( $GUI4_List1, $LVM_SETITEMCOUNT, $aSearch_Rows, 0 )

					EndIf
				EndIf
			EndIf
			$PasswdPAL = ""
			$TempDataDecryptage = ""

		Case $GUI4_Bouton4 ; view
            SetPos()
			$GUI4_List1_Indice = Int(_GUICtrlListView_GetSelectedIndices($GUI4_List1))
			$GUI4_List1_Check = _GUICtrlListView_GetItemSelected( $GUI4_List1, $GUI4_List1_Indice)
			If $GUI4_List1_Check = True Then
				$PasswdPAL = InputBox("Sécurité", "Entrez votre mot de passe principal :", "", "*", 190, 140,$aPos[0]+100,$aPos[1]+100)
				If @error <> "1" Then
					_SQLite_Query(-1, "SELECT MASTERPASSWORD FROM access WHERE ID= '1';", $MyQuery)
					While _SQLite_FetchData($MyQuery, $MyQueryRow) = $SQLITE_OK
						$TempDataDecryptage = _StringEncryptDecrypt(False, $MyQueryRow[0], $PasswdPAL);decryptage du masterpassword avec le mot de passe
					WEnd
					If $TempDataDecryptage = "ÿÿÿÿ" Then
						MsgBox(48,"Erreur de sécurité","Mauvais Mot de passe.",5)
						_FileWriteLog($ManagerLogfile, "GUI4 View Wrong Password")
					Else
						$GUI4_List1_Item = _GUICtrlListView_GetItemTextArray($GUI4_List1, $GUI4_List1_Indice)
						_SQLite_Query(-1, "SELECT NAME,PATH,LOGIN,CODE FROM manager WHERE ID=" & $GUI4_List1_Item[1] & ";", $MyQuery) ; the query
						While _SQLite_FetchData($MyQuery, $MyQueryRow) = $SQLITE_OK
							$Input1_Read = $MyQueryRow[0]
							$Input2_Read = $MyQueryRow[1]
							$Input3_Read = _StringEncryptDecrypt(False, $MyQueryRow[2], $TempDataDecryptage)
							$Input4_Read = _StringEncryptDecrypt(False, $MyQueryRow[3], $TempDataDecryptage)
						WEnd
						_SQLite_QueryFinalize($MyQuery)
						GUICtrlSetState($GUI4_Bouton4,$GUI_DISABLE)
						GUI7_VIEW()
						GUICtrlSetData($GUI7_Input1,$Input1_Read)
						GUICtrlSetData($GUI7_Input4,$Input2_Read)
						GUICtrlSetData($GUI7_Input2,$Input3_Read)
						GUICtrlSetData($GUI7_Input3,$Input4_Read)
					EndIf
				EndIf
			EndIf
			$PasswdPAL = ""
			$TempDataDecryptage = ""

		Case $GUI4_Bouton5
			GUICtrlSetData($GUI4_Edit,"")
			_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($GUI4_List1))
			$iRval = _SQLite_GetTable2d(-1, "SELECT ID,NAME FROM manager ORDER BY NAME ASC;", $aSQLResult, $iRows, $iColumns)
			_ArrayDelete($aSQLResult,0);suppression ligne 0 : ID | Name
			_GUICtrlListView_AddArray($GUI4_List1, $aSQLResult)

		Case $GUI4_Bouton6
			GUICtrlSetData($GUI4_Edit,"")
			_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($GUI4_List1))
			$iRval = _SQLite_GetTable2d(-1, "SELECT ID,NAME FROM manager ORDER BY NAME DESC;", $aSQLResult, $iRows, $iColumns)
			_ArrayDelete($aSQLResult,0);suppression ligne 0 : ID | Name
			_GUICtrlListView_AddArray($GUI4_List1, $aSQLResult)

		Case $GUI4_Bouton7
            SetPos()
			GUICtrlSetState($GUI4_Bouton7,$GUI_DISABLE)
			GUI8_PASSGEN()

		;GUI5
		Case $GUI5_Bouton1
			GUICtrlSetData($GUI4_Edit,"")
			$Input1_Read = GUICtrlRead($GUI5_Input1);name
			$Input5_Read = GUICtrlRead($GUI5_Input5);Path
			$Input2_Read = GUICtrlRead($GUI5_Input2);login
			$Input3_Read = GUICtrlRead($GUI5_Input3);password
			$Input4_Read = GUICtrlRead($GUI5_Input4);password_check
			If $Input3_Read = $Input4_Read Then
				$PasswdPAL = InputBox("Sécurité", "Entrez votre mot de passe principal :", "", "*", 190, 140,$aPos[0]+100,$aPos[1]+100)
				If @error <> "1" Then
					_SQLite_Query(-1, "SELECT MASTERPASSWORD FROM access WHERE ID= '1';", $MyQuery)
					While _SQLite_FetchData($MyQuery, $MyQueryRow) = $SQLITE_OK
						$TempDataDecryptage = _StringEncryptDecrypt(False, $MyQueryRow[0], $PasswdPAL);decryptage du masterpassword avec le mot de passe
					WEnd
					If $TempDataDecryptage = "ÿÿÿÿ" Then
						MsgBox(48,"Erreur de sécurité","Mauvais Mot de passe.",5)
						_FileWriteLog($ManagerLogfile, "GUI5 Wrong Password")
					Else
						$TempDataEncryptage = _StringEncryptDecrypt(True, $Input2_Read, $TempDataDecryptage)
						$Input2_Read = $TempDataEncryptage
						$TempDataEncryptage = _StringEncryptDecrypt(True, $Input3_Read, $TempDataDecryptage)
						$Input3_Read = $TempDataEncryptage
						If Not _SQLite_Exec(-1, "INSERT INTO manager (NAME,PATH,LOGIN,CODE) VALUES ('" & $Input1_Read & "','" & $Input5_Read & "','" & $Input2_Read & "','" & $Input3_Read & "');") = $SQLITE_OK Then _
							_FileWriteLog($ManagerLogfile, "GUI5 INSERT FAILURE")
						_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($GUI4_List1))
						$iRval = _SQLite_GetTable2d(-1, "SELECT ID,NAME FROM manager ORDER BY ID;", $aSQLResult, $iRows, $iColumns)
						_ArrayDelete($aSQLResult,0);suppression ligne 0 : ID | Name
						_CalculRecherche($aSQLResult)
						_GUICtrlListView_AddArray($GUI4_List1, $aSQLResult)
						GUICtrlSendMsg( $GUI4_List1, $LVM_SETITEMCOUNT, $aSearch_Rows, 0 )
						GUICtrlSetState($GUI4_Bouton1,$GUI_ENABLE)
						GUIDelete($GUI5)
						$GUI5 = 9996
						$GUI5_Input1 = 9996
						$GUI5_Input2 = 9996
						$GUI5_Input3 = 9996
						$GUI5_Input4 = 9996
						$GUI5_Input5 = 9996
						$GUI5_Label1 = 9996
						$GUI5_Label2 = 9996
						$GUI5_Label3 = 9996
						$GUI5_Label4 = 9996
						$GUI5_Bouton1 = 9996
					EndIf
				EndIf
			Else
				MsgBox(48,"Erreur de sécurité","Les mots de passe sont differents.")
			EndIf
			$Input1_Read = ""
			$Input2_Read = ""
			$Input3_Read = ""
			$Input4_Read = ""
			$Input5_Read = ""
			$TempDataDecryptage = ""
			$TempDataEncryptage = ""

		;GUI6
		Case $GUI6_Bouton1
			GUICtrlSetData($GUI4_Edit,"")
			$Input1_Read = GUICtrlRead($GUI6_Input1);name
			$Input4_Read = GUICtrlRead($GUI6_Input4);path
			$Input2_Read = GUICtrlRead($GUI6_Input2);login
			$Input3_Read = GUICtrlRead($GUI6_Input3);password
			$TempDataEncryptage = _StringEncryptDecrypt(True, $Input2_Read, $TempDataDecryptage)
			$Input2_Read = $TempDataEncryptage
			$TempDataEncryptage = _StringEncryptDecrypt(True, $Input3_Read, $TempDataDecryptage)
			$Input3_Read = $TempDataEncryptage
			If Not _SQLite_Exec(-1, "UPDATE manager SET NAME='" & $Input1_Read & "', PATH='" & $Input4_Read & "', LOGIN='" & $Input2_Read & "', CODE='" & $Input3_Read & "' WHERE Id=" & $GUI4_List1_Item[1] & ";") = $SQLITE_OK Then _
				_FileWriteLog($ManagerLogfile, "GUI6 UPDATE FAILURE")
			_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($GUI4_List1))
			$iRval = _SQLite_GetTable2d(-1, "SELECT ID,NAME FROM manager ORDER BY ID;", $aSQLResult, $iRows, $iColumns)
			_ArrayDelete($aSQLResult,0);suppression ligne 0 : ID | Name
			_CalculRecherche($aSQLResult)
			_GUICtrlListView_AddArray($GUI4_List1, $aSQLResult)
			GUICtrlSendMsg( $GUI4_List1, $LVM_SETITEMCOUNT, $aSearch_Rows, 0 )
			$Input1_Read = ""
			$Input2_Read = ""
			$Input3_Read = ""
			$Input4_Read = ""
			$TempDataDecryptage = ""
			GUICtrlSetState($GUI4_Bouton2,$GUI_ENABLE)
			GUIDelete($GUI6)
			$GUI6 = 9995
			$GUI6_Label1 = 9995
			$GUI6_Label2 = 9995
			$GUI6_Label3 = 9995
			$GUI6_Input1 = 9995
			$GUI6_Input2 = 9995
			$GUI6_Input3 = 9995
			$GUI6_Input4 = 9995
			$GUI6_Bouton1 = 9995
			$GUI6_Checkbox1 = 9995
			$GUI6_Pic1 = 9995

		;GUI7
		Case $GUI7_Bouton1
			_ClipBoard_SetData($Input3_Read,$CF_TEXT)

		Case $GUI7_Bouton2
			_ClipBoard_SetData($Input4_Read,$CF_TEXT)

		Case $GUI7_Bouton3
			If _IsValidURL($Input2_Read) = 1 Then
				ShellExecute($Input2_Read)
			ElseIf _IsPathValid($Input2_Read) = 1 Then
				ShellExecute($Input2_Read)
			Else
				MsgBox(16,"Mauvais format","URL/Chemin n'est pas valide.")
			EndIf

		;GUI8
		Case $GUI8_Bouton1
            ;Copy text to clipabord.
            ;Get length of the textbox
            $LineCount = _GUICtrlEdit_GetLineCount($GUI8_Edit1)
            ;Check for text
            If ($LineCount > 0) Then
                ;Add text header

                For $i = 0 To $LineCount - 1
                    If ($i < $LineCount) Then
                        $RetBuff = $RetBuff & _GUICtrlEdit_GetLine($GUI8_Edit1, $i) & @CRLF
                    EndIf
                Next

                ;Put text on clipboard.
                ClipPut($RetBuff)
                ;Clear up
                $RetBuff = ""
                $i = 0
            EndIf

		Case $GUI8_Bouton2
            ;Get number of passwords to make.
            $pCount = _GUICtrlEdit_GetLine($GUI8_Input1, 2)
            ;Get the length of the password to make.
            $len = _GUICtrlEdit_GetLine($GUI8_Input2, 2)

            ;Check for vaild password count.
            If Not StringIsDigit($pCount) Or $pCount = 0 Then
                MsgBox(16, "Erreur", "Nombre de mots de passe invalide.")
            ElseIf Not StringIsDigit($len) Or $len = 0 Then
                MsgBox(16, "Erreur", "longueur du mot de passe invalide.")
                ControlFocus("","",$GUI8_Input2)
            Else
                ;Generate the passwords.
                For $i = 0 To $pCount - 1
                    If ($i < $pCount) Then
                        ;Create password
                        $RetBuff &= RandomPassword($len, $PwsFmt) & @CRLF
                    EndIf
                Next
                ;Set text box with generated passwords.
                _GUICtrlEdit_SetText($GUI8_Edit1, $RetBuff)
                $RetBuff = ""
            EndIf

    EndSwitch

EndFunc	;=>On_Button

Func On_Checkbox();gestion des checkbox

	Switch @GUI_CTRLID
		Case $GUI1_Checkbox1
			If _IsChecked($GUI1_Checkbox1) Then
				GUICtrlSendMsg($GUI1_Input2, $EM_SETPASSWORDCHAR, 0, 0)
			Else
				GUICtrlSendMsg($GUI1_Input2, $EM_SETPASSWORDCHAR, 9679, 0)
			EndIf
			GUICtrlSetState($GUI1_Input2, $GUI_FOCUS)

		Case $GUI2_Checkbox1
			If _IsChecked($GUI2_Checkbox1) Then
				GUICtrlSendMsg($GUI2_Input1, $EM_SETPASSWORDCHAR, 0, 0)
				GUICtrlSendMsg($GUI2_Input2, $EM_SETPASSWORDCHAR, 0, 0)
				GUICtrlSendMsg($GUI2_Input3, $EM_SETPASSWORDCHAR, 0, 0)
			Else
				GUICtrlSendMsg($GUI2_Input1, $EM_SETPASSWORDCHAR, 9679, 0); renvoie le caractere "rond" qui cache le mot de passe
				GUICtrlSendMsg($GUI2_Input2, $EM_SETPASSWORDCHAR, 9679, 0)
				GUICtrlSendMsg($GUI2_Input3, $EM_SETPASSWORDCHAR, 9679, 0)
			EndIf
			GUICtrlSetState($GUI2_Input1, $GUI_FOCUS)
			GUICtrlSetState($GUI2_Input2, $GUI_FOCUS)
			GUICtrlSetState($GUI2_Input3, $GUI_FOCUS)

		Case $GUI7_Checkbox1
			If _IsChecked($GUI7_Checkbox1) Then
				GUICtrlSendMsg($GUI7_Input3, $EM_SETPASSWORDCHAR, 0, 0)
			Else
				GUICtrlSendMsg($GUI7_Input3, $EM_SETPASSWORDCHAR, 9679, 0)
			EndIf
			GUICtrlSetState($GUI7_Input3, $GUI_FOCUS)

		Case $GUI6_Checkbox1
			If _IsChecked($GUI6_Checkbox1) Then
				GUICtrlSendMsg($GUI6_Input3, $EM_SETPASSWORDCHAR, 0, 0)
			Else
				GUICtrlSendMsg($GUI6_Input3, $EM_SETPASSWORDCHAR, 9679, 0)
			EndIf
			GUICtrlSetState($GUI6_Input3, $GUI_FOCUS)

	EndSwitch

EndFunc	;=>On_Checkbox

Func On_Combobox();gestion des combobox

	Switch @GUI_CTRLID
		Case $GUI8_Combo1
            ;Get password format.
            $PwsFmt = _GUICtrlComboBox_GetCurSel($GUI8_Combo1)
	EndSwitch

EndFunc	;=>On_Combobox

Func On_Close();gestion de fermeture des fenêtres
; Important ici on réinitialise les variables à leurs valeurs d'origine pour toutes les fenêtres sauf le GUI1
; sinon les boutons se mélangent les pinceaux
	Switch @GUI_WINHANDLE
		Case $GUI1
			_SQLite_Close($OpenDb)
			_SQLite_Shutdown()
            Exit
		Case $GUI2
			GUICtrlSetState($GUI1_Bouton2,$GUI_ENABLE)
			GUIDelete($GUI2)
			$GUI2 = 9999
			$GUI2_Label1 = 9999
			$GUI2_Label2 = 9999
			$GUI2_Label3 = 9999
			$GUI2_Input1 = 9999
			$GUI2_Input2 = 9999
			$GUI2_Input3 = 9999
			$GUI2_Bouton1 = 9999
			$GUI2_Checkbox1 = 9999
			$GUI2_Pic1 = 9999
		Case $GUI3
			GUICtrlSetState($GUI1_Bouton3,$GUI_ENABLE)
			GUIDelete($GUI3)
			$GUI3 = 9998
			$GUI3_Input1 = 9998
			$GUI3_Label1 = 9998
			$GUI3_Bouton1 = 9998
		Case $GUI4
			Local $aPosition = WinGetPos($GUI4)
			RegWrite($RegistreKey,"GUI4X","REG_SZ",$aPosition[0])
			RegWrite($RegistreKey,"GUI4Y","REG_SZ",$aPosition[1])
			GUIDelete($GUI4)
			$GUI4 = 9997
			$GUI4_List1 = 9997
			$GUI4_ListViewHandle = 9997
			$GUI4_Edit = 9997
			$GUI4_EditHandle = 9997
			$GUI4_Editsearch = 9997
			$GUI4_Bouton1 = 9997
			$GUI4_Bouton2 = 9997
			$GUI4_Bouton3 = 9997
			$GUI4_Bouton4 = 9997
			$GUI4_Bouton5 = 9997
			$GUI4_Bouton6 = 9997
			$GUI4_Bouton7 = 9997
			_SQLite_Close($OpenDb)
			_SQLite_Shutdown()
			_Toast_Set(0, 0xa33209, 0xffffff, 0x353434, 0xffffff, 10, "Arial")
			_Toast_Show($AutoBackup, "ATTENTION!", "Sauvegarde de la Base de donnée en cours...", -1, False)
			RunWait($AutoBackup)
			Sleep(1000)
			_Toast_Hide()
            Exit
		Case $GUI5
			GUICtrlSetState($GUI4_Bouton1,$GUI_ENABLE)
			GUIDelete($GUI5)
			$GUI5 = 9996
			$GUI5_Input1 = 9996
			$GUI5_Input2 = 9996
			$GUI5_Input3 = 9996
			$GUI5_Input4 = 9996
			$GUI5_Input5 = 9996
			$GUI5_Label1 = 9996
			$GUI5_Label2 = 9996
			$GUI5_Label3 = 9996
			$GUI5_Label4 = 9996
			$GUI5_Label5 = 9996
			$GUI5_Bouton1 = 9996
		Case $GUI6
			$Input1_Read = ""
			$Input2_Read = ""
			$Input3_Read = ""
			GUICtrlSetState($GUI4_Bouton2,$GUI_ENABLE)
			GUIDelete($GUI6)
			$GUI6 = 9995
			$GUI6_Label1 = 9995
			$GUI6_Label2 = 9995
			$GUI6_Label3 = 9995
			$GUI6_Label4 = 9995
			$GUI6_Input1 = 9995
			$GUI6_Input2 = 9995
			$GUI6_Input3 = 9995
			$GUI6_Input4 = 9995
			$GUI6_Bouton1 = 9995
			$GUI6_Checkbox1 = 9995
			$GUI6_Pic1 = 9995
		Case $GUI7
			$Input1_Read = ""
			$Input2_Read = ""
			$Input3_Read = ""
			GUICtrlSetState($GUI4_Bouton4,$GUI_ENABLE)
			GUIDelete($GUI7)
			$GUI7 = 9994
			$GUI7_Label1 = 9994
			$GUI7_Label2 = 9994
			$GUI7_Label3 = 9994
			$GUI7_Label4 = 9994
			$GUI7_Input1 = 9994
			$GUI7_Input2 = 9994
			$GUI7_Input3 = 9994
			$GUI7_Input4 = 9994
			$GUI7_Bouton1 = 9994
			$GUI7_Bouton2 = 9994
			$GUI7_Bouton3 = 9994
			$GUI7_Checkbox1 = 9994
			$GUI7_Pic1 = 9994
		Case $GUI8
			GUICtrlSetState($GUI4_Bouton7,$GUI_ENABLE)
			GUIDelete($GUI8)
			$GUI8 = 9993
			$GUI8_Label1 = 9993
			$GUI8_Label2 = 9993
			$GUI8_Label3 = 9993
			$GUI8_Label4 = 9993
			$GUI8_Input1 = 9993
			$GUI8_Input2 = 9993
			$GUI8_Edit1 = 9993
			$GUI8_Bouton1 = 9993
			$GUI8_Bouton2 = 9993
			$GUI8_Combo1 = 9993
		Case $GUI9
			GUICtrlSetState($GUI1_Pic1,$GUI_ENABLE)
			GUIDelete($GUI9)
			$GUI9 = 9992

    EndSwitch
EndFunc	;=>On_Close

Func _IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func WM_COMMAND( $hWnd, $iMsg, $wParam, $lParam )
  Local $hWndFrom = $lParam
  Local $iCode = BitShift( $wParam, 16 ) ; High word
  Switch $hWndFrom
    Case $GUI4_EditHandle;voir Gui1
      Switch $iCode
        Case $EN_CHANGE
          GUICtrlSendToDummy( $GUI4_Editsearch );voir Gui1
      EndSwitch
  EndSwitch
  Return $GUI_RUNDEFMSG
EndFunc

Func WM_NOTIFY( $hWnd, $iMsg, $wParam, $lParam )
  Local Static $tText = DllStructCreate( "wchar[50]" )
  Local Static $pText = DllStructGetPtr( $tText )

  Local $tNMHDR, $hWndFrom, $iCode
  $tNMHDR = DllStructCreate( $tagNMHDR, $lParam )
  $hWndFrom = HWnd( DllStructGetData( $tNMHDR, "hWndFrom" ) )
  $iCode = DllStructGetData( $tNMHDR, "Code" )

  Switch $hWndFrom
    Case $GUI4_ListViewHandle
      Switch $iCode
        Case $LVN_GETDISPINFOW
          Local $tNMLVDISPINFO = DllStructCreate( $tagNMLVDISPINFO, $lParam )
          If BitAND( DllStructGetData( $tNMLVDISPINFO, "Mask" ), $LVIF_TEXT ) Then
			Local $sItem = $aSQLResult[$aSearch[DllStructGetData($tNMLVDISPINFO,"Item")]][DllStructGetData($tNMLVDISPINFO,"SubItem")];Array
            DllStructSetData( $tText, 1, $sItem )
            DllStructSetData( $tNMLVDISPINFO, "Text", $pText )
            DllStructSetData( $tNMLVDISPINFO, "TextMax", StringLen( $sItem ) )
          EndIf
      EndSwitch
  EndSwitch

  Return $GUI_RUNDEFMSG
EndFunc

;sert à bloquer les fenêtre
Func WM_WINDOWPOSCHANGING($hWnd, $iMsg, $wParam, $lParam)
    #forceref $iMsg, $wParam, $lParam
    ;If $hWnd = $g_hGUI2 Then
    ;Tant que la fenêtre existe on bloque tout
    If WinExists(WinGetHandle($GUI5)) Or WinExists(WinGetHandle($GUI6)) Or WinExists(WinGetHandle($GUI7)) Or WinExists(WinGetHandle($GUI8)) Then
        Local $aWinGetPos = WinGetPos($hWnd)
        If @error  Or $aWinGetPos[0] < -30000 Then Return $GUI_RUNDEFMSG
        Local $tWindowPos = DllStructCreate($tagWINDOWPOS, $lParam)
        DllStructSetData($tWindowPos, 'X', $aWinGetPos[0])
        DllStructSetData($tWindowPos, 'Y', $aWinGetPos[1])
        Return $GUI_RUNDEFMSG
    EndIf
EndFunc   ;==>WM_WINDOWPOSCHANGING

Func _CalculRecherche($Array)
	$Nb_Rows = UBound($Array,1)
	$aSearch_Rows = $Nb_Rows
	$aSearch = ""
	Dim $aSearch[$aSearch_Rows]
	For $i = 0 To $aSearch_Rows - 1
		$aSearch[$i] = $i
	Next
EndFunc


