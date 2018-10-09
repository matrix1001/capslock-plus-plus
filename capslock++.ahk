; #InstallKeybdHook

;---------
SetCapsLockState, AlwaysOff 
Process Priority,,High

global Hyper, Flag, HyperAlt，HyperWin, FuncRunning

;include should be put at last
#Include lib/Settings.ahk


;-----------CapsLock key setting----------
!Esc::Suspend

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
    func_name := HyperSettings.Keymap["hyper_alt_" . keyname]
}
else if (HyperWin = 1)
{
    func_name := HyperSettings.Keymap["hyper_win_" . keyname]
}
else
{
    func_name := HyperSettings.Keymap["hyper_" . keyname]
}

try
{
    ; msgbox %func_name%
    FuncRunning := 1 ; avoid multiple capslock key confict
    RunFunc(func_name)
    FuncRunning := 0
}
catch e
{
    MsgBox, 16,, % "Exception thrown!`n`nwhat: " e.what "`nfile: " e.file
        . "`nline: " e.line "`nmessage: " e.message "`nextra: " e.extra
    Exit
}

Flag := 1
Return

#If


;---------test
!z:: ;for test
d := ReadDigit()
msgbox %d%
return





