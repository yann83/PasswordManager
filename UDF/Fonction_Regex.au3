#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.14.1
 Auteur:         yann83 https://github.com/yann83

 #ce ----------------------------------------------------------------------------

#include-once
;((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%]).{6,20})

;(			# Start of group
;  (?=.*\d)		#   must contains one digit from 0-9
;  (?=.*[a-z])		#   must contains one lowercase characters
;  (?=.*[A-Z])		#   must contains one uppercase characters
;  (?=.*[@#$%!])		#   must contains one special symbols in the list "@#$%"
;              .		#     match anything with previous condition checking
;                {6,12}	#        length at least 6 characters and maximum of 12
;)			# End of group


Func _PwdCheckComplexity($VerifiyPassword)
	;Local $PwdMatch = StringRegExp($VerifiyPassword, '((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%!]).{6,12})')
	Local $PwdMatch = StringRegExp($VerifiyPassword, '((?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{20,32})');sans caracteres speciaux et au moins 20 char et max 32 char
	Return ($PwdMatch)
EndFunc

Func _IsValidURL($url)
	Local $IsValid = StringRegExp($url,"^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$")
	Return ($IsValid)
EndFunc	;=>_IsValidURL

Func _IsPathValid($Path)
	Local $IsValid = StringRegExp($Path,"([\w{1}|\\\\]\:?\\?)(...*\\?...*)");match C:\test\applinat ou \\test mais pas C:\ ou \\
	Return ($IsValid)
EndFunc ;=>_IsPath



