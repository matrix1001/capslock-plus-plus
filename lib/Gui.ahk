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
    ;msgbox %X%, %Y%, scr %A_ScreenWidth%, %A_ScreenHeight%, car %A_CaretX%, %A_CaretY%
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




SuggestGui(opt := "", val := "", val2 := "")
{
    static CorrectCase := True, BoxHeight := 165, CurrentWord := "", SuggestHwnd := 0
    static ListBoxHwnd, init := 0, DisplayList := "", MaxWidth := 0, hWindow := 0

    ;splashtexton,,, %opt%
    if (init = 0)
    {
        Gui, Suggestions:Font, s10, Courier New
        Gui, Suggestions:+Delimiter`n
        Gui, Suggestions:Add, ListBox, x0 y0 h%BoxHeight% 0x100 gCompleteWord AltSubmit +HwndListBoxHwnd
        Gui, Suggestions:-Caption +ToolWindow +AlwaysOnTop +LastFound +HwndSuggestHwnd
        Gui, Suggestions:Show, h%BoxHeight% Hide, AutoComplete

        NormalKeyList := "a`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl`nm`nn`no`np`nq`nr`ns`nt`nu`nv`nw`nx`ny`nz"
        NumberKeyList := "1`n2`n3`n4`n5`n6`n7`n8`n9`n0"
        OtherKeyList := "'`n-"

        TriggerKeyList := "Tab`nEnter"
        ResetKeyList := "Backspace`n^z`nEsc`nSpace`nHome`nPGUP`nPGDN`nEnd`nLeft`nRight`nRButton`nMButton`n,`n.`n/`n[`n]`n;`n\`n=`n```n"""

        Hotkey, IfWinExist, AutoComplete ahk_class AutoHotkeyGUI
        Loop, Parse, TriggerKeyList, `n
            Hotkey, %A_LoopField%, CompleteWord, UseErrorLevel

        Loop, Parse, NormalKeyList, `n
            Hotkey, ~%A_LoopField%, SuggestHide, UseErrorLevel

        Loop, Parse, NumberKeyList, `n
            Hotkey, ~%A_LoopField%, SuggestHide, UseErrorLevel
        
        Loop, Parse, OtherKeyList, `n
            Hotkey, ~%A_LoopField%, SuggestHide, UseErrorLevel
        
        Loop, Parse, ResetKeyList, `n
            Hotkey, ~%A_LoopField%, SuggestHide, UseErrorLevel

        Hotkey, Up, SuggestMoveUp, UseErrorLevel
        Hotkey, Down, SuggestMoveDown, UseErrorLevel
        Hotkey, Capslock & j, SuggestMoveDown, UseErrorLevel
        Hotkey, Capslock & k, SuggestMoveUp, UseErrorLevel

        Hotkey, ~LButton, ClickChk, UseErrorLevel
        Loop, 9
        {
            Hotkey, !%A_Index%, AltComplete, UseErrorLevel
        }
        Hotkey, !0, AltComplete, UseErrorLevel

        
        Hotkey, IfWinExist

        init := 1
    }
    if StrEq(opt, "destroy")
    {
        Gui, Suggestions:Destroy
        SetTimer, SuggestGuiWatcher, off
        return
    }
    else if StrEq(opt, "hide")
    {
        gosub SuggestHide
        return
    }
    else if StrEq(opt, "show")
    {
        hwindow := WinExist("A")
        SetTimer, SuggestGuiWatcher, 100
        MatchList := val
        if (MatchList = "" || MatchList.count() = 0)
        {
            return
        }
        MaxWidth := 0
        DisplayList := ""
        for index, value in MatchList
        {
            Entry := value
            Width := TextWidth(Entry)
            If (Width > MaxWidth)
                MaxWidth := Width
            DisplayList .= Entry . "`n"
        }
        MaxWidth += 30 ;add room for the scrollbar
        DisplayList := SubStr(DisplayList,1,-1) ; no last `n
        CurrentWord := val2
    }

    ;update the interface
    GuiControl,, %ListBoxHwnd%, `n%DisplayList%
    GuiControl, Choose, %ListBoxHwnd%, 1
    GuiControl, Move, %ListBoxHwnd%, w%MaxWidth% ;set the control width

    if CheckIfCaretNotDetectable()
    {
        MouseGetPos, PosX, PosY
    }
    else
    {
        PosX := (A_CaretX != "" ? A_CaretX : 0) + 0
        PosY := (A_CaretY != "" ? A_CaretY : 0) + 20

    }

    If PosX + MaxWidth > A_ScreenWidth ;past right side of the screen
        PosX := A_ScreenWidth - MaxWidth
    If PosY + BoxHeight > A_ScreenHeight ;past bottom of the screen
        PosY := A_ScreenHeight - BoxHeight

    ;msgbox %PosX%, %PosY%, scr %A_ScreenWidth%, %A_ScreenHeight%, car %A_CaretX%, %A_CaretY%
    Gui, Suggestions:Show, x%PosX% y%PosY% w%MaxWidth% NoActivate ;show window

    Return

    CompleteWord:
    Critical

    ;only trigger word completion on non-interface event or double click on matched list
    If (A_GuiEvent != "" && A_GuiEvent != "DoubleClick")
        Return

    gosub SuggestHide
    ;retrieve the word that was selected
    GuiControlGet, Index,, %ListBoxHwnd%

    GuiControl, -AltSubmit, %ListBoxHwnd%
    GuiControlGet, NewWord, , %ListBoxHwnd%
    GuiControl, +AltSubmit, %ListBoxHwnd%

    SendWordReplace(CurrentWord,NewWord,CorrectCase)
    Return

    AltComplete:
    Key := SubStr(A_ThisHotkey, 2, 1)
    KeyWait, Alt
    GuiControl, Choose, %ListBoxHwnd%, % Key = 0 ? 10 : Key
    gosub CompleteWord
    return


    SuggestMoveUp:
    GuiControlGet, Temp1,, %ListBoxHwnd%
    If Temp1 > 1 ;ensure value is in range
        GuiControl, Choose, %ListBoxHwnd%, % Temp1 - 1
    return

    SuggestMoveDown:
    GuiControlGet, Temp1,, %ListBoxHwnd%
    GuiControl, Choose, %ListBoxHwnd%, % Temp1 + 1
    return

    SuggestHide:
    Gui, Suggestions:Hide
    SetTimer, SuggestGuiWatcher, off
    return

    SuggestGuiWatcher:
    window := WinExist("A")
    if (window = SuggestHwnd)
        return
    If (window != hWindow)
    {
        gosub SuggestHide
    }
    return

    ClickChk:
    MouseGetPos,,, hwnd
    if (hwnd = SuggestHwnd)
        return
    else
    {
        ;msgbox %Title%
        gosub SuggestHide
    }
        
    return
}

