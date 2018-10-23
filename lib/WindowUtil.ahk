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
WindowMove(winTitle, position)
{
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

    WinGetPosEx(activeWin, X, Y, realWidth, realHeight, offsetX, offsetY)
    WinMove, A,, (posX + offsetX), (posY + offsetY), (width + offsetX * -2), (height + (offsetY - 2) * -2)

}