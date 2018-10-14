; #InstallKeybdHook

;---------
SetCapsLockState, AlwaysOff 
Process Priority,,High
DetectHiddenWindows, On
SetWinDelay, 0

global Hyper, Flag, HyperAlt，HyperWin, FuncRunning

;include should be put at last
;
#Include lib/Settings.ahk


;-----------CapsLock key setting----------
!Esc::
Suspend, Permit
if %A_IsSuspended%
{
    Suspend
    InfoMsg("Enable the script")
}
else
{
    InfoMsg("Suspend the script")
    Suspend
}

return

Capslock::

Hyper := 1
Flag := 0
HyperAlt := 0
HyperWin := 0
FuncRunning := 0

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

if (FuncRunning = 1)
{
    ; msgbox FuncRunning
    return  ; avoid multi hotkey conflict
}

key :=  A_ThisHotkey

; SPEC_KEYS := "``-=[]\;',./"
SPEC_KEY_TO_NAME := {"``":"backquote","-":"minus","=":"equal","[":"lbracket","]":"rbracket"
  ,"\":"backslash",";":"semicolon","'":"quote",",":"comma",".":"dot","/":"slash"}

;if (InStr(SPEC_KEYS, key) != 0)
if SPEC_KEY_TO_NAME.haskey(key)
{
    keyname := SPEC_KEY_TO_NAME[key]
    ; msgbox % keyname
}
else
{
    keyname := key
}

; msgbox % keyname


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
    ; msgbox %func_name%
    FuncRunning := 1 ; avoid multiple capslock key confict
    RunFunc(func_name)
    DebugMsg(Format("Key:{}`nFunc:{}", keyname, func_name))
    FuncRunning := 0
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
    RunThreadedFunc(func_name)
    DebugMsg(Format("Key:{}`nFunc:{}", keyname, func_name))
}
return


;---------test
!z::
SuccessMsg("Start Capslock++")
return





