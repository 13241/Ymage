#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; 62px windows taskbar vertical left
; 23px windows title bar
; 8px margin resizable window (width and height)
; => full screen window : +8px outside the screen in every direction (+16px width +16px height)
; => full vertical screen window : -8px inside the screen for title bar(vertical up) (+16px widht, +8px height)
; 5:4 std resolution ratio game
;
; IMPORTANT : text recognition on picture works better if each line has the same height ? Not entirely proved, works better if light pixel on top (1 determinist proof (MIN))
;
; force maximalize window for most accurate resolution

#Persistent
#Include GDIP.ahk
; initialization

CoordMode, Mouse, Screen
height_5_4 := 0
width_5_4 := 0
x_5_4_s := 0
y_5_4_s := 0
effects_index := {}
key_rune := ""
key_blank := ""
key_pa := ""
key_ra := ""
key_poids := ""
locations_index := {}
key_x := ""
key_y := ""
mage_id_w := ""
min_index := []
max_index := []
vef_index := []
def_index := []


Hotkey, !Numpad0, Termination, On
Hotkey, !Numpad1, Calibrate, On
return


; functions
HideTrayTip() ; funHideTrayTip
{
	TrayTip  ; Attempt to hide it the normal way.
	if SubStr(A_OSVersion, 1, 3) = "10." 
	{
		Menu Tray, NoIcon
		Sleep 200  ; It may be necessary to adjust this sleep.
		Menu Tray, Icon
	}
}

Termination() ; funTermination
{
	HideTrayTip()
	TrayTip, , Exiting App
	ExitApp
}

Calibrate() ; funCalibrate
{
	global height_5_4, width_5_4, x_5_4_s, y_5_4_s, mage_id_w, min_index, max_index, vef_index, def_index
	SysGet, width_margin_w, 32 ; window resizable zone, horizontal size
	SysGet, height_margin_w, 33 ; window resizable zone, vertical size
	SysGet, border_w, 4 ; height of window title bar
	SysGet, x_w, MonitorWorkArea ; represents usables coordinates of the screen. four variables, add Left Right Top Bottom to get either of them
	WinMaximize, A ; current window
	WinGetTitle, mage_id_w, A
	WinGetPos, x_tw, y_tw, width_tw, height_tw, A ; positions and sizes of the active window, with all borders and margins
	MouseGetPos, x_m, y_m ; positions of the mouse, reference is the active window (with all borders)
	
	; 1096.25 => black margin 220.875 => 220 black pixel, 221 is colored => +1096 = 1317, px220&px1318 are transluscent (design), 1318->1538 black (margin 62), reasoning with first = 1 (not 0)
	height_5_4 := height_tw - 2 * height_margin_w - border_w
	width_5_4 := height_5_4 / 4 * 5
	x_5_4_s := (x_wLeft - 1) + (width_tw - 2 * width_margin_w - width_5_4) // 2 + 1
	; size of toolbar - 1 (to get position of last pixel) + black border floored + 1px fade = position of first "coloured" pixel
	
	x_5_4_e := x_5_4_s + width_5_4 // 1
	; position of last "coloured" pixel (before last fade px)
	
	y_5_4_s := border_w
	
	ReadFile("runes.csv", "AddToEffects_Index")
	ReadFile("ratio_coordinates.csv", "AddToLocations_Index")
	
	; CaptureImage("min")
	; CaptureImage("max")
	; CaptureImage("eff")
	
	; min_index := StructureOcrResult(ApplyOCR("min"), min_index)
	; max_index := StructureOcrResult(ApplyOCR("max"), max_index)
	; vef_index := StructureOcrResult(ApplyOCR("eff"), vef_index)
	
	; def_index := ConvertToKnownEffects(def_index)
	
	CaptureLastAttemptHistory()
	
	;############################################################################################################################
	
	; test
	; HideTrayTip()
	; TrayTip, , x %x_tw% y %y_tw% width %width_tw% height %height_tw% x_m %x_m% y_m %y_m% x_screen %A_ScreenWidth% y_screen %A_ScreenHeight% width_margin_w %width_margin_w% height_margin_w %height_margin_w% border_w %border_w% toolbar width %x_wLeft%
	; TrayTip, , %width_5_4% %height_5_4% %x_5_4_s% %y_5_4_s%
	; testvar := ConvertToPx(x_5_4_s, 0.582896237, width_5_4, 0.045610034, 1)
	; testvar2 := ConvertToPx(border_w, 0.316989738, height_5_4, 0.038154548, 11)
	; TrayTip, , %testvar% %testvar2%
	
	; test
	; global def_index
	; testvar1 := ""
	; For key, value in def_index
	; {
		; testvar1 := testvar1 . "///" . value
	; }
	; testvar2 := ""
	; For key, value in vef_index
	; {
		; testvar2 := testvar2 . "///" . value
	; }
	; testvar3 := ""
	; For key, value in min_index
	; {
		; testvar3 := testvar3 . "///" . value
	; }
	; testvar4 := ""
	; For key, value in max_index
	; {
		; testvar4 := testvar4 . "///" . value
	; }
	; MsgBox, %testvar1%
	; MsgBox, %testvar2%
	; MsgBox, %testvar3%
	; MsgBox, %testvar4%
	
	; test
	; testvar := 0
	; testvar := LevenshteinDistance("°/o Résistance Neutre", "% Résistance Neutre")
	; MsgBox, %testvar% coucou
	; testvar := LevenshteinDistance("°/o Résistance Neutre", "Résistance Neutre")
	; MsgBox, %testvar% coucou
	
	; test
	; global effects_index
	; testvar := []
	; testvar[1] := "Résistance Pouoeée"
	; testvar[2] := "Do'-|'-|ages Eau"
	; testvar[3] := "°/o Résistance Neutre"
	; testvar := ConvertToKnownEffects(testvar)
	; testvar1 := ""
	; For key, value in testvar
	; {
		; testvar1 := testvar1 . "///" . value
	; }
	; MsgBox, je suis la %testvar1%
	
	; test
	; global effects_index
	; testvar := ""
	; For key, value in effects_index
	; {
		; testvar := testvar . "///" . key
	; }
	; MsgBox, %testvar%
}

ConvertToPx(delta_margin, ratio, reference, delta_ratio := 0, n_delta_ratio := 0) ; funConvertToPx
{
	return delta_margin + ((ratio + n_delta_ratio * delta_ratio) * reference) // 1
}

ReadFile(file_name, func_name) ; funReadFile
{
	file := FileOpen(file_name, "r")
	if(!IsObject(file))
	{
		HideTrayTip()
		TrayTip, , Cant open the file : %file_name%
		return
	}
	while(file.AtEOF = 0)
	{
		cur_line := file.ReadLine()
		%func_name%(cur_line)
		
		; test
		; cur_line := file.ReadLine()
		; %func_name%(cur_line)
		; HideTrayTip()
		; TrayTip, , %cur_line%
		; break
	}
	file.Close()
}

AddToEffects_Index(line) ; funAddToEffects_Index
{
	global effects_index, key_rune, key_blank, key_pa, key_ra, key_poids
	i = 1
	indexes_comma := []
	while(i<6)
	{
		indexes_comma[i] := InStr(line, ",", false, 1, i)
		i := i + 1
	}
	if(key_rune = "")
	{
		key_rune := SubStr(line, 1, indexes_comma[1]-1)
		key_blank := SubStr(line, 1+indexes_comma[2], indexes_comma[3]-indexes_comma[2]-1)
		key_pa := SubStr(line, 1+indexes_comma[3], indexes_comma[4]-indexes_comma[3]-1)
		key_ra := SubStr(line, 1+indexes_comma[4], indexes_comma[5]-indexes_comma[4]-1)
		temp_eol := Substr(line, 1+indexes_comma[5])
		StringReplace, temp_eol, temp_eol, `r, , All
		StringReplace, temp_eol, temp_eol, `n, , All
		key_poids := temp_eol
	}
	else
	{
		effect_key := SubStr(line, 1+indexes_comma[1], indexes_comma[2]-indexes_comma[1]-1)
		effects_index[effect_key] := {}
		effects_index[effect_key][key_rune] := SubStr(line, 1, indexes_comma[1]-1)
		effects_index[effect_key][key_blank] := SubStr(line, 1+indexes_comma[2], indexes_comma[3]-indexes_comma[2]-1)
		effects_index[effect_key][key_pa] := SubStr(line, 1+indexes_comma[3], indexes_comma[4]-indexes_comma[3]-1)
		effects_index[effect_key][key_ra] := SubStr(line, 1+indexes_comma[4], indexes_comma[5]-indexes_comma[4]-1)
		temp_eol := Substr(line, 1+indexes_comma[5])
		StringReplace, temp_eol, temp_eol, `r, , All
		StringReplace, temp_eol, temp_eol, `n, , All
		effects_index[effect_key][key_poids] := temp_eol
	}
	
	; test
	; teststring := ""
	; For key1, value1 in effects_index
	; {
	; 	teststring := teststring . key1
	; 	For key2, value2 in value1
	; 	{
	; 		teststring := teststring . key2 . value2
	; 	}
	; }
	; HideTrayTip()
	; Traytip, , Coucou %teststring%
}

AddToLocations_Index(line) ; funAddToLocations_Index
{
	global locations_index, key_x, key_y
	i = 1
	indexes_comma := []
	while(i<3)
	{
		indexes_comma[i] := InStr(line, ",", false, 1, i)
		i := i + 1
	}
	if(key_x = "")
	{
		key_x := SubStr(line, 1+indexes_comma[1], indexes_comma[2]-indexes_comma[1]-1)
		temp_eol := SubStr(line, 1+indexes_comma[2])
		StringReplace, temp_eol, temp_eol, `r, , All
		StringReplace, temp_eol, temp_eol, `n, , All
		key_y := temp_eol
	}
	else
	{
		location_key := SubStr(line, 1, indexes_comma[1]-1)
		locations_index[location_key] := {}
		locations_index[location_key][key_x] := SubStr(line, 1+indexes_comma[1], indexes_comma[2]-indexes_comma[1]-1)
		temp_eol := SubStr(line, 1+indexes_comma[2])
		StringReplace, temp_eol, temp_eol, `r, , All
		StringReplace, temp_eol, temp_eol, `n, , All
		locations_index[location_key][key_y] := temp_eol
	}
	
	; test
	; teststring := ""
	; For key1, value1 in locations_index
	; {
	; 	teststring := teststring . key1
	; 	For key2, value2 in value1
	; 	{
	; 		teststring := teststring . key2 . value2
	; 	}
	; }
	; HideTrayTip()
	; Traytip, , Coucou %teststring%
}

CaptureImage(pic_name) ; funCaptureImage
{
	global height_5_4, width_5_4, x_5_4_s, y_5_4_s, locations_index
	pToken := Gdip_Startup()
	folderPath := A_ScriptDir "\ScreenShots\"
	fileName := pic_name . ".png" ; A_YYYY "-" A_MM "-" A_DD "-" A_Hour "-" A_Min "-" A_Sec ".png"
	
	key_xy_s := pic_name . "_xy_s"
	key_xy_e := pic_name . "_xy_e"
	x_s := ConvertToPx(x_5_4_s, locations_index[key_xy_s]["X"], width_5_4)
	y_s := ConvertToPx(y_5_4_s, locations_index[key_xy_s]["Y"], height_5_4)
	width := ConvertToPx(x_5_4_s, locations_index[key_xy_e]["X"], width_5_4) - x_s
	height := ConvertToPx(y_5_4_s, locations_index[key_xy_e]["Y"], height_5_4) - y_s
	
	location := x_s . "|" . y_s . "|" . width . "|" . height
	
	pBitmap := Gdip_BitmapFromScreen(location)
	saveFileTo := folderPath fileName                   
	Gdip_SaveBitmapToFile(pBitmap, saveFileTo)
	Gdip_DisposeImage(pBitmap)
	
	Gdip_Shutdown(pToken)
	
	; test
	; HideTrayTip()
	; TrayTip, , Coucou %location%
}

ApplyOCR(pic_name) ; funApplyOCR
{
	IfWinExist, FreeOCR
	{
		WinActivate, FreeOCR
		SendInput !{f}
		SendInput {Enter}
		WinWaitActive, Select Image to OCR
		SendInput {Raw}%pic_name%.png
		SendInput {F4}
		SendInput {Down}
		SendInput {BackSpace}
		SendInput {Raw}%A_ScriptDir%\ScreenShots
		SendInput {Enter}
		WinWaitActive, Barre d'adresses, , 0
		IfWinExist, Barre d'adresses
		{
			SendInput {Enter}
			SendInput {F6}
			SendInput {Escape}
			return ApplyOCR(pic_name)
		}
		else
		{
			SendInput {Enter 3}
			WinWaitActive, FreeOCR, , 0
			while(ErrorLevel)
			{
				SendInput {Enter 3}
				WinWaitActive, FreeOCR, , 0
			}
		}
		SendInput !{t}
		SendInput {Enter}
		SendInput !{o}
		SendInput {Enter}
		clipboard=
		ClipWait, 0
		SendInput !{t}
		SendInput {c}
		SendInput {Enter}
		while(ErrorLevel)
		{
			ClipWait, 0
		}
		ocr_result := clipboard
		comma := ","
		StringReplace, ocr_result, ocr_result, `r, %comma% , All
		StringReplace, ocr_result, ocr_result, `n, %comma% , All
		StringReplace, ocr_result, ocr_result, %comma%%comma%, %comma%, All
		
		; test
		; MsgBox, %ocr_result%
		
		return ocr_result
	}
	else
	{
		HideTrayTip()
		TrayTip, , FreeOCR app must be running
		return ""
	}
}

StructureOcrResult(expression, container) ; funStructureOcrResult
{
	global def_index
	container := []
	parts := StrSplit(expression, ",")
	i := 0
	For index, value in parts
	{
		if(index = 1 or value = "")
		{
			continue
		}
		else if value is integer
		{
			i := i + 1
			container[i] := value
		}
		else
		{
			if(index = 2)
			{
				def_index := []
			}
			position := InStr(value, "%", false, 1, 1)
			if(position)
			{
				nbr := SubStr(value, 1, position - 1)
				if nbr is integer
				{
					i := i + 1
					container[i] := nbr
					def_index[i] := SubStr(value, position)
					continue
				}
			}
			position := InStr(value, " ", false, 1, 1)
			if(position)
			{
				nbr := SubStr(value, 1, position - 1)
				if nbr is integer
				{
					i := i + 1
					container[i] := nbr
					def_index[i] := SubStr(value, position + 1)
					continue
				}
			}
			i := i + 1
			container[i] := "0"
			def_index[i] := value
		}
	}
	return container
}

LevenshteinDistance(word, ref) ; funLevenshteinDistance
{
	distance := 0
	big := ""
	small := ""
	if(StrLen(word) >= StrLen(ref))
	{
		StringLower, big, word
		StringLower, small, ref
	}
	else
	{
		StringLower, big, ref
		StringLower, small, word
	}
	len_big := StrLen(big)
	len_small := StrLen(small)
	tampon := len_big - len_small
	i_small := 1
	i_big := 1
	while(i_big <= len_big)
	{
		if(i_small <= len_small)
		{
			if(SubStr(big, i_big, 1) != SubStr(small, i_small, 1))
			{
				distance := distance + 1
				if(tampon>0)
				{
					i_small := i_small - 1
					tampon := tampon - 1
				}
			}
		}
		else
		{
			distance := distance + 1
		}
		i_small := i_small + 1
		i_big := i_big + 1
	}
	return distance
}

ConvertToKnownEffects(ocr_def_index) ; funConvertToKnownEffects
{
	global effects_index
	For i_ocr_effect, ocr_effect in ocr_def_index
	{
		distance := 0
		len_ocr_effect := StrLen(ocr_effect)
		match := ""
		len_match := StrLen(match)
		while(distance <= len_ocr_effect and match = "")
		{
			partial_dist := 0
			while(partial_dist <= distance)
			{
				For effect, values in effects_index
				{
					len_effect := StrLen(effect)
					if(len_effect = len_ocr_effect + partial_dist or len_effect = len_ocr_effect - partial_dist)
					{
						if(LevenshteinDistance(ocr_effect, effect) = distance)
						{
							if(len_effect > len_match)
							{
								match := effect
								len_match := StrLen(match)
								ocr_def_index[i_ocr_effect] := effect
							}
						}
					}
				}
				partial_dist := partial_dist + 1
			}
			distance := distance + 1
		}
	}
	return ocr_def_index
}

CaptureLastAttemptHistory() ; funCaptureLastAttemptHistory
{
	global height_5_4, width_5_4, x_5_4_s, y_5_4_s, locations_index
	key_xy_s := "his_xy_s"
	key_x_e := "his_x_e"
	key_y_e := "his_y_e"
	x_s := ConvertToPx(x_5_4_s, locations_index[key_xy_s]["X"], width_5_4)
	y_s := ConvertToPx(y_5_4_s, locations_index[key_xy_s]["Y"], height_5_4)
	x_e := ConvertToPx(x_5_4_s, locations_index[key_x_e]["X"], width_5_4)
	y_e := ConvertToPx(y_5_4_s, locations_index[key_y_e]["Y"], height_5_4)
	
	SendInput {Click Down %x_s% %y_s%}
	SendInput {Click Up %x_e% %y_e%}
	clipboard=
	ClipWait, 0
	SendInput ^{c}
	while(ErrorLevel)
	{
		ClipWait, 0
	}
	history_result := clipboard
	
	dot_comma := ";"
	StringReplace, history_result, history_result, `r, %dot_comma% , All
	StringReplace, history_result, history_result, `n, %dot_comma% , All
	StringReplace, history_result, history_result, %dot_comma%%dot_comma%, %dot_comma%, All
	
	index_last_line := InStr(history_result, ";", false, -1, 1)
	last_line := SubStr(history_result, index_last_line + 1)
	return last_line
}