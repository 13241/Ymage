#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include capture.ahk

;function
TestConvertToReliquat() ; funTestConvertToReliquat
{
	testvar := ConvertToReliquat(5, "% Résistance Terre")
	MsgBox, cout 5 pourcent resistance terre %testvar%
}

TestApplyAttemptChanges() ; funTestApplyAttemptChanges()
{
	global vef_index, def_index, reliquat, min_index, max_index
	ApplyAttemptChanges(3, "Résistance Poussée")
	testvar := ""
	For index, value in vef_index
	{
		testvar := testvar . "///" . value . " " . def_index[index] . "_min_" . min_index[index] . "_max_" . max_index[index]
	}
	MsgBox, reliquat_%reliquat%%testvar%
}