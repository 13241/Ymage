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
; force maximalize window for most accurate resolution

; Initialization
height_5_4 := 0
width_5_4 := 0
x_5_4_s := 0
y_5_4_s := 0
Hotkey, !Numpad0, Termination, On
Hotkey, !Numpad1, CalibrateSize, On
return


; functions
HideTrayTip() 
{
	TrayTip  ; Attempt to hide it the normal way.
	if SubStr(A_OSVersion, 1, 3) = "10." 
	{
		Menu Tray, NoIcon
		Sleep 200  ; It may be necessary to adjust this sleep.
		Menu Tray, Icon
	}
}

Termination()
{
	HideTrayTip()
	TrayTip, , Exiting App
	ExitApp
}

CalibrateSize()
{
	global height_5_4, width_5_4, x_5_4_s, y_5_4_s
	SysGet, width_margin_w, 32 ; window resizable zone, horizontal size
	SysGet, height_margin_w, 33 ; window resizable zone, vertical size
	SysGet, border_w, 4 ; height of window title bar
	SysGet, x_w, MonitorWorkArea ; represents usables coordinates of the screen. four variables, add Left Right Top Bottom to get either of them
	WinMaximize, A ; current window
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
	
	; test
	; HideTrayTip()
	; TrayTip, , x %x_tw% y %y_tw% width %width_tw% height %height_tw% x_m %x_m% y_m %y_m% x_screen %A_ScreenWidth% y_screen %A_ScreenHeight% width_margin_w %width_margin_w% height_margin_w %height_margin_w% border_w %border_w% toolbar width %x_wLeft%
	; TrayTip, , %width_5_4% %height_5_4% %x_5_4_s% %x_5_4_e%
	; testvar := ConvertToPx(x_5_4_s, 0.582896237, width_5_4, 0.045610034, 1)
	; testvar2 := ConvertToPx(border_w, 0.316989738, height_5_4, 0.038154548, 11)
	; TrayTip, , %testvar% %testvar2%
}

ConvertToPx(delta_margin, ratio, reference, delta_ratio := 0, n_delta_ratio := 0)
{
	return delta_margin + ((ratio + n_delta_ratio * delta_ratio) * reference) // 1
}

ReadFile(file_name)
{
	file := FileOpen(file_name, "r")
	
}