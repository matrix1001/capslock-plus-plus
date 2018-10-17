; #InstallKeybdHook

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
menu, Tray, Icon, hyper.ico, , 1

menu, Tray, NoStandard
menu, Tray, add, Capslock++, OpenGithub
menu, Tray, add, Open Directory, OpenScriptDir
menu, Tray, Default, Open Directory
menu, Tray, add, Edit Settings, EditSettings
menu, Tray, add, Edit SwitchSettings, EditSwitchSettings
menu, Tray, add, Reset All Settings, ResetSettings

menu, defaultment, Standard
menu, Tray, add, AutoHotkey, :defaultment

SetTimer, IconGetStatus, 1000

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
    ScriptReload()
}
return

IconGetStatus()
{
    stat := GetStatus()
    content := "Capslock++  Status`n"
    for key, val in stat
    {
        content .= Format("{:-20}: {}`n", key, val)
    }
    content := SubStr(content, 1, -1)
    menu, Tray, Tip, %content%
}
GetStatus()
{
    stat := {}
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
    InfoMsg("Enable the script")
    menu, Tray, Icon, hyper.ico, , 1
}
else
{
    InfoMsg("Suspend the script")
    menu, Tray, Icon, hyper-suspend.ico, , 1
    Suspend
}

return

Capslock::

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
    RunFunc(func_name)
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


;---------test
!z::
return


