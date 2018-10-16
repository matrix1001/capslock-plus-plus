#Include lib/BasicFunc.ahk



WinNotification(message, title, delay:=3000) ;note: accept only two lines for message
{
    static records := []

    ;turn off threads to avoid race condition
    SetTimer, notichecker, off
    SetTimer, noticounter, off
 
    ;max notification limit
    while (records.count() >= HyperSettings.Notify.Max)
    {
        val := records.pop()
        hwnd := val.hwnd
        Gui, %hwnd%:Destroy
    }

    info := WinNotificationInit(message, title)
    info.counter := delay

    ;move old notification up
    prev_height := info.height 
    for index, val in records
    {
        ;msgbox %index%
        if (val.counter > 0)
        {
            hwnd := val.hwnd
            y := val.y - prev_height
            Gui, %hwnd%:Show, NoActivate  NA y%y% 
            prev_height += val.height
        }
    }

    ;show new notification
    hwnd := info.hwnd
    Width := info.Width
    Height := info.Height
    x := info.x
    y := info.y 
    if StrEq(HyperSettings.Notify.Style, "fade")
    {
        Gui, %hwnd%:Show, W%Width% H%Height% NoActivate Hide x%x% y%y%
        WinFade(hwnd, "in", 300)
    }
    else if StrEq(HyperSettings.Notify.Style, "slide")
    {
        Gui, %hwnd%:Show, W%Width% H%Height% NoActivate Hide x%x% y%y%
        WinSlide(hwnd, "in", "r", 300)
    }
    else
    {
        Gui, %hwnd%:Show, W%Width% H%Height% NoActivate x%x% y%y%
    }

    
    records.insertat(1, info)

    SetTimer, notichecker, 250
    SetTimer, noticounter, 250
    return


    noticounter:
    for index, val in records
    {
        
        val.counter -= 250
        records[index] := val
    }
    return
    notichecker:
    rrecords := GetReverseArray(records)
    for index, val in rrecords
    {
        if (val.counter < 0)
        {
            hwnd := val.hwnd
            if StrEq(HyperSettings.Notify.Style, "fade")
            {
                WinFade(hwnd, "out", 200)
            }
            else if StrEq(HyperSettings.Notify.Style, "slide")
            {
                WinSlide(hwnd, "out", "l", 200)
            }
            else
            {
                Gui, %hwnd%:Cancel
            }
        }
    }
    return

}

WinNotificationInit(message, title, Width:=400) 
{
    ;static hwnd
    Gui, New
    Gui, +AlwaysOnTop +ToolWindow -SysMenu -Caption +LastFound +Hwndhwnd -DPIScale
    Gui, Color, 808080
    Gui, Margin, 0, 10
    Gui, Font, s13 cD0D0D0 Bold
    Gui, Add, Progress, % "x-1 y-1 w" (Width+2) " h31 Background404040 Disabled hwndHPROG"
    Gui, Add, Text, % "x0 y0 w" Width " h30 BackgroundTrans Center 0x200", %title%
    Gui, Font, s10
    Gui, Add, Text, % "x7 y+10 Center w" (Width-14), %message%

    pos := WinGetPosHide(hwnd, Width)  

    Height := pos.height
    ;msgbox % pos.width
    WinSet, Region, 0-0 w%Width% h%Height% r6-6
    
    SysGet, Mon, MonitorWorkArea
    x := MonRight-pos.width-5
    y := MonBottom-pos.height-5

    return {"x":x, "y":y, "width":Width, "height":Height, "hwnd":hwnd}
}

WinSlide(hwnd, method:="in", begin_pos:="b", delay:=500) ;direction: l, r, u, d
{
    ;https://docs.microsoft.com/en-us/windows/desktop/api/winuser/nf-winuser-animatewindow
    ;value := 0x40000+method*0x10000
    if StrEq(method, "in")
    {
        value := 0x40000
    }
    else
    {
        value := 0x50000
    }
    if InStr(begin_pos, "t")
    {
        value += 4
    }
    if InStr(begin_pos, "b")
    {
        value += 8
    }
    if InStr(begin_pos, "l")
    {
        value += 1
    }
    if InStr(begin_pos, "r")
    {
        value += 2
    }
    ;msgbox %value%
    DllCall("AnimateWindow","UInt",hwnd,"Int",delay,"UInt",value)
    Return
}
WinFade(hwnd, method:="out", delay:=1000) 
{
    if StrEq(method, "out")
    {
        value := 0x90000
    }
    else
    {
        value := 0xa0000
    }
    DllCall("AnimateWindow","UInt",hwnd,"Int",delay,"UInt",value)
    return
}

WinGetPosHide(hwnd, W:="", H:="")
{
    if (W && H)
    {
        Gui, %hwnd%:Show, NoActivate Hide W%W% H%H%
    }
    else if (W)
    {
        Gui, %hwnd%:Show, NoActivate Hide W%W%
    }
    else if (H)
    {
        Gui, %hwnd%:Show, NoActivate Hide H%H%
    }
        
    WinGetPos, x, y, width, height
    result := {"width": width, "height":height, "x":x, "y":y}
    return result
}


SplashText(msg, title := "", width := 400, delay := 3000)
{
    length := StrLen(msg)
    height := ToInt(length / 40) * 20 + CountLines(msg) * 20 + 30
    title := "Capslock++                  " . title
    SplashTextOn, %width%, %height%, %title%, %msg%
    WinGetPos,,, Width, Height, %title%
    WinMove, %title%, , (A_ScreenWidth)-(Width)-20, (A_ScreenHeight)-(Height)-40
    SetTimer, splashchk, %delay%
    return
    splashchk:
    if not MouseIsOver("ahk_class AutoHotkey2")
    {
        SplashTextOff
        SetTimer, splashchk, off
    }
    return
}
ToolTip(msg, delay := 1000)
{
    ToolTip %msg%
    SetTimer, tooltipoff, -%delay%
    return
    tooltipoff:
    ToolTip
    return

}
OnMouseToolTip(msg, delay := 1000)
{
    MouseGetPos X, Y
    ToolTip %msg%, X, Y
    SetTimer, tooltipchk, %delay%
    return
    tooltipchk:
    if not MouseIsOver("ahk_class tooltips_class32")
    {
        ToolTip
        SetTimer, tooltipchk, off
    }
    return
}
OnCaretToolTip(msg, delay := 3000)
{
    if CheckIfCaretNotDetectable()
    {
        MouseGetPos X, Y
    }
    else
    {
        X := A_CaretX + 5
        Y := A_CaretY + 20
    }
    
    ;msgbox %X%, %Y%
    ToolTip %msg%, X, Y
    SetTimer, carettooltipchk, %delay%
    return
    carettooltipchk:
    if not MouseIsOver("ahk_class tooltips_class32")
    {
        ToolTip
        SetTimer, tooltipchk, off
    }
    return
}


