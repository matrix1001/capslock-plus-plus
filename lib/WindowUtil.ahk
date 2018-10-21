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
WindowMoveTopHalf( winTitle )
{
    ;msgbox test
    SysGet, Mon, MonitorWorkArea
    x := MonLeft
    y := MonTop
    w := MonRight-MonLeft
    h := (MonBottom-MonTop)/2
    ;msgbox %x%, %y%, %w%, %h%
    WinMove, %winTitle%,, %x%, %y%, %w%, %h% 
}
WindowMoveBottomHalf( winTitle )
{
    ;msgbox test
    SysGet, Mon, MonitorWorkArea
    x := MonLeft
    y := (MonBottom-MonTop)/2
    w := MonRight-MonLeft
    h := (MonBottom-MonTop)/2
    ;msgbox %x%, %y%, %w%, %h%
    WinMove, %winTitle%,, %x%, %y%, %w%, %h% 
}
WindowMoveLeftHalf( winTitle )
{
    ;msgbox test
    SysGet, Mon, MonitorWorkArea
    x := MonLeft
    y := MonTop
    w := (MonRight-MonLeft)/2
    h := MonBottom-MonTop
    ;msgbox %x%, %y%, %w%, %h%
    WinMove, %winTitle%,, %x%, %y%, %w%, %h% 
}
WindowMoveRightHalf( winTitle )
{
    ;msgbox test
    SysGet, Mon, MonitorWorkArea
    x := (MonRight-MonLeft)/2
    y := MonTop
    w := (MonRight-MonLeft)/2
    h := MonBottom-MonTop
    ;msgbox %x%, %y%, %w%, %h%
    WinMove, %winTitle%,, %x%, %y%, %w%, %h% 
}