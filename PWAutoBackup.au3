#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=ICO\backup.ico
#AutoIt3Wrapper_Outfile=PWAutoBackup.exe
#AutoIt3Wrapper_Outfile_x64=PWAutoBackup_x64.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Res_Description=Password Manager auto backup
#AutoIt3Wrapper_Res_Fileversion=1.0
#AutoIt3Wrapper_Res_ProductName=PWautoBackup
#AutoIt3Wrapper_Res_ProductVersion=1.0
#AutoIt3Wrapper_Res_CompanyName=https://github.com/yann83
#AutoIt3Wrapper_Res_LegalCopyright=MIT licence
#AutoIt3Wrapper_Res_Language=1036
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.14.1
 Auteur:         yann83

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

; Début du script - Ajouter votre code ci-dessous.
#include <File.au3>

Global $NomProg = StringTrimRight(@ScriptName,4)
Global $BackupLogfile = @ScriptDir & "\" & $NomProg & ".log"
Global $Arch64 = @AutoItX64
Global $SQLiniPath,$GetDay

If $Arch64 = 1 Then
	$SQLiniPath = @ScriptDir & "\Password_Manager_x64.ini"
Else
	$SQLiniPath = @ScriptDir & "\Password_Manager.ini"
EndIf

Global $FileToBackup = IniRead($SQLiniPath,"PATH","DBName","")

Global $JourDeLaSemaine = @WDAY
Global $NumDay = @YEAR&@MON&@MDAY
Global $BackupDir = @ScriptDir & "\Backup"
If FileExists($BackupDir) = 0 Then DirCreate($BackupDir)

Global $ListDirBackup = _FileListToArray($BackupDir,"*.bak",$FLTA_FILES,False)
If Not @error Then
	For $i = 1 to $ListDirBackup[0] Step 1
		$GetDay = StringLeft($ListDirBackup[$i],1)
		If $GetDay = $JourDeLaSemaine Then
			FileDelete($BackupDir & "\" & $ListDirBackup[$i])
			ExitLoop
		EndIf
	Next
EndIf
Global $ret = FileCopy(@ScriptDir & "\" & $FileToBackup,$BackupDir & "\" & $JourDeLaSemaine & "_" & $NumDay & "_" & $FileToBackup & ".bak",9)
If $ret = 0 Then _FileWriteLog($BackupLogfile,"Echec de la sauvegarde de la base de donnée : " & $FileToBackup)
