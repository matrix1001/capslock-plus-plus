#Include lib/WinGetPosEx.ahk
IsWindowFullScreen( winTitle ) 
{
    ;https://autohotkey.com/board/topic/38882-detect-fullscreen-application/
	;checks if the specified window is full screen
	
	winID := WinExist( winTitle )

	If ( !winID )
		Return false

	WinGet style, Style, ahk_id %WinID%
	WinGetPos ,,,winW,winH, %winTitle%
	; 0x800000 is WS_BORDER.
	; 0x20000000 is WS_MINIMIZE.
	; no border and not minimized
	Return ((style & 0x20800000) or winH < A_ScreenHeight or winW < A_ScreenWidth) ? false : true
}
GetWindowClass( winTitle )
{
    winID := WinExist( winTitle )
    WinGetClass, cls, ahk_id %winID%
    return cls
}
GetWindowName( winTitle )
{
    winID := WinExist( winTitle )
    WinGet, name, ProcessName, ahk_id %winID%
    return name
}
IsDesktop( winTitle )
{
    cls := GetWindowClass(winTitle)
    name := GetWindowName(winTitle)
    return (cls == "WorkerW" || cls = "Progman" ) && (name == "Explorer.EXE" || name == "explorer.exe")
    
}

WindowMove(winTitle, position)
{
    static records := {}
    SysGet, Mon, MonitorWorkArea

    if (position == "top")
    {
        posX := MonLeft
        posY := MonTop
        width := MonRight-MonLeft
        height := (MonBottom-MonTop)/2
    }
    else if (position == "bottom")
    {
        posX := MonLeft
        posY := (MonBottom-MonTop)/2
        width := MonRight-MonLeft
        height := (MonBottom-MonTop)/2
    }
    else if (position == "left")
    {
        posX := MonLeft
        posY := MonTop
        width := (MonRight-MonLeft)/2
        height := MonBottom-MonTop
    }
    else if (position == "right")
    {
        posX :=(MonRight-MonLeft)/2
        posY := MonTop
        width := (MonRight-MonLeft)/2
        height := MonBottom-MonTop
    }
    
    ;msgbox %x%, %y%, %w%, %h%
    ;WinMove, %winTitle%,, %x%, %y%, %w%, %h% 

    WinGet activeWin, ID, %winTitle%
    WinRestore, ahk_id %activeWin%
    WinGetPosEx(activeWin, X, Y, realWidth, realHeight, offsetX, offsetY)

    if records.haskey(activeWin) 
    {
        if (records[activeWin]["action"] == position)
        {
            oldx := records[activeWin]["x"]
            oldy := records[activeWin]["y"]
            oldw := records[activeWin]["w"]
            oldh := records[activeWin]["h"]
            ;msgbox %oldx%, %oldy%
            WinMove, ahk_id %activeWin%,, %oldx%, %oldy%, %oldw%, %oldh%
            records.delete(activeWin)
            return
        }
        else
            records[activeWin]["action"] := position
    }
    else
    {
        ;msgbox %X%, %Y%
        record := {"x":X, "y":Y, "w":realWidth, "h":realHeight, "action":position}
        records[activeWin] := record
    }
    WinMove, ahk_id %activeWin%,, (posX + offsetX), (posY + offsetY), (width + offsetX * -2), (height + (offsetY - 2) * -2)

}
WindowMax(winTitle)
{
    WinGet activeWin, ID, %winTitle%
    WinGet, var, MinMax, ahk_id %activeWin%
    if (var != 1)
    {
        WinMaximize, ahk_id %activeWin%
    }
    else
        WinRestore, ahk_id %activeWin%
}

WindowMin(winTitle)
{
    WinGet activeWin, ID, %winTitle%
    WinGet, var, MinMax, ahk_id %activeWin%
    if (var != -1)
    {
        WinMinimize, ahk_id %activeWin%
    }
    else
        WinRestore, ahk_id %activeWin%
}
