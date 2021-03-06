#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include capture.ahk

;function
TestApplyAttemptChanges() ; funTestApplyAttemptChanges()
{
	global vef_index, def_index, reliquat, min_index, max_index
	ApplyAttemptChanges(3, "R�sistance Pouss�e")
	testvar := ""
	For index, value in vef_index
	{
		testvar := testvar . "///" . value . " " . def_index[index] . "_min_" . min_index[index] . "_max_" . max_index[index]
	}
	MsgBox, reliquat_%reliquat%%testvar%
}

TestRfs() ; funTestRfs
{
	global effects_index, locations_index, floors_index, final_floors_index, tolerances_index, max_index, min_index, vef_index, def_index
		, instructions_index, modif_max_index, reliquat, more_additional_index, trash_bin, destroyer_effect, reliquat_exception
	testvar1 := ""
	; For index, effect in objectives_index
	; {
		; testvar1 := testvar1 . "///" . index
		; For key, value in effect
		; {
			; if(IsOBject(value))
			; {
				; testvar1 := testvar1 . "---" . key
				; For subkey, subvalue in value
				; {
					; testvar1 := testvar1 . "___" . subvalue
				; }
			; }
			; else
			; {
				; testvar1 := testvar1 . "---" . key . "___" . value
			; }
		; }
	; }
	; CalibrateInstructions()
	For index, final_floors in def_index
	{
		testvar1 := testvar1 . "///" . final_floors . "___" . vef_index[index] . "___" . min_index[index] . "___" . max_index[index] . "___" . modif_max_index[index]
		For _priority, value in more_additional_index
		{
			testvar1 := testvar1 . "___" . value[index]
		}
	}
	testvar1 := testvar1 . "///reliquat___" . reliquat
	For index, trash in trash_bin
	{
		testvar1 := testvar1 . "///trash___" . trash
	}
	testvar1 := testvar1 . "///destroyer___" . destroyer_effect
	testvar1 := testvar1 . "///reliquat exception___" . reliquat_exception
	MsgBox, %testvar1%
}

TestLevenshteinDistance() ; funTestLevenshteinDistance
{
	a := "R�sistanoe Pous�e"
	b := "R�sistance Pouss�e"
	c := LevenshteinDistance(a, b)
	testvar := a . "_" . b . "_" . c
	MsgBox, %testvar%
}