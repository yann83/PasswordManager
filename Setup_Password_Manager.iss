#define MyAppName "PasswordManager"
#define MyAppVersion "1.5"
#define MyAppPublisher "yann83"
#define MyAppExeName "Password_Manager"
#define MyDefaultDirName "C:\"+MyAppName
#define MySubkey "SOFTWARE\"+MyAppPublisher+"\"+MyAppName
#define MySubKeyVersion MySubkey+"\"+MyAppVersion
#define AppId "4E2891A1-2098-4339-95A4-270E8407F924"

[Setup]
AppId={#AppId}
AppMutex={#AppId}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={#MyDefaultDirName}
DisableDirPage=yes
DefaultGroupName={#MyAppName}
OutputDir=.\
OutputBaseFilename=Setup_{#MyAppName}_{#MyAppVersion}
Compression=lzma
SolidCompression=yes
LicenseFile=licence.txt

[Languages]
Name: french; MessagesFile: compiler:Languages\French.isl

[Files]
Source: "{#MyAppExeName}.exe"; DestDir: "{app}"; Flags: ignoreversion ; Check: Not IsWin64
Source: "{#MyAppExeName}_x64.exe"; DestDir: "{app}"; Flags: ignoreversion; Check: IsWin64
Source: "PWAutoBackup.exe"; DestDir: "{app}"; Flags: ignoreversion  ; Check: Not IsWin64
Source: "PWAutoBackup_x64.exe"; DestDir: "{app}"; Flags: ignoreversion; Check: IsWin64

[Icons]
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}_x64.exe}"; Check: IsWin64
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}.exe}" ; Check: Not IsWin64

[Registry]
Root: "HKLM32"; Subkey: "{#MySubkey}"; ValueType: string; ValueName: "CurrentVersion"; ValueData: "{#MyAppVersion}"; Flags: deletekey deletevalue; MinVersion: 0.0,5.0; Check: Not IsWin64
Root: "HKLM32"; Subkey: "{#MySubKeyVersion}"; Flags: uninsdeletekey createvalueifdoesntexist; MinVersion: 0.0,5.0; Check: Not IsWin64
Root: "HKLM32"; Subkey: "{#MySubKeyVersion}"; ValueType: string; ValueName: "InstallDate"; ValueData: "{code:Madate}"; Flags: uninsdeletekey createvalueifdoesntexist; MinVersion: 0.0,5.0; Check: Not IsWin64
Root: "HKLM32"; Subkey: "{#MySubKeyVersion}"; ValueType: string; ValueName: "InstallDir"; ValueData: "{#MyDefaultDirName}"; Flags: uninsdeletekey createvalueifdoesntexist; MinVersion: 0.0,5.0 ; Check: Not IsWin64
Root: "HKLM32"; Subkey: "{#MySubKeyVersion}"; ValueType: string; ValueName: "Package"; ValueData: "{#MyAppName} {#MyAppVersion}"; Flags: uninsdeletekey createvalueifdoesntexist; MinVersion: 0.0,5.0  ; Check: Not IsWin64
Root: "HKLM32"; Subkey: "{#MySubKeyVersion}"; ValueType: string; ValueName: "Publisher"; ValueData: "{#MyAppPublisher}"; Flags: uninsdeletekey createvalueifdoesntexist; MinVersion: 0.0,5.0 ; Check: Not IsWin64
Root: "HKLM32"; Subkey: "{#MySubkey}"; ValueType: string; ValueName: "CurrentVersion"; ValueData: "{#MyAppVersion}"; Flags: uninsdeletekey createvalueifdoesntexist; MinVersion: 0.0,5.0 ; Check: Not IsWin64

Root: "HKLM64"; Subkey: "{#MySubkey}"; ValueType: string; ValueName: "CurrentVersion"; ValueData: "{#MyAppVersion}"; Flags: deletekey deletevalue; MinVersion: 0.0,5.0; Check: IsWin64
Root: "HKLM64"; Subkey: "{#MySubKeyVersion}"; Flags: uninsdeletekey createvalueifdoesntexist; MinVersion: 0.0,5.0; Check: IsWin64
Root: "HKLM64"; Subkey: "{#MySubKeyVersion}"; ValueType: string; ValueName: "InstallDate"; ValueData: "{code:Madate}"; Flags: uninsdeletekey createvalueifdoesntexist; MinVersion: 0.0,5.0; Check: IsWin64
Root: "HKLM64"; Subkey: "{#MySubKeyVersion}"; ValueType: string; ValueName: "InstallDir"; ValueData: "{#MyDefaultDirName}"; Flags: uninsdeletekey createvalueifdoesntexist; MinVersion: 0.0,5.0 ; Check: IsWin64
Root: "HKLM64"; Subkey: "{#MySubKeyVersion}"; ValueType: string; ValueName: "Package"; ValueData: "{#MyAppName} {#MyAppVersion}"; Flags: uninsdeletekey createvalueifdoesntexist; MinVersion: 0.0,5.0  ; Check: IsWin64
Root: "HKLM64"; Subkey: "{#MySubKeyVersion}"; ValueType: string; ValueName: "Publisher"; ValueData: "{#MyAppPublisher}"; Flags: uninsdeletekey createvalueifdoesntexist; MinVersion: 0.0,5.0 ; Check: IsWin64
Root: "HKLM64"; Subkey: "{#MySubkey}"; ValueType: string; ValueName: "CurrentVersion"; ValueData: "{#MyAppVersion}"; Flags: uninsdeletekey createvalueifdoesntexist; MinVersion: 0.0,5.0 ; Check: IsWin64

[Code]
function MaDate(Param:String): String;
begin
	result := GetDateTimeString('dd/mm/yyyy','/',':');
end;
