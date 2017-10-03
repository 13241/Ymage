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
x_tw := 0
y_tw := 0
width_tw := 0
height_tw := 0
x_m := 0
y_m := 0
Hotkey, !Numpad0, Termination, On
Hotkey, !Numpad1, CalibrateSize, On
return


; functions
HideTrayTip() 
{
	TrayTip  ; Attempt to hide it the normal way.
	if SubStr(A_OSVersion,1,3) = "10." 
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
	global x_tw, y_tw, width_tw, height_tw, x_m, y_m
	SysGet, width_margin_w, 32 ; window resizable zone, horizontal size
	SysGet, height_margin_w, 33 ; window resizable zone, vertical size
	SysGet, border_w, 4 ; height of window title bar
	SysGet, x_w, MonitorWorkArea ; represents usables coordinates of the screen. four variables, add Left Right Top Bottom to get either of them
	WinMaximize, A ; current window
	WinGetPos, x_tw, y_tw, width_tw, height_tw, A ; positions and sizes of the active window, with all borders and margins
	MouseGetPos, x_m, y_m ; positions of the mouse, reference is the active window (with all borders)
	; 1096.25 => black margin 220.875 => 220 black pixel, 221 is colored => +1096 = 1317, px220&px1318 are transluscent (design), 1318->1538 black (margin 62), reasoning with first = 1 (not 0)
	width_5_4 := (height_tw-2*height_margin_w-border_w)/4*5 ; 
	x_5_4 := (width_tw-2*width_margin_w-width_5_4)/2
	
	; test
	HideTrayTip()
	; TrayTip, , x %x_tw% y %y_tw% width %width_tw% height %height_tw% x_m %x_m% y_m %y_m% x_screen %A_ScreenWidth% y_screen %A_ScreenHeight% margin_w %margin_w%
	TrayTip, , %width_5_4% %x_5_4% %x_wLeft% %border_w% 
}
; 550x260_600x760 = MIN
; 600x260_650x760 = MAX
; 650x260_850x760 = ACT
; 920x300 = UP LEFT RUNE
; 1020x300 = UP RIGHT RUNE
; 920x735 = DOWN LEFT RUNE
; 1020x735 = DOWN RIGHT RUNE
; 3 = HORIZONTAL
; 14 = VERTICAL
; 1230x690 = SEARCH INVENTORY
; 1110x180 = RUNE INVENTORY
; 310x132 = FIRST LINE START
; 510x736 = LAST LINE END
; 42 = VERTICAL LINES
; 281 = HORIZONTAL TRESHOLD
; 23 = VERTICAL TRESHOLD


