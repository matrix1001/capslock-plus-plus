
#If MouseIsOver("ahk_class Shell_TrayWnd ahk_exe Explorer.exe")
WheelUp::Send {Volume_Up}     ; Wheel over taskbar: increase/decrease volume.
WheelDown::Send {Volume_Down} ;
; XButton1::Send #^{Right} 
; XButton2::Send #^{Left} 

#If