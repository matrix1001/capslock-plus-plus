;#InstallKeybdHook

;---------
SetCapsLockState, AlwaysOff 
Process Priority,,High
SetWinDelay, 0
SetKeyDelay, 0
SendMode, Input
CoordMode, Caret
CoordMode, ToolTip
CoordMode, Mouse

global Hyper, Flag, HyperAlt，HyperWin
Menu, Tray, Icon, hyper.ico, , 1

Menu, Tray, NoStandard
Menu, Tray, add, Capslock++, OpenGithub
Menu, Tray, add
Menu, Tray, add, Open Directory, OpenScriptDir
Menu, Tray, Default, Open Directory
Menu, Tray, add, Edit Settings, EditSettings
Menu, Tray, add, Edit SwitchSettings, EditSwitchSettings
Menu, Tray, add, Reset All Settings, ResetSettings
Menu, Tray, add, Reload, HyperReload
Menu, Tray, add
Menu, Tray, add, Disable On Full Screen, ToggleDisableOnFullScreen
Menu, Tray, add, Run As Admin, RunAsAdmin

Menu, MsgLevel, add, Debug, SetMsgLevel
Menu, MsgLevel, add, Normal, SetMsgLevel
Menu, MsgLevel, add, WarnOnly, SetMsgLevel
Menu, MsgLevel, add, Disable, SetMsgLevel
Menu, MsgLevel, add
Menu, MsgLevel, add, Disable On Full Screen, SetMsgLevel

Menu, Tray, add
Menu, Tray, add, Message Level, :MsgLevel

Menu, defaultmenu, Standard
Menu, Tray, add
Menu, Tray, add, AutoHotkey, :defaultmenu

SetTimer, TrayMenuRefresh, 250

#Include lib/Settings.ahk


OpenGithub:
run https://github.com/matrix1001/capslock-plus-plus
return
OpenScriptDir:
run %A_ScriptDir%
return
EditSettings:
run HyperSettings.ini
return
EditSwitchSettings:
run HyperSwitchSettings.ini
return
ResetSettings:
msgbox 0x124, Capslock++, Are you sure to reset all settings?
IfMsgBox, Yes
{
    FileDelete, HyperSettings.ini
    FileDelete, HyperSwitchSettings.ini
    HyperReload()
}
return
ToggleDisableOnFullScreen:
HyperSettings.Basic.DisableOnFullScreen := (HyperSettings.Basic.DisableOnFullScreen = 0) ? 1:0
return
RunAsAdmin:
if not A_IsAdmin ;running by administrator
{
    Run *RunAs "%A_ScriptFullPath%" 
    ExitApp
} 
return
SetMsgLevel:
if StrEq(A_ThisMenuItem, "Disable")
{
    HyperSettings.Notify.MsgLevel := 3
}
if StrEq(A_ThisMenuItem, "WarnOnly")
{
    HyperSettings.Notify.MsgLevel := 2
}
if StrEq(A_ThisMenuItem, "Normal")
{
    HyperSettings.Notify.MsgLevel := 1
}
if StrEq(A_ThisMenuItem, "Debug")
{
    HyperSettings.Notify.MsgLevel := 0
}
if StrEq(A_ThisMenuItem, "Disable On Full Screen")
{
    HyperSettings.Notify.DisableOnFullScreen := (HyperSettings.Notify.DisableOnFullScreen = 0) ? 1:0
}
return

TrayMenuRefresh()
{
    ; tray tip
    stat := GetStatus()
    if (A_IsSuspended = 1)
        content := "Capslock++`nSuspended`n"
    else if (HyperSettings.RunTime.ScriptChange + HyperSettings.RunTime.SettingChange = 0)
        content := "Capslock++`nRunning`n"
    else
        content := "Capslock++`nRunning  (Reload needed)`n"
        
 
    for key, val in stat
    {
        content .= Format("{:-20}: {:-}`n", key, val)
    }
    content := SubStr(content, 1, -1)
    Menu, Tray, Tip, %content%

    ; message level
    Menu, MsgLevel, UnCheck, Disable
    Menu, MsgLevel, UnCheck, WarnOnly
    Menu, MsgLevel, UnCheck, Normal
    Menu, MsgLevel, UnCheck, Debug
    Menu, MsgLevel, UnCheck, Disable On Full Screen

    Menu, Tray, UnCheck, Disable On Full Screen
    Menu, Tray, UnCheck, Run As Admin
    if (HyperSettings.Notify.MsgLevel = 0)
        Menu, MsgLevel, Check, Debug
    if (HyperSettings.Notify.MsgLevel = 1)
        Menu, MsgLevel, Check, Normal
    if (HyperSettings.Notify.MsgLevel = 2)
        Menu, MsgLevel, Check, WarnOnly
    if (HyperSettings.Notify.MsgLevel = 3)
        Menu, MsgLevel, Check, Disable
    if (HyperSettings.Notify.DisableOnFullScreen = 1)
        Menu, MsgLevel, Check, Disable On Full Screen
    if (HyperSettings.Basic.DisableOnFullScreen = 1)
        Menu, Tray, Check, Disable On Full Screen

    if (A_IsAdmin = 1)
        Menu, Tray, Check, Run As Admin
}
GetStatus()
{
    stat := {"StartTime":HyperSettings.RunTime.StartTime}
    if (HyperSettings.RunTime.DoubleClickTrans = 1)
        stat["DoubleClickTrans"] := "enable"
    else
        stat["DoubleClickTrans"] := "disable"
    stat["MessageLevel"] := HyperSettings.Notify.MsgLevel
    return stat
}

;-----------CapsLock key setting----------
!Esc::
Suspend, Permit
if %A_IsSuspended%
{
    Suspend
    SetCapsLockState, AlwaysOff
    InfoMsg("Enable the script")
    Menu, Tray, Icon, hyper.ico, , 1
}
else
{
    InfoMsg("Suspend the script")
    SetCapsLockState, Off
    Menu, Tray, Icon, hyper-suspend.ico, , 1
    Suspend
}

return

Capslock::
if (HyperSettings.Basic.DisableOnFullScreen = 1 && IsWindowFullScreen("A") && not IsDesktop("A"))
    Hyper := 0
else
    Hyper := 1
Flag := 0
HyperAlt := 0
HyperWin := 0

KeyWait, Capslock

Hyper := 0
if (Flag = 0)
{

    Send {Esc}
}

Return

;------------Key to func-------
#If Hyper = 1
lalt::
HyperAlt := 1
return
lwin::
HyperWin := 1
return

a::
b::
c::
d::
e::
f::
g::
h::
i::
j::
k::
l::
n::
m::
o::
p::
q::
r::
s::
t::
u::
v::
w::
x::
y::
z::
1::
2::
3::
4::
5::
6::
7::
8::
9::
0::

esc::
f1::
f2::
f3::
f4::
f5::
f6::
f7::
f8::
f9::
f10::
f11::
f12::
backspace::


space::
tab::
enter::

`::
-::
=::
[::
]::
\::
`;::
'::
,::
.::
/::


rwin::
lshift::
rshift::
lctrl::
rctrl::
ralt::

left::
right::
up::
down::

wheelup::
wheeldown::

Critical  ; use this to make thread uninterruptable

key :=  A_ThisHotkey

; SPEC_KEYS := "``-=[]\;',./"
SPEC_KEY_TO_NAME := {"``":"backquote","-":"minus","=":"equal","[":"lbracket","]":"rbracket"
  ,"\":"backslash",";":"semicolon","'":"quote",",":"comma",".":"dot","/":"slash"}

if SPEC_KEY_TO_NAME.haskey(key)
{
    keyname := SPEC_KEY_TO_NAME[key]
}
else
{
    keyname := key
}

if (HyperAlt = 1)
{
    keyname := "alt_" . keyname
}
else if (HyperWin = 1)
{
    keyname := "win_" . keyname
}
keyname := "hyper_" . keyname
func_name := HyperSettings.Keymap[keyname]
try
{
    DebugMsg(Format("Key:{}`nFunc:{}", keyname, func_name))
    RunThreadedFunc(func_name)
}
catch e
{
    ErrorMsg(e, Format("Key:{}`nFunc:{}", keyname, func_name))
}

Flag := 1
Return

#If
;---------other key util
~*LButton::
c := HotKeyCounter(200)
if c=2
{
    keyname := "hyper_" . "double_click"
    func_name := HyperSettings.Keymap[keyname]
    DebugMsg(Format("Key:{}`nFunc:{}", keyname, func_name))
    RunThreadedFunc(func_name)
}
return


!z::
return


