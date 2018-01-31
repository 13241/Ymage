#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; top

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
#Include %A_LineFile%\..\libraries\GDIP\GDIP.ahk
#Include %A_LineFile%\..\libraries\DbHandler\DbHandler.ahk

; initialization

ListLines, Off ; does not show executed lines history
Process, Priority, , AboveNormal ; raise the priority of the process
SetBatchLines, -1 ; remove the 10ms delay between each instruction (hotkey interruption is less responsive)
CoordMode, Mouse, Screen ; fix default coordinates for mouse operations to those from the screen
CoordMode, Pixel, Screen ; fix default coordinates for pixel operations to those from the screen


Hotkey, !Numpad0, Reloading, On
Hotkey, !Numpad1, Calibrate, On
Hotkey, !Numpad2, CurrentStatus, On
Hotkey, !Numpad3, MainRoutine, On
Hotkey, !Numpad4, Recalibrate, On
Hotkey, !Numpad5, Termination, On
Hotkey, !Numpad6, ConnectDatabase, On ; keytest
return

; functions

; Force TrayTip to hide (problem with windows 10)
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

; Exit app
Termination() ; funTermination
{
	HideTrayTip()
	TrayTip, , Exiting App
	ExitApp
}

; Reload app
Reloading() ; funReloading
{
	HideTrayTip()
	TrayTip, , Reloading App
	Reload
	Sleep, 1000
	MsgBox, The script could not be reloaded
	Termination()
}

; Display current status
CurrentStatus() ; funCurrentStatus
{
	global effects_index, locations_index, floors_index, final_floors_index, tolerances_index, max_index, min_index, vef_index, def_index
		, instructions_index, modif_max_index, reliquat, more_additional_index, trash_bin, destroyer_effect, reliquat_exception, item_level
		, item_name, dbhandler
	item_status := item_name . " : " . item_level . " => "
	For index, final_floors in def_index
	{
		item_status := item_status . "///" . final_floors . "___" . vef_index[index] . "___" . min_index[index] . "___" . max_index[index] . "___" . modif_max_index[index]
		For _priority, value in more_additional_index
		{
			item_status := item_status . "___" . value[index]
		}
	}
	item_status := item_status . "///reliquat___" . reliquat
	For index, trash in trash_bin
	{
		item_status := item_status . "///trash___" . trash
	}
	item_status := item_status . "///destroyer___" . destroyer_effect
	item_status := item_status . "///reliquat exception___" . reliquat_exception
	MsgBox, 4, , %item_status% Insert into database?
	IfMsgBox Yes
		dbhandler.InsertItem() ; MODIFIER		
}

; Reset all variable
CleanAllGlobalVar() ; funCleanAllGlobalVar
{
	global mage_id_w, height_5_4, width_5_4, width_5_4, x_5_4_s, y_5_4_s, hex_color_rune, hex_color_fusion, hex_color_inventory
		, effects_index, key_rune, key_blank, key_pa, key_ra, key_pwr, locations_index, key_x, key_y, floors_index, key_stdfloors
		, key_basic_std, key_pa_std, key_basic_spe, key_pa_spe, final_floors_index, tolerances_index, over_floors_index, over_tolerances_index
		, instructions_index, key_effects, key_values, min_index, max_index, vef_index, def_index, modif_max_index, more_additional_index
		, trash_exception, current_trash, trash_bin, destroyer_effect, last_history, reliquat_exception, auto_bypass, over_index
		, reliquat, rf_runes, rf_coordinates, rf_floors, rf_final_floors, rf_over_floors, rf_instructions, pic_min, pic_max, pic_effect
		, pic_effline, pic_min_2, pic_max_2, pic_effect_2, pic_minline, pic_maxline, corrections_index, item_level, item_name, pic_lvl
		, dbhandler
	mage_id_w := ""
	height_5_4 := 0
	width_5_4 := 0
	x_5_4_s := 0
	y_5_4_s := 0
	hex_color_rune := ""
	hex_color_fusion := ""
	hex_color_inventory := ""

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

	final_floors_index := []
	tolerances_index := []

	over_floors_index := []
	over_tolerances_index := []

	instructions_index := []
	key_effects := ""
	key_values := ""

	corrections_index := {}

	min_index := []
	max_index := []
	vef_index := []
	def_index := []
	modif_max_index := []
	more_additional_index := []
	trash_exception := false
	current_trash := ""
	trash_bin := []
	destroyer_effect := ""
	last_history := ""
	reliquat_exception := 1000
	auto_bypass := true
	over_index := 0
	reliquat := 0
	
	item_level := 0
	item_name := ""

	rf_runes := "data/runes.csv"
	rf_coordinates := "data/coordinates.csv"
	rf_floors := "data/palliers.csv"
	rf_final_floors := "data/finalisation.csv"
	rf_over_floors := "data/overfinalisation.csv"
	rf_instructions := "instructions.csv"
	pic_min := "min"
	pic_max := "max"
	pic_effect := "eff"
	pic_effline := "uef"
	pic_minline := "umi"
	pic_maxline := "uma"
	pic_min_2 := "min2"
	pic_max_2 := "max2"
	pic_effect_2 := "eff2"
	pic_lvl := "lvl"
	
	dbhandler := new dbhandler
	dbhandler.Connect()
}

ConnectDatabase() ; funConnectDatabase
{
	CleanAllGlobalVar()
}

; 
Calibrate() ; funCalibrate
{
	Sleep, 500
	global height_5_4, width_5_4, x_5_4_s, y_5_4_s, mage_id_w, min_index, max_index, vef_index, def_index
		, rf_runes, rf_coordinates, rf_floors, rf_final_floors, rf_instructions, pic_min, pic_max, pic_effect
		, hex_color_rune, hex_color_fusion, hex_color_inventory, locations_index, key_x, key_y, pic_min_2, pic_max_2
		, pic_effect_2, rf_over_floors, item_level, item_name, dbhandler
	CleanAllGlobalVar()
	
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
	ReadFile(rf_over_floors, "AddToOverFloors_Tolerances_Index")
	ReadFile(rf_instructions, "AddToInstructions_Index")
	
	
	CaptureItemIds()
	; dbhandler
	dbhandler.ItemIdentification(item_name, item_level)
	
	key_color_xy := "col_xy"
	x_no_rune := ConvertToPx(x_5_4_s, locations_index[key_color_xy][key_x], width_5_4)
	y_no_rune := ConvertToPx(y_5_4_s, locations_index[key_color_xy][key_y], height_5_4)
	
	SendInput {Ctrl Down}
	SendInput {Click %x_no_rune% %y_no_rune% 2}
	Sleep, 100
	SendInput {Ctrl Up}
	SendInput {Click 0 0 0}
	Sleep, 500
	
	PixelGetColor, hex_color_rune, %x_no_rune%, %y_no_rune%, Slow
	key_fus_xy := "fus_xy"
	x_fus := ConvertToPx(x_5_4_s, locations_index[key_fus_xy][key_x], width_5_4)
	y_fus := ConvertToPx(y_5_4_s, locations_index[key_fus_xy][key_y], height_5_4)
	PixelGetColor, hex_color_fusion, %x_fus%, %y_fus%, Slow
	
	key_xy_search := "sea_xy"
	x_search := ConvertToPx(x_5_4_s, locations_index[key_xy_search][key_x], width_5_4)
	y_search := ConvertToPx(y_5_4_s, locations_index[key_xy_search][key_y], height_5_4)
	key_xy_inventory := "inv_xy"
	x := ConvertToPx(x_5_4_s, locations_index[key_xy_inventory][key_x], width_5_4)
	y := ConvertToPx(y_5_4_s, locations_index[key_xy_inventory][key_y], height_5_4)
	key_xy_inf := "inf_xy"
	x_inf := ConvertToPx(x_5_4_s, locations_index[key_xy_inf][key_x], width_5_4)
	y_inf := ConvertToPx(y_5_4_s, locations_index[key_xy_inf][key_y], height_5_4)
	
	temp_hex_color_inventory := ""
	testing_color := ""
	delay_ms := 0
	SendInput {Click %x_inf% %y_inf%}
	Sleep, 500
	PixelGetColor, temp_hex_color_inventory, %x%, %y%, Slow
	SendInput {Click %x_search% %y_search% 3}
	no_result := "_$_"
	SendInput {Raw}%no_result%
	
	PixelGetColor, testing_color, %x%, %y%, Slow
	j := 0
	while(testing_color = temp_hex_color_inventory and j < 40)
	{
		j := j + 1
		Random, delay_ms, 50, 100
		Sleep, %delay_ms%
		PixelGetColor, testing_color, %x%, %y%, Slow
	}
	if(j = 40 and testing_color = temp_hex_color_inventory)
	{
		MsgBox, calibration _pixel inventory failed (1)
		return
	}
	else
	{
		hex_color_inventory := testing_color
		SendInput {Click %x_search% %y_search% 3}
		SendInput {BackSpace}
		PixelGetColor, testing_color, %x%, %y%, Slow
		j := 0
		while(testing_color = hex_color_inventory and j < 40)
		{
			j := j + 1
			Random, delay_ms, 50, 100
			Sleep, %delay_ms%
			PixelGetColor, testing_color, %x%, %y%, Slow
		}
		if(j = 40 and testing_color = hex_color_inventory)
		{
			MsgBox, calibration _pixel inventory failed (2)
			return
		}
	}
	
	CaptureImage(pic_min)
	CaptureImage(pic_max)
	CaptureImage(pic_effect)
	
	min_index := StructureOcrResult(ApplyOCR(pic_min), pic_min)[1]
	max_index := StructureOcrResult(ApplyOCR(pic_max), pic_max)[1]
	vdef_index := StructureOcrResult(ApplyOCR(pic_effect), pic_effect)
	vef_index := vdef_index[1]
	def_index := vdef_index[2]
	
	def_index := ConvertToKnownEffects(def_index)
	
	CaptureHiddenLines()
	
	CalibrateInstructions()
	
	RegisterMaxPwrItemEffects()
}

RegisterMaxPwrItemEffects() ; funRegisterMaxPwrItemEffects
{
	global max_index, min_index, def_index, dbhandler
	max_pwr_dic := {}
	For index, def in def_index
	{
		if(max_index[index] != 0 and min_index[index] != 0)
		{
			pwr := -1 * ConvertToReliquat(max_index[index], def, 0)
			max_pwr_dic[def] := pwr
		}
	}
	
	; dbhandler
	dbhandler.ItemEffectsIdentification(max_pwr_dic)
}

CurrentPwrItem() ; funCurrentPwrItem
{
	global vef_index, def_index
	pwr := 0
	For index, def in def_index
	{
		pwr := -1 * ConvertToReliquat(vef_index[index], def, 0) + pwr
	}
	return pwr
}

CaptureItemIds() ; funCaptureItemIds
{
	global locations_index, x_5_4_s, width_5_4, key_x, key_y, y_5_4_s, height_5_4, pic_lvl, item_level, item_name
	key_xy_chat := "cht_xy"
	key_xy_item := "itm_xy"
	x_chat := ConvertToPx(x_5_4_s, locations_index[key_xy_chat][key_x], width_5_4)
	y_chat := ConvertToPx(y_5_4_s, locations_index[key_xy_chat][key_y], height_5_4)
	x_item := ConvertToPx(x_5_4_s, locations_index[key_xy_item][key_x], width_5_4)
	y_item := ConvertToPx(y_5_4_s, locations_index[key_xy_item][key_y], height_5_4)
	
	SendInput {Click %x_chat% %y_chat% 3}
	SendInput {BackSpace}
	
	SendInput {Shift Down}
	SendInput {Click %x_item% %y_item%}
	SendInput {Shift Up}
	
	SendInput {Click %x_chat% %y_chat% 3}
	
	clipboard=
	SendInput ^{c}
	ClipWait, 0
	counter := 0
	while(ErrorLevel)
	{
		ClipWait, 0
		if(Mod(counter, 20) = 0)
		{
			SendInput {Click %x_chat% %y_chat% 3}
			SendInput ^{c}
		}
		counter := counter + 1
	}
	item_name := clipboard
	
	bracket_open := "["
	bracket_close := "]"
	StringReplace, item_name, item_name, %bracket_open%, , All
	StringReplace, item_name, item_name, %bracket_close%, , All
	
	SendInput {Click %x_chat% %y_chat% 3}
	SendInput {BackSpace}
	
	SendInput {Click Right %x_item% %y_item%}
	Sleep, 100
	SendInput {Down}
	Sleep, 100
	SendInput {Enter}
	Sleep, 500
	
	CaptureImage(pic_lvl)
	
	item_level := ApplyOcr(pic_lvl)
	
	SendInput {Escape}
	
	comma := ","
	niv := "Niv."
	espace := " "
	StringReplace, item_level, item_level, %comma%, , All
	StringReplace, item_level, item_level, %niv%, , All
	StringReplace, item_level, item_level, %espace%, , All
}

CaptureHiddenLines(new_item := true) ; funCaptureHiddenLines
{
	global locations_index, x_5_4_s, width_5_4, key_x, key_y, y_5_4_s, height_5_4, pic_min_2, pic_max_2, pic_effect_2
		, min_index, max_index, vef_index, def_index
	key_xy_scroll := "uef_xy_s"
	x_scroll := ConvertToPx(x_5_4_s, locations_index[key_xy_scroll][key_x], width_5_4)
	y_scroll := ConvertToPx(y_5_4_s, locations_index[key_xy_scroll][key_y], height_5_4)
	SendInput {Click %x_scroll% %y_scroll% 0}
	
	key_xy_asc_1 := "asc_xy_1"
	key_xy_asc_2 := "asc_xy_2"
	key_xy_asc_3 := "asc_xy_3"
	x_asc_1 := ConvertToPx(x_5_4_s, locations_index[key_xy_asc_1][key_x], width_5_4)
	y_asc_1 := ConvertToPx(y_5_4_s, locations_index[key_xy_asc_1][key_y], height_5_4)
	x_asc_2 := ConvertToPx(x_5_4_s, locations_index[key_xy_asc_2][key_x], width_5_4)
	y_asc_2 := ConvertToPx(y_5_4_s, locations_index[key_xy_asc_2][key_y], height_5_4)
	x_asc_3 := ConvertToPx(x_5_4_s, locations_index[key_xy_asc_3][key_x], width_5_4)
	y_asc_3 := ConvertToPx(y_5_4_s, locations_index[key_xy_asc_3][key_y], height_5_4)
	
	hex_color_asc_1 := ""
	hex_color_asc_2 := ""
	hex_color_asc_3 := ""
	PixelGetColor, hex_color_asc_1, %x_asc_1%, %y_asc_1%, Slow
	PixelGetColor, hex_color_asc_2, %x_asc_2%, %y_asc_2%, Slow
	PixelGetColor, hex_color_asc_3, %x_asc_3%, %y_asc_3%, Slow
	if(hex_color_asc_1 = hex_color_asc_2 and hex_color_asc_2 != hex_color_asc_3)
	{
		SendInput {Click %x_asc_2% %y_asc_2% 0}
		SendInput {WheelDown}
		PixelGetColor, hex_color_asc_3, %x_asc_3%, %y_asc_3%, Slow
		while(hex_color_asc_3 != hex_color_asc_2)
		{
			SendInput {WheelDown}
			PixelGetColor, hex_color_asc_3, %x_asc_3%, %y_asc_3%, Slow
		}
		
		if(new_item)
		{
			CaptureImage(pic_min_2)
			CaptureImage(pic_max_2)
		}
		CaptureImage(pic_effect_2)
		SendInput {WheelUp}
		PixelGetColor, hex_color_asc_1, %x_asc_1%, %y_asc_1%, Slow
		while(hex_color_asc_1 != hex_color_asc_2)
		{
			SendInput {WheelUp}
			PixelGetColor, hex_color_asc_1, %x_asc_1%, %y_asc_1%, Slow
		}
		
		temp_min_index := []
		temp_max_index := []
		if(new_item)
		{
			temp_min_index := StructureOcrResult(ApplyOCR(pic_min_2), pic_min_2)[1]
			temp_max_index := StructureOcrResult(ApplyOCR(pic_max_2), pic_max_2)[1]
		}
		temp_vdef_index := StructureOcrResult(ApplyOCR(pic_effect_2), pic_effect_2)
		temp_vef_index := temp_vdef_index[1]
		temp_def_index := temp_vdef_index[2]
		
		temp_def_index := ConvertToKnownEffects(temp_def_index)
		
		For index, def in temp_def_index
		{
			if(HasValue(def_index, def))
			{
				continue
			}
			else
			{
				vef_index.Push(temp_vef_index[index])
				def_index.Push(temp_def_index[index])
				if(new_item and temp_max_index.HasKey(index))
				{
					min_index.Push(temp_min_index[index])
					max_index.Push(temp_max_index[index])
				}
			}
		}
	}
	else
	{
		return
	}
}

Recalibrate(new_item := false) ; funRecalibrate ; a supprimer
{
	global reliquat, pic_min, pic_max, pic_effect, min_index, max_index, vef_index, def_index
		, trash_exception, current_trash, trash_bin, rf_floors, rf_final_floors, rf_instructions, auto_bypass, modif_max_index
		, more_additional_index, last_history, reliquat_exception, floors_index, key_stdfloors, key_basic_std
		, key_pa_std, key_basic_spe, key_pa_spe, final_floors_index, tolerances_index, instructions_index
		, key_effects, key_values, pic_min_2, pic_max_2, pic_effect_2, rf_over_floors, over_floors_index, over_tolerances_index
		, destroyer_effect, over_index
	Sleep, 500
	vef_index := []
	def_index := []
	modif_max_index := []
	more_additional_index := []
	reliquat := 0
	trash_exception := false
	current_trash := ""
	trash_bin := []
	last_history := ""
	reliquat_exception := 1000
	auto_bypass := true
	destroyer_effect := ""
	over_index := 0
	
	floors_index := {}
	key_stdfloors := ""
	key_basic_std := ""
	key_pa_std := ""
	key_basic_spe := ""
	key_pa_spe := ""

	final_floors_index := []
	tolerances_index := []
	
	over_floors_index := []
	over_tolerances_index := []

	instructions_index := []
	key_effects := ""
	key_values := ""
	
	ReadFile(rf_floors, "AddToFloors_Index")
	ReadFile(rf_final_floors, "AddToFinalFloors_Tolerances_Index")
	ReadFile(rf_over_floors, "AddToOverFloors_Tolerances_Index")
	ReadFile(rf_instructions, "AddToInstructions_Index")
	
	CaptureImage(pic_effect)
	
	if(new_item)
	{
		min_index := []
		max_index := []
		CaptureImage(pic_min)
		CaptureImage(pic_max)
		min_index := StructureOcrResult(ApplyOCR(pic_min), pic_min)[1]
		max_index := StructureOcrResult(ApplyOCR(pic_max), pic_max)[1]
	}
	
	
	vdef_index := StructureOcrResult(ApplyOCR(pic_effect), pic_effect)
	vef_index := vdef_index[1]
	def_index := vdef_index[2]
	
	def_index := ConvertToKnownEffects(def_index)
	
	CaptureHiddenLines(new_item)
	
	CalibrateInstructions()
	
	Sleep, 500
}

CalibrateInstructions() ; funCalibrateInstructions
{
	global def_index, instructions_index, max_index, min_index, vef_index, modif_max_index, more_additional_index
		, key_effects, key_values, corrections_index, over_index, destroyer_effect
	For index_correction, correction in corrections_index
	{
		eff_index := HasValue(def_index, index_correction)
		if(correction.HasKey("min"))
		{
			min_index[eff_index] := correction["min"]
		}
		if(correction.HasKey("max"))
		{
			max_index[eff_index] := correction["max"]
		}
	}
	For c_index, c_effect in def_index
	{
		if(!max_index.HasKey(c_index))
		{
			max_index[c_index] := 0
			min_index[c_index] := 0
		}
		modif_max_index[c_index] := max_index[c_index]
		if(max_index[c_index] < vef_index[c_index] and def_index[c_index] != destroyer_effect) ; yolo teste si un over est present au calibrage
		{
			over_index := c_index
		}
	}
	For _priority, instructions in instructions_index
	{
		more_additional_index[_priority] := []
		For c_index, c_effect in def_index
		{
			more_additional_index[_priority][c_index] := max_index[c_index]
		}
	}
	For _priority, instructions in instructions_index
	{
		For m_index, m_effect in instructions[key_effects]
		{
			d_index := HasValue(def_index, m_effect)
			if(d_index != 0)
			{
				if(over_index = d_index and instructions[key_values][m_index] != 0)
				{
					over_index := 0
				}
				if(modif_max_index[d_index] > instructions[key_values][m_index]) ; yolo condition changed (before test if not null)
				{
					modif_max_index[d_index] := instructions[key_values][m_index]
					For sub_priority, all_priorities in more_additional_index
					{
						all_priorities[d_index] := instructions[key_values][m_index]
					}
				}
				else
				{
					more_additional_index[_priority][d_index] := instructions[key_values][m_index]
				}
			}
			else
			{
				For sub_priority, all_priorities in more_additional_index
				{
					if(sub_priority != _priority)
					{
						all_priorities.Push(0)
					}
					else
					{
						more_additional_index[_priority].Push(instructions[key_values][m_index])
					}
				}
				def_index.Push(m_effect)
				min_index.Push(0)
				max_index.Push(0)
				vef_index.Push(0)
				modif_max_index.Push(0)
			}
		}
	}
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
		MsgBox, Cant open the file : %file_name%
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
	keys := StrSplit(line, ";")
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

AddToInstructions_Index(line) ; funAddToInstructions_Index
{
	global instructions_index, key_effects, key_values, reliquat_exception, trash_bin, destroyer_effect, corrections_index
	StringReplace, line, line, `r, , All
	StringReplace, line, line, `n, , All
	keys := StrSplit(line, ";")
	if(key_effects = "")
	{
		key_effects := keys[1]
		key_values := keys[2]
	}
	else if(keys[3] = "min")
	{
		if(!IsObject(corrections_index[keys[1]]))
		{
			corrections_index[keys[1]] := {}
		}
		corrections_index[keys[1]]["min"] := keys[2]
	}
	else if(keys[3] = "max")
	{
		if(!IsObject(corrections_index[keys[1]]))
		{
			corrections_index[keys[1]] := {}
		}
		corrections_index[keys[1]]["max"] := keys[2]
	}
	else if(keys[3] < 1)
	{
		if(!(instructions_index.HasKey("1")))
		{
			instructions_index["1"] := {}
		}
		if(!IsObject(instructions_index["1"][key_effects]) or !IsObject(instructions_index["1"][key_values]))
		{
			instructions_index["1"][key_effects] := []
			instructions_index["1"][key_values] := []
		}
		if(keys[3] = -1)
		{
			destroyer_effect := keys[1]
		}
		else if(keys[3] = 0)
		{
			trash_bin.Push(keys[1])
		}
		instructions_index["1"][key_effects].Push(keys[1])
		instructions_index["1"][key_values].Push(keys[2])
	}
	else
	{
		if(!(instructions_index.HasKey(keys[3])))
		{
			instructions_index[keys[3]] := {}
		}
		if(!IsObject(instructions_index[keys[3]][key_effects]) or !IsObject(instructions_index[keys[3]][key_values]))
		{
			instructions_index[keys[3]][key_effects] := []
			instructions_index[keys[3]][key_values] := []
		}
		instructions_index[keys[3]][key_effects].Push(keys[1])
		instructions_index[keys[3]][key_values].Push(keys[2])
	}
	if(keys[4] != "" and keys[4] != "exception")
	{
		reliquat_exception := keys[4]
	}
}

AddToLocations_Index(line) ; funAddToLocations_Index
{
	global locations_index, key_x, key_y
	StringReplace, line, line, `r, , All
	StringReplace, line, line, `n, , All
	keys := StrSplit(line, ";")
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
	global floors_index, key_stdfloors, key_basic_std, key_basic_spe, key_pa_std, key_pa_spe
	StringReplace, line, line, `r, , All
	StringReplace, line, line, `n, , All
	keys := StrSplit(line, ";")
	if(key_stdfloors = "")
	{
		key_stdfloors := keys[2]
		key_basic_std := keys[3]
		key_pa_std := keys[4]
		key_basic_spe := keys[5]
		key_pa_spe := keys[6]
	}
	else
	{
		floors_index[keys[1]] := {}
		floors_index[keys[1]][key_stdfloors] := keys[2]
		floors_index[keys[1]][key_basic_std] := keys[3]
		floors_index[keys[1]][key_pa_std] := keys[4]
		floors_index[keys[1]][key_basic_spe] := keys[5]
		floors_index[keys[1]][key_pa_spe] := keys[6]
	}
}

AddToFinalFloors_Tolerances_Index(line) ; funAddToFinalFloors_Tolerances_Index
{
	global final_floors_index, tolerances_index
	StringReplace, line, line, `r, , All
	StringReplace, line, line, `n, , All
	keys := StrSplit(line, ";")
	floor_value := keys[1]
	if floor_value is integer
	{
		final_floors_index.Push(keys[1])
		tolerances_index.Push(keys[2])
	}
}

AddToOverFloors_Tolerances_Index(line) ; funAddToOverFloors_Tolerances_Index
{
	global over_floors_index, over_tolerances_index
	StringReplace, line, line, `r, , All
	StringReplace, line, line, `n, , All
	keys := StrSplit(line, ";")
	floor_value := keys[1]
	if floor_value is integer
	{
		over_floors_index.Push(keys[1])
		over_tolerances_index.Push(keys[2])
	}
}

CaptureImage(pic_name, line := 0, decal_y := 0, decal_x := 0) ; funCaptureImage
{
	global height_5_4, width_5_4, x_5_4_s, y_5_4_s, locations_index, key_x, key_y
	pToken := Gdip_Startup()
	folderPath := A_ScriptDir "\screenshots\"
	fileName := pic_name . ".png" ; A_YYYY "-" A_MM "-" A_DD "-" A_Hour "-" A_Min "-" A_Sec ".png"
	
	x_s := 0
	y_s := 0
	width := 0
	height := 0
	if(line > 0)
	{
		key_xy_s := pic_name . "_xy_s"
		key_y_d := pic_name . "_y_d"
		key_y_de := pic_name . "_y_de"
		key_x_e := pic_name . "_x_e"
		x_s := ConvertToPx(x_5_4_s, locations_index[key_xy_s][key_x], width_5_4)
		y_s := ConvertToPx(y_5_4_s + decal_y, locations_index[key_xy_s][key_y], height_5_4, locations_index[key_y_d][key_y], line - 1)
		width := ConvertToPx(x_5_4_s, locations_index[key_x_e][key_x], width_5_4) - x_s - decal_x
		height := ConvertToPx(y_5_4_s + decal_y, locations_index[key_xy_s][key_y] + locations_index[key_y_de][key_y], height_5_4, locations_index[key_y_d][key_y], line - 1) - y_s
	}
	else
	{
		key_xy_s := pic_name . "_xy_s"
		key_xy_e := pic_name . "_xy_e"
		x_s := ConvertToPx(x_5_4_s, locations_index[key_xy_s][key_x], width_5_4)
		y_s := ConvertToPx(y_5_4_s, locations_index[key_xy_s][key_y], height_5_4)
		width := ConvertToPx(x_5_4_s, locations_index[key_xy_e][key_x], width_5_4) - x_s
		height := ConvertToPx(y_5_4_s, locations_index[key_xy_e][key_y], height_5_4) - y_s
	}
	
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
		SendInput {Raw}%A_ScriptDir%\screenshots
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
	IfWinNotExist, FreeOCR
	{
		MsgBox, FreeOCR app must be running
		return ""
	}
}

StructureOcrResult(expression, pic_name) ; funStructureOcrResult
{
	global pic_effline, pic_minline, pic_maxline, pic_min, pic_max, pic_effect, locations_index, key_y, height_5_4, width_5_4, key_x
		, pic_min_2, pic_max_2, pic_effect_2
	pic_nameline := ""
	if(pic_name = pic_min or pic_name = pic_min_2)
	{
		pic_nameline := pic_minline
	}
	else if(pic_name = pic_max or pic_name = pic_max_2)
	{
		pic_nameline := pic_maxline
	}
	else if(pic_name = pic_effect or pic_name = pic_effect_2)
	{
		pic_nameline := pic_effline
	}
	else
	{
		Return MsgBox, Erreur nom d image inconnu
	}
	key_y_de := pic_nameline . "_y_de"
	delta_max := ConvertToPx(0, locations_index[key_y_de][key_y], height_5_4) // 4
	key_x_de := pic_nameline . "_x_de"
	cut_width := 15
	delta_width := ConvertToPx(0, locations_index[key_x_de][key_x], width_5_4) // cut_width
	container := []
	temp_def_index := []
	parts := StrSplit(expression, ",")
	i := 0
	For index, value in parts
	{
		if(index = 1 or value = "")
		{
			continue
		}
		else if(pic_nameline = pic_minline or pic_nameline = pic_maxline)
		{
			i := i + 1
			container.Push(value)
			if value is not integer
			{
				MsgBox, OCR FAILED %pic_nameline% line %i%
			}
		}
		else
		{
			position := InStr(value, "%", false, 1, 1)
			if(position)
			{
				nbr := SubStr(value, 1, position - 1)
				if nbr is integer
				{
					i := i + 1
					container.Push(nbr)
					temp_def_index.Push(SubStr(value, position))
					continue
				}
				else if(StrLen(nbr) <= 4 and StrLen(nbr) > 0) ; yolo empeche usage de rune de chasse (osef)
				{
					j := i
					delta := 0
					positive := true
					while(delta <= delta_max and delta >= -1 * delta_max)
					{
						i_width := 0
						while(i_width < (cut_width // 3) * 2)
						{
							CaptureImage(pic_nameline, i + 1, delta, i_width * delta_width)
							ocr_result := ApplyOCR(pic_nameline)
							ocr_parts := StrSplit(ocr_result, ",")
							For ocr_index, ocr_part in ocr_parts
							{
								if(ocr_part = "")
								{
									continue
								}
								else
								{
									ocr_position := InStr(ocr_part, "%", false, 1, 1)
									if(ocr_position)
									{
										ocr_nbr := SubStr(ocr_part, 1, ocr_position - 1)
										if ocr_nbr is integer
										{
											i := i + 1
											container.Push(ocr_nbr)
											temp_def_index.Push(SubStr(ocr_part, ocr_position))
											break 3
										}
									}
									ocr_position := InStr(ocr_part, " ", false, 1, 1)
									if(ocr_position)
									{
										ocr_nbr := SubStr(ocr_part, 1, ocr_position - 1)
										if ocr_nbr is integer
										{
											i := i + 1
											container.Push(ocr_nbr)
											temp_def_index.Push(SubStr(ocr_part, ocr_position + 1))
											break 3
										}
									}
								}
							}
							i_width := i_width + 1
						}
						if(positive)
						{
							delta := delta + 1
							if(delta > delta_max)
							{
								positive := false
								delta := -1
							}
						}
						else
						{
							delta := delta - 1
						}
					}
					if(j = i)
					{
						Recalibrate()
						return
					}
					else
					{
						continue
					}
				}
			}
			position := InStr(value, " ", false, 1, 1)
			if(position)
			{
				nbr := SubStr(value, 1, position - 1)
				if nbr is integer
				{
					i := i + 1
					container.Push(nbr)
					temp_def_index.Push(SubStr(value, position + 1))
					continue
				}
				else if(StrLen(nbr) <= 4 and StrLen(nbr) > 0 and SubStr(nbr, 1, 1) != "%") ; yolo empeche usage de rune de chasse (osef)
				{
					j := i
					delta := 0
					positive := true
					while(delta <= delta_max and delta >= -1 * delta_max)
					{
						i_width := 0
						while(i_width < (cut_width // 3) * 2)
						{
							CaptureImage(pic_nameline, i + 1, delta, i_width * delta_width)
							ocr_result := ApplyOCR(pic_nameline)
							ocr_parts := StrSplit(ocr_result, ",")
							For ocr_index, ocr_part in ocr_parts
							{
								if(ocr_part = "")
								{
									continue
								}
								else
								{
									ocr_position := InStr(ocr_part, "%", false, 1, 1)
									if(ocr_position)
									{
										ocr_nbr := SubStr(ocr_part, 1, ocr_position - 1)
										if ocr_nbr is integer
										{
											i := i + 1
											container.Push(ocr_nbr)
											temp_def_index.Push(SubStr(ocr_part, ocr_position))
											break 3
										}
									}
									ocr_position := InStr(ocr_part, " ", false, 1, 1)
									if(ocr_position)
									{
										ocr_nbr := SubStr(ocr_part, 1, ocr_position - 1)
										if ocr_nbr is integer
										{
											i := i + 1
											container.Push(ocr_nbr)
											temp_def_index.Push(SubStr(ocr_part, ocr_position + 1))
											break 3
										}
									}
								}
							}
							i_width := i_width + 1
						}
						if(positive)
						{
							delta := delta + 1
							if(delta > delta_max)
							{
								positive := false
								delta := -1
							}
						}
						else
						{
							delta := delta - 1
						}
					}
					if(j = i)
					{
						Recalibrate()
						return
					}
					else
					{
						continue
					}
				}
			}
			i := i + 1
			container.Push(0)
			temp_def_index.Push(value)
		}
	}
	return [container, temp_def_index]
}

LevenshteinDistance(word, ref) ; funLevenshteinDistance
{
	distance := 0
	len_word := StrLen(word)
	len_ref := StrLen(ref)
	if(len_word = 0)
	{
		return len_ref
	}
	else if(len_ref = 0)
	{
		return len_word
	}
	matrix := []
	i := 1
	while(i <= len_word + 1)
	{
		matrix[i] := []
		j := 1
		while(j <= len_ref + 1)
		{
			if(i = 1)
			{
				matrix[i][j] := j - 1
			}
			else if(j = 1)
			{
				matrix[i][j] := i - 1
			}
			else
			{
				cost := 0
				if(SubStr(word, i, 1) != SubStr(ref, j, 1))
				{
					cost := 1
				}
				c_up := matrix[i - 1][j] + 1
				c_left := matrix[i][j - 1] + 1
				c_up_left := matrix[i - 1][j - 1] + cost
				if(c_up < c_left)
				{
					matrix[i][j] := c_up
				}
				else
				{
					matrix[i][j] := c_left
				}
				if(c_up_left < matrix[i][j])
				{
					matrix[i][j] := c_up_left
				}
			}
			j := j + 1
		}
		i := i + 1
	}
	return matrix[len_word + 1][len_ref + 1]
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
	global height_5_4, width_5_4, x_5_4_s, y_5_4_s, locations_index, key_x, key_y, last_history
	key_xy_s := "his_xy_s"
	key_x_e := "his_x_e"
	key_y_e := "his_y_e"
	x_s := ConvertToPx(x_5_4_s, locations_index[key_xy_s][key_x], width_5_4)
	y_s := ConvertToPx(y_5_4_s, locations_index[key_xy_s][key_y], height_5_4)
	x_e := ConvertToPx(x_5_4_s, locations_index[key_x_e][key_x], width_5_4)
	y_e := ConvertToPx(y_5_4_s, locations_index[key_y_e][key_y], height_5_4)
	
	SendInput {Click Down %x_s% %y_s%}
	SendInput {Click Up %x_e% %y_e%}
	SendInput {Click Down %x_s% %y_s%} ; yolo fonctionne (beaucoup) mieux avec cette instruction en double
	SendInput {Click Up %x_e% %y_e%}
	clipboard=
	SendInput ^{c}
	ClipWait, 0
	counter := 0
	while(ErrorLevel)
	{
		ClipWait, 0
		if(Mod(counter, 20) = 0)
		{
			SendInput {Enter}
			SendInput {Click Down %x_s% %y_s%}
			SendInput {Click Up %x_e% %y_e%}
			SendInput {Click Down %x_s% %y_s%}
			SendInput {Click Up %x_e% %y_e%}
			SendInput ^{c}
		}
		counter := counter + 1
	}
	history_result := clipboard
	
	dot_comma := ";"
	StringReplace, history_result, history_result, `r, %dot_comma% , All
	StringReplace, history_result, history_result, `n, %dot_comma% , All
	StringReplace, history_result, history_result, %dot_comma%%dot_comma%, %dot_comma%, All
	
	last_line := []
	
	if(InStr(last_history, history_result))
	{
		return CaptureLastAttemptHistory() ; [] before
	}
	else
	{
		last_history := history_result
	}
	
	cut_history_result := StrSplit(history_result, dot_comma)
	For index, value in cut_history_result
	{
		last_line.InsertAt(1, value)
	}
	return last_line
}

AttemptResult(line) ; funAttemptStatus
{
	; tester si line contient "Échec" => sn (echange equivalent complet (la rune s'ajoute en retirant sa propre stats)
	; tester si line contient "+reliquat" => compter les virgules
	; 	n_virgule = "-" => ec
	;	n_virgule - 1 = "-" => sn
	; tester si line contient "-reliquat" => compter les virgules
	; 	n_virgule + 1 = "-" => ec
	; 	n_virgule = "-" => sn
	; tester si n_virgule = 0 => sc
	; sinon => sn (echange equivalent partiel)
	line_status := ""
	comma := ","
	minus := "-"
	StringReplace, line, line, %comma%, %comma%, UseErrorLevel
	n_commas := ErrorLevel
	if(InStr(line, "Échec"))
	{
		line_status := "ns"
	}
	else if(InStr(line, "+reliquat"))
	{
		StringReplace, line, line, %minus%, %minus%, UseErrorLevel
		n_minus := ErrorLevel
		if(n_minus = n_commas)
		{
			line_status := "ce"
		}
		else if(n_commas - 1 = n_minus)
		{
			line_status := "ns"
		}
		else
		{
			MsgBox, Error : %line% : %n_minus% %minus% and %n_commas% %comma%
		}
	}
	else if(InStr(line, "-reliquat"))
	{
		StringReplace, line, line, %minus%, %minus%, UseErrorLevel
		n_minus := ErrorLevel
		if(n_commas + 1 = n_minus)
		{
			line_status := "ce"
		}
		else if(n_commas = n_minus)
		{
			line_status := "ns"
		}
		else
		{
			MsgBox, Error : %line% : %n_minus% %minus% and %n_commas% %comma%
		}
	}
	else if(n_commas = 0)
	{
		line_status := "cs"
	}
	else
	{
		line_status := "ns"
	}
	return line_status
}

ApplyAttemptChanges(attempt_value, attempt_effect) ; funApplyAttemptChanges
{
	global reliquat, vef_index, def_index, min_index, max_index, modif_max_index, more_additional_index
		, instructions_index, key_effects, effects_index, locations_index, key_x, key_y, x_5_4_s, y_5_4_s
		, width_5_4, height_5_4, hex_color_rune, dbhandler
	lines_changes := CaptureLastAttemptHistory()
	while(lines_changes.Length() = 0)
	{
		lines_changes := CaptureLastAttemptHistory() ; yolo (on assume que si on est arrivé ici, la fusion de rune a eu lieu)
	}
	
	line_changes := lines_changes[1]
	; tracingChanges si on arrive ici, on peut capturer les infos courantes de l'objet
	; à ce stade, la fonction peut "echouer", il ne faut ici capturer que le statut (sc, ec, sn)
	; result est donc determinable ici
	attempt_result := AttemptResult(line_changes)
	
	changes := StrSplit(line_changes, ", ")
	found_reliquat := false
	tampon_reliquat := 0
	tampon_changes := {}
	pushed_effects := []
	
	; attemptedPwrEffect (=runepwr based on current value)
	index_attempt := HasValue(def_index, attempt_effect)
	attempt_attemptedPwrEffect := 0
	if(index_attempt != 0)
	{
		attempt_attemptedPwrEffect := -1 * ConvertToReliquat(attempt_value, attempt_effect, vef_index[index_attempt])
	}
	else
	{
		attempt_attemptedPwrEffect := -1 * ConvertToReliquat(attempt_value, attempt_effect, 0)
	}
	
	For index, change in changes
	{
		if(change = "Échec")
		{
			break
		}
		else if(InStr(change, "reliquat"))
		{
			tampon_reliquat := tampon_reliquat - attempt_attemptedPwrEffect
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
				ApplyAttemptChanges(attempt_value, attempt_effect) ; yolo on refait la capture du clipboard, on assume que la fusion a été faite
				return
			}
			else if(effect = "")
			{
				ApplyAttemptChanges(attempt_value, attempt_effect) ; yolo on refait la capture du clipboard, on assume que la fusion a été faite
				return
			}
			else
			{
				i_ef_index := HasValue(def_index, effect)
				if(InStr(change, "-"))
				{
					if(i_ef_index != 0)
					{
						tampon_reliquat := tampon_reliquat + ConvertToReliquat(value, effect, vef_index[i_ef_index])
					}
					else
					{
						tampon_reliquat := tampon_reliquat + ConvertToReliquat(value, effect, 0)
					}
				}
				if(i_ef_index)
				{
					if(!IsObject(tampon_changes[i_ef_index]))
					{
						tampon_changes[i_ef_index] := {}
					}
					tampon_changes[i_ef_index]["value"] := value
					tampon_changes[i_ef_index]["effect"] := effect
					tampon_changes[i_ef_index]["operation"] := "modify"
					if(max_index[i_ef_index] = 0 and vef_index[i_ef_index] = 0 and min_index[i_ef_index] = 0 and modif_max_index[i_ef_index] = 0)
					{
						instructed_effect := false
						For _priority, instruction in instructions_index
						{
							if(HasValue(instruction[key_effects], effect) != 0)
							{
								instructed_effect := true
								break
							}
						}
						if(instructed_effect = false)
						{
							tampon_changes[i_ef_index]["operation"] := "remove"
						}
					}
				}
				else if(effects_index.HasKey(effect))
				{
					pushed_effects.Push({"value":value, "effect":effect})
				}
				else
				{
					ApplyAttemptChanges(attempt_value, attempt_effect) ; yolo on refait la capture du clipboard, on assume que la fusion a été faite
					return
				}
			}
		}
	}
	; tracingChanges si on arrive ici, on peut envoyer les infos en database, on calcule la majorité des infos quand la fonction ne peut plus "echouer"
	; currentPwrItem
	; effect (à reconvertir) => attempt_effect
	; currentReliquat => reliquat
	attempt_currentPwrItem := CurrentPwrItem()
	
	; dbhandler
	attempt_id := dbhandler.AddAttempt(attempt_effect, reliquat, attempt_attemptedPwrEffect, attempt_currentPwrItem, attempt_result)
	
	found_attempt_effect := false
	attempt_effect_pwrBefore := -1 * ConvertToReliquat(vef_index[index_attempt], attempt_effect, 0)
	
	For i_tampon_change, tampon_change in tampon_changes
	{
		if(tampon_change["effect"] = attempt_effect)
		{
			found_attempt_effect := true
		}
		; tracingChanges on peut capturer pwrBefore
		effect_pwrBefore := -1 * ConvertToReliquat(vef_index[i_tampon_change], tampon_change["effect"], 0)
		effect_pwrAfter := 0
		
		if(tampon_change["operation"] = "remove")
		{
			max_index.RemoveAt(i_tampon_change)
			min_index.RemoveAt(i_tampon_change)
			vef_index.RemoveAt(i_tampon_change)
			def_index.RemoveAt(i_tampon_change)
			modif_max_index.RemoveAt(i_tampon_change)
			For _priority, objective in more_additional_index
			{
				objective.RemoveAt(i_tampon_change)
			}
			; tracingChanges pwrAfter vaut 0
		}
		else
		{
			vef_index[i_tampon_change] := vef_index[i_tampon_change] + tampon_change["value"]
			; tracingChanges on peut capturer pwrAfter
			effect_pwrAfter := -1 * ConvertToReliquat(vef_index[i_tampon_change], tampon_change["effect"], 0)
		}
		
		; dbhandler
		dbhandler.AddChangeOnAttempt(attempt_id, tampon_change["effect"], effect_pwrBefore, effect_pwrAfter)
	}
	For push_index, push in pushed_effects
	{
		if(push["effect"] = attempt_effect)
		{
			found_attempt_effect := true
		}
		; tracingChanges pwrBefore vaut 0
		effect_pwrBefore := 0
		
		vef_index.Push(push["value"])
		def_index.Push(push["effect"])
		min_index.Push(0)
		max_index.Push(0)
		modif_max_index.Push(0)
		For _priority, objective in more_additional_index
		{
			objective[_priority].Push(0)
		}
		; tracingChanges on peut capturer pwrAfter
		effect_pwrAfter := -1 * ConvertToReliquat(push["value"], push["effect"], 0)
		
		; dbhandler
		dbhandler.AddChangeOnAttempt(attempt_id, push["effect"], effect_pwrBefore, effect_pwrAfter)
	}
	if(found_reliquat)
	{
		reliquat := reliquat + tampon_reliquat
		if(reliquat < 0)
		{
			reliquat := 0
		}
	}
	
	if(!found_attempt_effect)
	{
		; dbhandler
		dbhandler.AddChangeOnAttempt(attempt_id, attempt_effect, attempt_effect_pwrBefore, attempt_effect_pwrBefore)
	}
	
	; dbhandler
	if(dbhandler.AttemptsCount != 0 and Mod(dbhandler.AttemptsCount, 10) = 0)
	{
		dbhandler.InsertAttempts()
	}
}

ConvertToReliquat(value, effect, reference) ; funConvertToReliquat
{
	global effects_index, key_pwr
	eff_reliquat := 0
	if(effects_index.HasKey(effect))
	{
		if(reference < -1)
		{
			if(reference + value <= -1)
			{
				eff_reliquat := -1 * effects_index[effect][key_pwr] * value / 2
			}
			else
			{
				pos_value := value + reference + 1
				neg_value := -1 * (reference + 1)
				eff_reliquat := -1 * effects_index[effect][key_pwr] * (neg_value / 2 + pos_value)
			}
		}
		else
		{
			if(reference + value < -1)
			{
				pos_value := -1 * (reference + 1)
				neg_value := value + reference + 1
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

GetNeededReliquat(objective) ; funGetNeededReliquat
{
	global vef_index, def_index, effects_index, key_pwr
	current_reliquat := 0
	final_reliquat := 0
	For index, value in objective
	{
		if(def_index[index] != "Prospection" and effects_index[def_index[index]][key_pwr] < reliquat) ; yolo doit tenir compte des trash autre que prospection
		{
			current_reliquat := current_reliquat + ConvertToReliquat(vef_index[index], def_index[index], 0)
			final_reliquat := final_reliquat + ConvertToReliquat(value, def_index[index], 0)
		}
	}
	return final_reliquat - current_reliquat
}

GetCurrentOverPwr(ignore_index := 0) ; funGetCurrentOverPwr
{
	global vef_index, def_index, max_index, effects_index, key_pwr
	current_over_pwr := 0
	For index, value in vef_index
	{
		if(vef_index[index] > max_index[index] and index != ignore_index)
		{
			current_over_pwr := current_over_pwr + ConvertToReliquat(vef_index[index], def_index[index], 0) - ConvertToReliquat(max_index[index], def_index[index], 0)
		}
	}
	return current_over_pwr
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

ChooseRune(objective, adapted := true, bypass := true, force_objective := false) ; funChooseRune
{
	global max_index, min_index, effects_index, modif_max_index, key_blank, key_pa, key_ra, key_pwr, def_index, vef_index
		, floors_index, key_stdfloors, key_basic_std, key_basic_spe, key_pa_std, key_pa_spe, final_floors_index
		, tolerances_index, trash_exception, current_trash, trash_bin, reliquat, reliquat_exception, auto_bypass
		, over_floors_index, over_tolerances_index, destroyer_effect, over_index
	if(over_index != 0 and destroyer_effect != "")
	{
		if(vef_index[over_index] > max_index[over_index])
		{
			destroyer_value := effects_index[destroyer_effect][key_blank]
			return [destroyer_value, destroyer_effect]
		}
		else
		{
			over_index := 0
		}
	}
	if(bypass = true)
	{
		auto_bypass := true
	}
	else if(reliquat >= reliquat_exception)
	{
		auto_bypass := false
	}
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
	exo_effect := ""
	over_index := 0
	if(auto_bypass = false or force_objective = true) ; yolo adapted condition
	{
		max_pwr := 0
		For index_exo, exo in def_index
		{
			if(adapted_objective[index_exo] - max_index[index_exo] = 1 and effects_index[exo][key_pwr] >= reliquat_exception) ; yolo objective changed
			{
				if(effects_index[exo][key_pwr] > max_pwr)
				{
					max_pwr := effects_index[exo][key_pwr]
					exo_effect := exo
				}
			}
		}
	}
	For index, def in def_index
	{
		if(def = current_trash or (current_trash = "" and HasValue(trash_bin, def) != 0))
		{
			if(reliquat > 9 or auto_bypass = false)
			{
				trash_exception := false
				current_trash := ""
			}
			else if((vef_index[index] = 0 and reliquat < 1) or trash_exception)
			{
				high_objective := false
				For i_spe, val_spe in max_index
				{
					if(val_spe = 0 and adapted_objective[i_spe] != 0)
					{
						high_objective := true
					}
				}
				if(vef_index[index] >= min_index[index] or high_objective = true)
				{
					trash_exception := false
					current_trash := ""
				}
				else
				{
					if(!trash_exception)
					{
						trash_exception := true
						current_trash := def
					}
					effect := def
					max_value := min_index[index]
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
			compare_value := max_index[index]
			if(max_index[index] < adapted_objective[index])
			{
				compare_value := adapted_objective[index]
			}
			if(compare_value > floors_index[effects_index[def][key_pwr]][key_stdfloors])
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
			over_tolerance := 0
			For i_over, over_floor in over_floors_index
			{
				if(adapted_objective[index] >= over_floor)
				{
					over_tolerance := over_tolerances_index[i_over]
					break
				}
			}
			if(def != exo_effect and (auto_bypass = true or ConvertToReliquat(minimal_delta, def, vef_index[index]) + reliquat >= 0)) ; yolo adapted condition
			{
				if(minimal_delta <= adapted_objective[index] - vef_index[index] or (adapted_objective[index] - vef_index[index] > over_tolerance and minimal_delta != adapted_objective[index] and !(ConvertToReliquat(max_index[index], def, 0) < -101 and ConvertToReliquat(vef_index[index] + minimal_delta, def, 0) < ConvertToReliquat(max_index[index], def, 0)))) ; yolo maximal over power rate condition (last)
				{
					if((effects_index[def][key_pwr] = pwr_effect and adapted_objective[index] - vef_index[index] > delta_value) or effects_index[def][key_pwr] > pwr_effect)
					{
						if(adapted_objective[index] - vef_index[index] > over_tolerance and minimal_delta != adapted_objective[index] and !(minimal_delta <= adapted_objective[index] - vef_index[index]))
						{
							over_index := index
							max_value := vef_index[index] + minimal_delta
							max_delta_value := minimal_delta
							delta_value := minimal_delta
						}
						else
						{
							over_index := 0
							max_value := max_index[index]
							max_delta_value := max_index[index] - vef_index[index]
							delta_value := adapted_objective[index] - vef_index[index]
						}
						effect := def
						pwr_effect := effects_index[def][key_pwr]
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
		if(effect != "" and auto_bypass = false and reliquat + ConvertToReliquat(value, effect, current_value) < 0)
		{
			return ChooseRune(objective, adapted, true)
		}
		else if(effect != "" and current_value + value > max_value and (GetCurrentOverPwr() + ConvertToReliquat(current_value + value, effect, 0) - ConvertToReliquat(max_value, effect, 0) < -101 or ConvertToReliquat(current_value + value, effect, 0) < -101))
		{
			return [0, ""]
		}
		return [value, effect]
	}
}

UseRune(value, effect) ; funUseRune 
{
	global height_5_4, width_5_4, x_5_4_s, y_5_4_s, locations_index, key_x, key_y, def_index, modif_max_index
		, effects_index, key_blank, key_pa, key_ra, key_rune, hex_color_rune, hex_color_fusion, hex_color_inventory
		, trash_bin
	from_inventory := false
	x := 0
	y := 0
	y_index := HasValue(def_index, effect)
	x_index := 0
	modifier := ""
	if(effects_index[effect][key_blank] = value)
	{
		x_index := 1
	}
	else if(effects_index[effect][key_pa] = value)
	{
		x_index := 2
		modifier := key_pa . " "
	}
	else if(effects_index[effect][key_ra] = value)
	{
		x_index := 3
		modifier := key_ra . " "
	}
	if((modif_max_index[y_index] = 0 and HasValue(trash_bin, effect) = 0) or y_index > 14)
	{
		from_inventory := true
		key_xy_search := "sea_xy"
		x_search := ConvertToPx(x_5_4_s, locations_index[key_xy_search][key_x], width_5_4)
		y_search := ConvertToPx(y_5_4_s, locations_index[key_xy_search][key_y], height_5_4)
		key_xy_inventory := "inv_xy"
		x := ConvertToPx(x_5_4_s, locations_index[key_xy_inventory][key_x], width_5_4)
		y := ConvertToPx(y_5_4_s, locations_index[key_xy_inventory][key_y], height_5_4)
		
		delay_ms := 0
		temp_hex_color := ""
		SendInput {Click %x_search% %y_search% 3}
		no_result := "_$_"
		SendInput {Raw}%no_result%
		PixelGetColor, temp_hex_color, %x%, %y%, Slow
		counter := 0
		while(temp_hex_color != hex_color_inventory)
		{
			if(Mod(counter, 20) = 0)
			{
				SendInput {Enter}
				SendInput {Click %x_search% %y_search% 3}
				no_result := "_$_"
				SendInput {Raw}%no_result%
			}
			Random, delay_ms, 50, 100
			Sleep, %delay_ms%
			PixelGetColor, temp_hex_color, %x%, %y%, Slow
			counter := counter + 1
		}
		SendInput {Click %x_search% %y_search% 3}
		str_rune := effects_index[effect][key_rune]
		SendInput {Raw}%key_rune% %modifier%%str_rune%
		PixelGetColor, temp_hex_color, %x%, %y%, Slow
		while(temp_hex_color = hex_color_inventory)
		{
			Random, delay_ms, 50, 100
			Sleep, %delay_ms%
			PixelGetColor, temp_hex_color, %x%, %y%, Slow
		}
	}
	else
	{
		key_xy_s := "run_xy_s"
		key_x_d := "run_x_d"
		key_y_d := "run_y_d"
		y := ConvertToPx(y_5_4_s, locations_index[key_xy_s][key_y], height_5_4, locations_index[key_y_d][key_y], y_index - 1)
		if(x_index = 0)
		{
			MsgBox, Fatal _error _no rune found
			return false
		}
		x := ConvertToPx(x_5_4_s, locations_index[key_xy_s][key_x], width_5_4, locations_index[key_x_d][key_x], x_index - 1)
	}
	
	delay_ms := 0
	
	key_color_xy := "col_xy"
	x_no_rune := ConvertToPx(x_5_4_s, locations_index[key_color_xy][key_x], width_5_4)
	y_no_rune := ConvertToPx(y_5_4_s, locations_index[key_color_xy][key_y], height_5_4)
	no_hex_color_rune := ""
	
	key_fus_xy := "fus_xy"
	x_fus := ConvertToPx(x_5_4_s, locations_index[key_fus_xy][key_x], width_5_4)
	y_fus := ConvertToPx(y_5_4_s, locations_index[key_fus_xy][key_y], height_5_4)
	no_hex_color_fusion := ""
	
	PixelGetColor, no_hex_color_fusion, %x_fus%, %y_fus%, Slow
	
	if(no_hex_color_fusion != hex_color_fusion)
	{
		SendInput {Enter}
		SendInput {Ctrl Down}
		SendInput {Click %x_no_rune% %y_no_rune% 2}
		Sleep, 100
		SendInput {Ctrl Up}
		SendInput {Click 0 0 0}

		PixelGetColor, no_hex_color_fusion, %x_fus%, %y_fus%, Slow
		
		while(no_hex_color_fusion != hex_color_fusion)
		{
			i := 0
			while(no_hex_color_fusion != hex_color_fusion and i < 40)
			{
				i := i + 1
				Random, delay_ms, 50, 100
				Sleep, %delay_ms%
				PixelGetColor, no_hex_color_fusion, %x_fus%, %y_fus%, Slow
			}
			if(i = 40 and no_hex_color_fusion != hex_color_fusion)
			{
				SendInput {Enter}
				SendInput {Ctrl Down}
				SendInput {Click %x_no_rune% %y_no_rune% 2}
				Sleep, 100
				SendInput {Ctrl Up}
				SendInput {Click 0 0 0}
				
				PixelGetColor, no_hex_color_fusion, %x_fus%, %y_fus%, Slow
			}
		}
	}
	
	SendInput {Click %x% %y% 2}
	
	PixelGetColor, no_hex_color_fusion, %x_fus%, %y_fus%, Slow
	
	i := 0
	while(no_hex_color_fusion = hex_color_fusion and i < 40)
	{
		i := i + 1
		Random, delay_ms, 50, 100
		Sleep, %delay_ms%
		PixelGetColor, no_hex_color_fusion, %x_fus%, %y_fus%, Slow
	}
	if(i = 40 and no_hex_color_fusion = hex_color_fusion)
	{
		return UseRune(value, effect)
	}
	
	sent_fusion := false
	SendInput {Click %x_fus% %y_fus% 2}
	
	; on peut certifier qu'on a fait le fusionner si on capture que fusionner est devenu gris après le clic
	PixelGetColor, no_hex_color_fusion, %x_fus%, %y_fus%, Slow
	i := 0
	while(no_hex_color_fusion != hex_color_fusion and i < 40)
	{
		i := i + 1
		Random, delay_ms, 50, 100
		Sleep, %delay_ms%
		PixelGetColor, no_hex_color_fusion, %x_fus%, %y_fus%, Slow
	}
	if(no_hex_color_fusion = hex_color_fusion)
	{
		sent_fusion := true
	}
	
	PixelGetColor, no_hex_color_rune, %x_no_rune%, %y_no_rune%, Slow
	
	i := 0
	while(no_hex_color_rune != hex_color_rune and i < 40)
	{
		i := i + 1
		Random, delay_ms, 50, 100
		Sleep, %delay_ms%
		PixelGetColor, no_hex_color_rune, %x_no_rune%, %y_no_rune%, Slow
	}
	if(i = 40 and no_hex_color_rune != hex_color_rune)
	{
		PixelGetColor, no_hex_color_fusion, %x_fus%, %y_fus%, Slow
	
		if(no_hex_color_fusion != hex_color_fusion)
		{
			SendInput {Enter}
			SendInput {Ctrl Down}
			SendInput {Click %x_no_rune% %y_no_rune% 2}
			Sleep, 100
			SendInput {Ctrl Up}
			SendInput {Click 0 0 0}

			PixelGetColor, no_hex_color_fusion, %x_fus%, %y_fus%, Slow
			
			while(no_hex_color_fusion != hex_color_fusion)
			{
				i := 0
				while(no_hex_color_fusion != hex_color_fusion and i < 40)
				{
					i := i + 1
					Random, delay_ms, 50, 100
					Sleep, %delay_ms%
					PixelGetColor, no_hex_color_fusion, %x_fus%, %y_fus%, Slow
				}
				if(i = 40 and no_hex_color_fusion != hex_color_fusion)
				{
					SendInput {Enter}
					SendInput {Ctrl Down}
					SendInput {Click %x_no_rune% %y_no_rune% 2}
					Sleep, 100
					SendInput {Ctrl Up}
					SendInput {Click 0 0 0}
					
					PixelGetColor, no_hex_color_fusion, %x_fus%, %y_fus%, Slow
				}
			}
		}
		Sleep, 2000
		if(sent_fusion = false)
		{
			return false
		}
	}
	return true
}

MainRoutine() ; funMainRoutine
{
	global min_index, max_index, vef_index, def_index, reliquat, instructions_index, key_effects
		, key_values, modif_max_index, more_additional_index, auto_bypass
	Sleep, 1000
	
	finished := false
	while(finished = false)
	{
		authorized_bypass := true
		if(GetNeededReliquat(min_index) + reliquat >= 0)
		{
			authorized_bypass := false
		}
		rune := ChooseRune(min_index, true, authorized_bypass)
		if(rune[1] = 0)
		{
			authorized_bypass := true
			if(GetNeededReliquat(modif_max_index) + reliquat >= 0)
			{
				authorized_bypass := false
			}
			rune := ChooseRune(modif_max_index, true, authorized_bypass)
			if(rune[1] = 0)
			{
				rune := ChooseRune(modif_max_index, false, authorized_bypass)
				if(rune[1] = 0)
				{
					For _priority, objective in more_additional_index
					{
						index_over_1 := 0
						For index_instructions_effect, effect in instructions_index[_priority][key_effects]
						{
							index_def_effect := HasValue(def_index, effect)
							if(index_def_effect = 0)
							{
								MsgBox, erreur effet d objectif pas enregistre %effect%
							}
							else if(objective[index_def_effect] > modif_max_index[index_def_effect]) ; yolo condition changed 
							{
								index_over_1 := index_def_effect
								break
							}
						}
						if(index_over_1 != 0)
						{
							if(objective[index_over_1] > vef_index[index_over_1] and (reliquat - GetCurrentOverPwr(index_over_1) + ConvertToReliquat(objective[index_over_1], def_index[index_over_1], 0) - ConvertToReliquat(vef_index[index_over_1], def_index[index_over_1], 0) >= 0)) ; yolo a test (prend en compte les over d'effets differents pour du reliquat
							{
								auto_bypass := false
								rune := ChooseRune(objective, false, false)
							}
							else if(objective[index_over_1] = vef_index[index_over_1] or (HasValue(instructions_index[_priority][key_effects], def_index[index_over_1]) = instructions_index[_priority][key_effects].Length() and objective[index_over_1] - max_index[index_over_1] = 1)) ; yolo condition changed
							{
								rune := ChooseRune(modif_max_index, false, true)
								if(rune[1] = 0)
								{
									rune := ChooseRune(objective, false, true)
								}
							}
							else if(_priority = instructions_index.Length()) ; yolo adapted condition
							{
								rune := ChooseRune(objective, false, true, true)
							}
							if(rune[1] != 0)
							{
								break
							}
						}
					}
				}
			}
		}
		if(rune[1] != 0)
		{
			attempt := UseRune(rune[1], rune[2])
			if(attempt = true)
			{
				ApplyAttemptChanges(rune[1], rune[2])
			}
			else
			{
				Recalibrate()
			}
		}
		else
		{
			finished := true
		}
	}
	MsgBox, Objet terminé _ reliquat _ %reliquat%
}

; bottom