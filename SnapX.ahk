﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn   ; Enable warnings to assist with detecting common errors.
#SingleInstance force
if not A_IsAdmin
{
	Run *RunAs "%A_ScriptFullPath%"
	ExitApp
}
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ahk2exe directives (http://fincs.ahk4.net/Ahk2ExeDirectives.htm)

; icon 1
;@Ahk2Exe-SetMainIcon Resources\SnapX.ico
;@Ahk2Exe-SetCopyright Copyright © Ben Allred
;@Ahk2Exe-SetCompanyName Ben Allred
;@Ahk2Exe-SetOrigFilename SnapX.exe
; @ Ahk2Exe-SetName			; this is set in Settings.ahk
; @ Ahk2Exe-SetDescription	; this is set in Settings.ahk
; @ Ahk2Exe-SetVersion		; this is set in Build.ahk

; icon 4
;@Ahk2Exe-AddResource Resources\SnapX_Suspended.ico, 206
; icon 6
;@Ahk2Exe-AddResource Resources\About.ico
; icon 7
;@Ahk2Exe-AddResource Resources\Update.ico
; icon 8
;@Ahk2Exe-AddResource Resources\Settings.ico
; icon 9
;@Ahk2Exe-AddResource Resources\Reload.ico
; icon 10
;@Ahk2Exe-AddResource Resources\Suspend.ico
; icon 11
;@Ahk2Exe-AddResource Resources\Resume.ico
; icon 12
;@Ahk2Exe-AddResource Resources\Exit.ico
; icon 13
;@Ahk2Exe-AddResource Resources\Help.ico
; icon 14
;@Ahk2Exe-AddResource Resources\Windows.ico

; Third-party libraries

#Include Include\WinGetPosEx.ahk
#Include Include\Const_WinUser.ahk

; SnapX modules

#Include Modules\Settings.ahk
#Include Modules\Debug.ahk
#Include Modules\UpdateChecker.ahk
#Include Modules\Tray.ahk
#Include Modules\Functions.ahk
#Include Modules\Classes.ahk
#Include Modules\Snapper.ahk
#Include Modules\AboutGui.ahk
#Include Modules\SettingsGui.ahk
#Include Modules\HelpGui.ahk

#Include Build.ahk

; Startup



Tray.initIcon()

;SoundPlay *64
TrayTip, % Settings.programTitle, Loaded

g_settings := new Settings()
g_debug := new Debug(g_settings)
g_updateChecker := new UpdateChecker(g_settings, Build)
g_snapper := new Snapper(g_settings)
g_tray := new Tray(g_settings, Build, g_updateChecker, g_snapper)

; Hotkeys
; [# - Win], [^ - control], [! - Alt] [+ - shift]
; See here: https://www.autohotkey.com/docs/Hotkeys.htm

#If g_settings.debug > 1
#`::Reload ; for ease of testing during development
#~::Run, powershell ; opens PowerShell (for Git) in the current working directory
#If

; Launch hotkeys
;#!+s::Run, spotify

; Launch Win-Tab
#Up::Send {LWin down}{Tab}{LWin up}
; Maximize Window
#!Up::WinMaximize, A
#!Down::WinMinimize, A
#MaxThreadsBuffer On

; Movement
#!h::g_snapper.moveWindow(0, -1, 0, 0, 0) ; move left
#!j::g_snapper.moveWindow(0, 0, 0, 1, 0)  ; move down
#!k::g_snapper.moveWindow(0, 0, 0, -1, 0) ; move up
#!l::g_snapper.moveWindow(0, 1, 0, 0, 0)  ; move right


; Sizing
#!y::g_snapper.moveWindow(0, 0, -1, 0, 0)  ; decrease width
#!u::g_snapper.moveWindow(0, 0, 0, 0, -1)  ; size height toward bottom
#!i::g_snapper.moveWindow(0, 0, 0, 0, 1)   ; size height toward top
#!o::g_snapper.moveWindow(0, 0, 1, 0, 0)   ; increase width






; movement between multiple monitors
; 	sleep allows time for Windows to do the movement to the new monitor before we re-snap according to the new monitor's width/height
~#+Left::
	Sleep, 10
	snapper.moveWindow(0, 0, 0, 0, 0)
	return
~#+Right::
	Sleep, 10
	snapper.moveWindow(0, 0, 0, 0, 0)
	return