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
CoordMOde, Pixel, Screen

; ###############################################################################################################################
testing := "TestRfs"
; ###############################################################################################################################

mage_id_w := ""
height_5_4 := 0
width_5_4 := 0
x_5_4_s := 0
y_5_4_s := 0
hex_color_rune := ""
hex_color_fusion := ""

effects_index := {}
key_rune := ""
key_blank := ""
key_pa := ""
key_ra := ""
key_pwr := ""

locations_index := {}
key_x := ""
key_y := ""

floors_index := {}
key_stdfloors := ""
key_basic_std := ""
key_pa_std := ""
key_basic_spe := ""
key_pa_spe := ""
key_pa_delta := ""
key_ra_delta := ""

final_floors_index := []
tolerances_index := []

min_index := []
max_index := []
vef_index := []
def_index := []
reliquat := 0
prospection_exception := false

rf_runes := "runes.csv"
rf_coordinates := "ratio_coordinates.csv"
rf_floors := "palliers.csv"
rf_final_floors := "finalisation.csv"
pic_min := "min"
pic_max := "max"
pic_effect := "eff"

Hotkey, !Numpad0, Termination, On
Hotkey, !Numpad1, Calibrate, On
Hotkey, !Numpad2, %testing%, On
Hotkey, !Numpad3, MainRoutine, On
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
	global height_5_4, width_5_4, x_5_4_s, y_5_4_s, mage_id_w, min_index, max_index, vef_index, def_index, rf_runes, rf_coordinates, rf_floors, rf_final_floors, pic_min, pic_max, pic_effect, hex_color_rune, hex_color_fusion, locations_index, key_x, key_y
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
	
	ReadFile(rf_runes, "AddToEffects_Index")
	ReadFile(rf_coordinates, "AddToLocations_Index")
	ReadFile(rf_floors, "AddToFloors_Index")
	ReadFile(rf_final_floors, "AddToFinalFloors_Tolerances_Index")
	
	key_color_xy := "col_xy"
	x_no_rune := ConvertToPx(x_5_4_s, locations_index[key_color_xy][key_x], width_5_4)
	y_no_rune := ConvertToPx(y_5_4_s, locations_index[key_color_xy][key_y], height_5_4)
	PixelGetColor, hex_color_rune, %x_no_rune%, %y_no_rune%
	key_fus_xy := "fus_xy"
	x_fus := ConvertToPx(x_5_4_s, locations_index[key_fus_xy][key_x], width_5_4)
	y_fus := ConvertToPx(y_5_4_s, locations_index[key_fus_xy][key_y], height_5_4)
	PixelGetColor, hex_color_fusion, %x_fus%, %y_fus%
	
	CaptureImage(pic_min)
	CaptureImage(pic_max)
	CaptureImage(pic_effect)
	
	min_index := StructureOcrResult(ApplyOCR(pic_min), min_index)
	max_index := StructureOcrResult(ApplyOCR(pic_max), max_index)
	vef_index := StructureOcrResult(ApplyOCR(pic_effect), vef_index)
	
	def_index := ConvertToKnownEffects(def_index)
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
	}
	file.Close()
}

AddToEffects_Index(line) ; funAddToEffects_Index
{
	global effects_index, key_rune, key_blank, key_pa, key_ra, key_pwr
	StringReplace, line, line, `r, , All
	StringReplace, line, line, `n, , All
	keys := StrSplit(line, ",")
	if(key_rune = "")
	{
		key_rune := keys[1]
		key_blank := keys[3]
		key_pa := keys[4]
		key_ra := keys[5]
		key_pwr := keys[6]
	}
	else
	{
		effects_index[keys[2]] := {}
		effects_index[keys[2]][key_rune] := keys[1]
		effects_index[keys[2]][key_blank] := keys[3]
		effects_index[keys[2]][key_pa] := keys[4]
		effects_index[keys[2]][key_ra] := keys[5]
		effects_index[keys[2]][key_pwr] := keys[6]
	}
}

AddToLocations_Index(line) ; funAddToLocations_Index
{
	global locations_index, key_x, key_y
	StringReplace, line, line, `r, , All
	StringReplace, line, line, `n, , All
	keys := StrSplit(line, ",")
	if(key_x = "")
	{
		key_x := keys[2]
		key_y := keys[3]
	}
	else
	{
		locations_index[keys[1]] := {}
		locations_index[keys[1]][key_x] := keys[2]
		locations_index[keys[1]][key_y] := keys[3]
	}
}

AddToFloors_Index(line) ; funAddToFloors_Index
{
	global floors_index, key_stdfloors, key_basic_std, key_basic_spe, key_pa_std, key_pa_spe, key_pa_delta, key_ra_delta
	StringReplace, line, line, `r, , All
	StringReplace, line, line, `n, , All
	keys := StrSplit(line, ",")
	if(key_stdfloors = "")
	{
		key_stdfloors := keys[2]
		key_basic_std := keys[3]
		key_pa_std := keys[4]
		key_basic_spe := keys[5]
		key_pa_spe := keys[6]
		key_pa_delta := keys[7]
		key_ra_delta := keys[8]
	}
	else
	{
		floors_index[keys[1]] := {}
		floors_index[keys[1]][key_stdfloors] := keys[2]
		floors_index[keys[1]][key_basic_std] := keys[3]
		floors_index[keys[1]][key_pa_std] := keys[4]
		floors_index[keys[1]][key_basic_spe] := keys[5]
		floors_index[keys[1]][key_pa_spe] := keys[6]
		floors_index[keys[1]][key_pa_delta] := keys[7]
		floors_index[keys[1]][key_ra_delta] := keys[8]
	}
}

AddToFinalFloors_Tolerances_Index(line) ; funAddToFinalFloors_Tolerances_Index
{
	global final_floors_index, tolerances_index
	StringReplace, line, line, `r, , All
	StringReplace, line, line, `n, , All
	keys := StrSplit(line, ",")
	floor_value := keys[1]
	if floor_value is integer
	{
		final_floors_index.Push(keys[1])
		tolerances_index.Push(keys[2])
	}
}

CaptureImage(pic_name) ; funCaptureImage
{
	global height_5_4, width_5_4, x_5_4_s, y_5_4_s, locations_index, key_x, key_y
	pToken := Gdip_Startup()
	folderPath := A_ScriptDir "\ScreenShots\"
	fileName := pic_name . ".png" ; A_YYYY "-" A_MM "-" A_DD "-" A_Hour "-" A_Min "-" A_Sec ".png"
	
	key_xy_s := pic_name . "_xy_s"
	key_xy_e := pic_name . "_xy_e"
	x_s := ConvertToPx(x_5_4_s, locations_index[key_xy_s][key_x], width_5_4)
	y_s := ConvertToPx(y_5_4_s, locations_index[key_xy_s][key_y], height_5_4)
	width := ConvertToPx(x_5_4_s, locations_index[key_xy_e][key_x], width_5_4) - x_s
	height := ConvertToPx(y_5_4_s, locations_index[key_xy_e][key_y], height_5_4) - y_s
	
	location := x_s . "|" . y_s . "|" . width . "|" . height
	
	pBitmap := Gdip_BitmapFromScreen(location)
	saveFileTo := folderPath fileName                   
	Gdip_SaveBitmapToFile(pBitmap, saveFileTo)
	Gdip_DisposeImage(pBitmap)
	
	Gdip_Shutdown(pToken)
}

ApplyOCR(pic_name) ; funApplyOCR
{
	global mage_id_w
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
		
		WinActivate, %mage_id_w%
		
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
	global def_index, max_index, min_index
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
					if(!max_index.HasKey(i))
					{
						max_index[i] := 0
						min_index[i] := 0
					}
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
					if(!max_index.HasKey(i))
					{
						max_index[i] := 0
						min_index[i] := 0
					}
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
	global height_5_4, width_5_4, x_5_4_s, y_5_4_s, locations_index, key_x, key_y
	key_xy_s := "his_xy_s"
	key_x_e := "his_x_e"
	key_y_e := "his_y_e"
	x_s := ConvertToPx(x_5_4_s, locations_index[key_xy_s][key_x], width_5_4)
	y_s := ConvertToPx(y_5_4_s, locations_index[key_xy_s][key_y], height_5_4)
	x_e := ConvertToPx(x_5_4_s, locations_index[key_x_e][key_x], width_5_4)
	y_e := ConvertToPx(y_5_4_s, locations_index[key_y_e][key_y], height_5_4)
	
	SendInput {Click Down %x_s% %y_s%}
	Sleep, 50
	SendInput {Click Up %x_e% %y_e%}
	Sleep, 50
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
	
	cut_history_result := StrSplit(history_result, dot_comma)
	last_line := []
	For index, value in cut_history_result
	{
		last_line.InsertAt(1, value)
	}
	return last_line
}

ApplyAttemptChanges(attempt_value, attempt_effect) ; funApplyAttemptChanges
{
	global reliquat, vef_index, def_index, min_index, max_index
	lines_changes := CaptureLastAttemptHistory()
	line_changes := lines_changes[1]
	changes := StrSplit(line_changes, ", ")
	found_reliquat := false
	tampon_reliquat := 0
	For index, change in changes
	{
		if(change = "Échec")
		{
			break
		}
		else if(InStr(change, "reliquat"))
		{
			tampon_reliquat := tampon_reliquat + ConvertToReliquat(attempt_value, attempt_effect)
			found_reliquat := true
		}
		else
		{
			value := 0
			effect := ""
			position := InStr(change, "%")
			if(position)
			{
				value := SubStr(change, 1, position - 1)
				effect := SubStr(change, position)
			}
			else
			{
				position := InStr(change, " ")
				if(position)
				{
					value := SubStr(change, 1, position - 1)
					effect := SubStr(change, position + 1)
				}
			}
			if value is not integer
			{
				MsgBox, fatal calculation _error
				return
			}
			if(effect = "")
			{
				MsgBox, fatal _error unknown effect
				return
			}
			else
			{
				if(InStr(change, "-"))
				{
					tampon_reliquat := tampon_reliquat + ConvertToReliquat(value, effect)
				}
				i_ef_index := HasValue(def_index, effect)
				if(i_ef_index)
				{
					vef_index[i_ef_index] := vef_index[i_ef_index] + value
					if(max_index[i_ef_index] = 0 and vef_index[i_ef_index] = 0 and min_index[i_ef_index] = 0)
					{
						max_index.RemoveAt(i_ef_index)
						min_index.RemoveAt(i_ef_index)
						vef_index.RemoveAt(i_ef_index)
						def_index.RemoveAt(i_ef_index)
					}
				}
				else
				{
					vef_index.Push(value)
					def_index.Push(effect)
					min_index.Push(0)
					max_index.Push(0)
				}
			}
		}
	}
	if(found_reliquat)
	{
		reliquat := reliquat + tampon_reliquat
	}
}

ConvertToReliquat(value, effect) ; funConvertToReliquat
{
	global effects_index, vef_index, def_index, key_pwr
	i := HasValue(def_index, effect)
	eff_reliquat := 0
	vef := 0
	if(i)
	{
		vef := vef_index[i]
	}
	if(effects_index.HasKey(effect))
	{
		if(vef < -1)
		{
			if(vef + value <= -1)
			{
				eff_reliquat := -1 * effects_index[effect][key_pwr] * value / 2
			}
			else
			{
				pos_value := value + vef + 1
				neg_value := -1 * (vef + 1)
				eff_reliquat := -1 * effects_index[effect][key_pwr] * (neg_value / 2 + pos_value)
			}
		}
		else
		{
			if(vef + value < -1)
			{
				pos_value := -1 * (vef + 1)
				neg_value := value + vef + 1
				eff_reliquat := -1 * effects_index[effect][key_pwr] * (neg_value / 2 + pos_value)
			}
			else
			{
				eff_reliquat := -1 * effects_index[effect][key_pwr] * value
			}
		}
	}
	return eff_reliquat
}

HasValue(haystack, needle) ; funHasValue
{
	if(!IsObject(haystack) or haystack.Length() = 0)
	{
		return 0
	}
	else
	{
		For index, value in haystack
		{
			if(value = needle)
			{
				return index
			}
		}
		return 0
	}
}

; objective may be substracted by the adequate tolerance value, the function will try to do better than this adapted objective, while 
; staying below the max value of the item (unless the objective is above the max value, in this case it will never do better than the 
; objective
; a changer : selection de l'effet : il doit anticiper qu'il ne pourra pas monter le jet plus haut lors de la selection de l'effet
; il doit s'en foutre de la prospection (entre autres)
ChooseRune(objective, adapted := true) ; funChooseRune
{
	global max_index, min_index, effects_index, key_blank, key_pa, key_ra, key_pwr, def_index, vef_index, floors_index, key_stdfloors, key_basic_std, key_basic_spe, key_pa_std, key_pa_spe, final_floors_index, tolerances_index, prospection_exception, reliquat
	adapted_objective := []
	if(adapted)
	{
		For index, value in objective
		{
			tolerance := 0
			For i_floor, final_floor in final_floors_index
			{
				if(value >= final_floor)
				{
					tolerance := tolerances_index[i_floor]
					break
				}
			}
			adapted_value := value - tolerance
			adapted_objective.InsertAt(index, adapted_value)
		}
	}
	else
	{
		adapted_objective := objective
	}
	effect := ""
	pwr_effect := 0
	delta_value := 0
	max_delta_value := 0
	max_value := 0
	current_value := 0
	For index, def in def_index
	{
		if(def = "Prospection")
		{
			if(reliquat > 9)
			{
				prospection_exception := false
			}
			else if((vef_index[index] = 0 and reliquat < 1) or prospection_exception)
			{
				temp_max_value := 0
				if(max_index[index] >= min_index[index] + 2)
				{
					temp_max_value := min_index[index] + 2
				}
				else
				{
					temp_max_value := min_index[index]
				}
				if(vef_index[index] >= temp_max_value - 2)
				{
					prospection_exception := false
					continue
				}
				else
				{
					if(!prospection_exception)
					{
						prospection_exception := true
					}
					effect := def
					max_value := temp_max_value
					pwr_effect := effects_index[def][key_pwr]
					delta_value := max_value - vef_index[index]
					max_delta_value := max_value - vef_index[index]
					current_value := vef_index[index]
					break
				}
			}
		}
		else if(vef_index[index] < adapted_objective[index])
		{
			minimal_delta := 0
			ra := effects_index[def][key_ra]
			pa := effects_index[def][key_pa]
			blank := effects_index[def][key_blank]
			if(max_index[index] > floors_index[effects_index[def][key_pwr]][key_stdfloors])
			{
				if(vef_index[index] + blank <= floors_index[effects_index[def][key_pwr]][key_basic_spe])
				{
					minimal_delta := blank
				}
				else if(pa != "" and vef_index[index] + pa <= floors_index[effects_index[def][key_pwr]][key_pa_spe])
				{
					minimal_delta := pa
				}
			}
			else
			{
				if(vef_index[index] + blank <= floors_index[effects_index[def][key_pwr]][key_basic_std])
				{
					minimal_delta := blank
				}
				else if (pa != "" and vef_index[index] + pa <= floors_index[effects_index[def][key_pwr]][key_pa_std])
				{
					minimal_delta := pa
				}
			}
			if(minimal_delta = 0)
			{
				if(ra != "")
				{
					minimal_delta := ra
				}
				else
				{
					minimal_delta := adapted_objective[index]
				}
			}
			if(minimal_delta <= adapted_objective[index] - vef_index[index])
			{
				if((effects_index[def][key_pwr] = pwr_effect and adapted_objective[index] - vef_index[index] > delta_value) or effects_index[def][key_pwr] > pwr_effect)
				{
					if(!(def = "Sagesse" and minimal_delta + vef_index[index] = max_index[index]))
					{
						effect := def
						pwr_effect := effects_index[def][key_pwr]
						delta_value := adapted_objective[index] - vef_index[index]
						max_delta_value := max_index[index] - vef_index[index]
						max_value := max_index[index]
						current_value := vef_index[index]
						if(max_delta_value < delta_value)
						{
							std_delta_value := floors_index[pwr_effect][key_stdfloors] - vef_index[index]
							if(delta_value < std_delta_value)
							{
								max_delta_value := delta_value
							}
							else
							{
								delta_value := std_delta_value
								max_delta_value := std_delta_value
							}
						}
					}
				}
			}
		}
	}
	if(effect = "")
	{
		return [0, ""]
	}
	else
	{
		value := 0
		ra := effects_index[effect][key_ra]
		pa := effects_index[effect][key_pa]
		blank := effects_index[effect][key_blank]
		floor_basic := 0
		floor_pa := 0
		if(max_value > floors_index[pwr_effect][key_stdfloors])
		{
			floor_basic := floors_index[pwr_effect][key_basic_spe]
			floor_pa := floors_index[pwr_effect][key_pa_spe]
		}
		else
		{
			floor_basic := floors_index[pwr_effect][key_basic_std]
			floor_pa := floors_index[pwr_effect][key_pa_std]
		}
		if(adapted)
		{
			if(ra != "" and ra <= max_delta_value)
			{
				value := ra
			}
			else if(pa != "" and (pa < max_delta_value or (pa = max_delta_value and current_value + blank > floor_basic)))
			{
				value := pa
			}
			else
			{
				value := blank
			}
		}
		else
		{
			if(current_value + blank <= floor_basic and blank <= delta_value)
			{
				value := blank
			}
			else if(pa != "" and current_value + pa <= floor_pa and pa <= delta_value)
			{
				value := pa
			}
			else if(ra != "" and ra <= delta_value)
			{
				value := ra
			}
		}
		return [value, effect]
	}
}

; a changer, trouver une methode pour attendre suffisamment mais pas trop (placement de rune et collecte d'informations)
UseRune(value, effect) ; funUseRune
{
	global height_5_4, width_5_4, x_5_4_s, y_5_4_s, locations_index, key_x, key_y, def_index, effects_index, key_blank, key_pa, key_ra, hex_color_rune, hex_color_fusion
	y_index := HasValue(def_index, effect)
	key_xy_s := "run_xy_s"
	key_x_e := "run_x_e"
	key_y_e := "run_y_e"
	key_x_d := "run_x_d"
	key_y_d := "run_y_d"
	y := ConvertToPx(y_5_4_s, locations_index[key_xy_s][key_y], height_5_4, locations_index[key_y_d][key_y], y_index - 1)
	x_index := 0
	if(effects_index[effect][key_blank] = value)
	{
		x_index := 1
	}
	else if(effects_index[effect][key_pa] = value)
	{
		x_index := 2
	}
	else if(effects_index[effect][key_ra] = value)
	{
		x_index := 3
	}
	if(index = 0)
	{
		MsgBox, Fatal _error _no rune found
		return
	}
	x := ConvertToPx(x_5_4_s, locations_index[key_xy_s][key_x], width_5_4, locations_index[key_x_d][key_x], x_index - 1)
	
	delay_ms := 0
	SendInput {Click %x% %y% 2}
	
	key_color_xy := "col_xy"
	x_no_rune := ConvertToPx(x_5_4_s, locations_index[key_color_xy][key_x], width_5_4)
	y_no_rune := ConvertToPx(y_5_4_s, locations_index[key_color_xy][key_y], height_5_4)
	no_hex_color_rune := ""
	
	key_fus_xy := "fus_xy"
	x_fus := ConvertToPx(x_5_4_s, locations_index[key_fus_xy][key_x], width_5_4)
	y_fus := ConvertToPx(y_5_4_s, locations_index[key_fus_xy][key_y], height_5_4)
	no_hex_color_fusion := ""
	PixelGetColor, no_hex_color_fusion, %x_fus%, %y_fus%
	
	i := 0
	while(no_hex_color_fusion = hex_color_fusion and i < 20)
	{
		i := i + 1
		Random, delay_ms, 50, 100
		Sleep, %delay_ms%
		PixelGetColor, no_hex_color_fusion, %x_fus%, %y_fus%
	}
	if(i = 20)
	{
		SendInput {Enter} ; procedure /ping
	}
	
	SendInput {Click %x_fus% %y_fus% 2}
	
	PixelGetColor, no_hex_color_rune, %x_no_rune%, %y_no_rune%
	
	j := 0
	while(no_hex_color_rune != hex_color_rune and j < 20)
	{
		j := j + 1
		Random, delay_ms, 50, 100
		Sleep, %delay_ms%
		PixelGetColor, no_hex_color_rune, %x_no_rune%, %y_no_rune%
	}
	if(j = 20)
	{
		SendInput {Enter} ; procedure /ping
	}
}

MainRoutine() ; funMainRoutine
{
	global min_index, max_index, reliquat
	Sleep, 1000
	finished := false
	while(finished = false)
	{
		rune := ChooseRune(min_index)
		if(rune[1] = 0)
		{
			rune := ChooseRune(max_index)
			if(rune[1] = 0)
			{
				rune := ChooseRune(max_index, false)
			}
		}
		if(!(rune[1] = 0))
		{
			UseRune(rune[1], rune[2])
			ApplyAttemptChanges(rune[1], rune[2])
		}
		else
		{
			finished := true
		}
	}
	MsgBox, Objet terminé _ reliquat _ %reliquat%
}