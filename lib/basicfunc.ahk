;------function util
RunFunc(str)
{
    if (!RegExMatch(Trim(str), "\)$"))
    {
        result := %str%()
        return result
    }
    else if (RegExMatch(str, "(\w+)\((.*)\)$", match))
    {
        func := Func(match1)
        
        if (!match2)
        {
            result := func.()
            return result
        }
        else
        {
            params:={}
            loop, Parse, match2, CSV
            {
                params.insert(A_LoopField)
            }
            parmasLen:=params.MaxIndex()
            result := func.(params*)
            return result
        }
    }
    return
}

RunThreadedFunc(str)
{
    static func_name, func, params
    if (!RegExMatch(Trim(str), "\)$"))
    {
        func_name := str
        SetTimer, direct, -1
        return
    }
    else if (RegExMatch(str, "(\w+)\((.*)\)$", match))
    {
        func := Func(match1)
        
        if (!match2)
        {
            SetTimer, noarg, -1
            return
        }
        else
        {
            params:={}
            loop, Parse, match2, CSV
            {
                params.insert(A_LoopField)
            }
            parmasLen:=params.MaxIndex()
            SetTimer, witharg, -1
            return
        }
    }
    return

    direct:
    ;msgbox direct, %func_name%
    %func_name%()
    return

    noarg:
    func.()
    return

    witharg:
    func.(params*)
    return
}

;--------IO function
FileList(dir)
{
    
    fulldir := Format("{1}\*", dir)
    ; msgbox %fulldir%
    lst := []
    Loop, Files, %fulldir%, F ; file only, ignore subdir
    {
        ; msgbox %A_LoopFileName%
        path := Format("{1}\{2}", dir, A_LoopFileName)
        lst.Push(path)
    }
    return lst
}
GetSelText() ;does not work with some terminals
{
    WinActive("A")                           
    ControlGetFocus, ctrl
    ControlGet, selText, Selected, ,%ctrl%
    if (selText != "")
    {
        return selText
    }

    ClipboardOld := ClipboardAll
    Clipboard := ""
    SendInput, ^{insert}
    ClipWait, 0.1
    if (!ErrorLevel)
    {
        selText := Clipboard
        Clipboard := ClipboardOld
        StringRight, lastChar, selText, 1
        if (Asc(lastChar) != 10) ;last char is `n, it's the IDE selected the whole line
        {
            return selText
        }
    }
    Clipboard := ClipboardOld
    return
}
GetLine()
{
    selText := GetSelText()
    if not selText
    {
        ClipboardOld := ClipboardAll
        Clipboard := ""
        SendInput, +{Home}
        sleep, 10 ;make sure text is selecting
        Send, ^{Insert}
        ClipWait, 0.1
        selText := Clipboard
        Clipboard := ClipboardOld
        SendInput, {End}
    }
    return selText
}
GetLastWord()
{
    selText := GetLine()

    pos := InStr(selText, " ", , 0) + 1
    if (pos > 0)
    {
        word := SubStr(selText, pos)
    }
    else
    {
        word := selText
    }
    return word
}


ReadDigit() ;return a digit at success, return -1 at error
{
    ; avoid hyper block
    old_value := hyper
    hyper := 0
    Input, UserInput, T3*,,1,2,3,4,5,6,7,8,9,0 
    hyper := old_value 
    i := -1
    if StrEq(ErrorLevel, "Match")
    {
        i := SubStr(UserInput, 0)
        i := i+0
    }
    return i
}
SendWordReplace(CurrentWord,NewWord,CorrectCase = False)
{
    If CorrectCase
    {
        Position := 1
        CaseSense := A_StringCaseSense
        StringCaseSense, Locale
        Loop, Parse, CurrentWord
        {
            Position := InStr(NewWord,A_LoopField,False,Position) ;find next character in the current word if only subsequence matched
            If A_LoopField Is Upper
            {
                Char := SubStr(NewWord,Position,1)
                StringUpper, Char, Char
                NewWord := SubStr(NewWord,1,Position - 1) . Char . SubStr(NewWord,Position + 1)
            }
        }
        StringCaseSense, %CaseSense%
    }

    ;send the word
    ; is here a bug? may stuck the capslock
    Send, % "{BS " . StrLen(CurrentWord) . "}" ;clear the typed word
    Sleep, 100
    SendRaw, %NewWord%
}

;--------String/Array function
StringUpper(str)
{
    return Format("{:U}", str)
}
StringLower(str)
{
    return Format("{:L}", str)
}
TextWidth(String)
{
    static Typeface := "Courier New"
    static Size := 10
    static hDC, hFont := 0, Extent
    If !hFont
    {
        hDC := DllCall("GetDC","UPtr",0,"UPtr")
        Height := -DllCall("MulDiv","Int",Size,"Int",DllCall("GetDeviceCaps","UPtr",hDC,"Int",90),"Int",72)
        hFont := DllCall("CreateFont","Int",Height,"Int",0,"Int",0,"Int",0,"Int",400,"UInt",False,"UInt",False,"UInt",False,"UInt",0,"UInt",0,"UInt",0,"UInt",0,"UInt",0,"Str",Typeface)
        hOriginalFont := DllCall("SelectObject","UPtr",hDC,"UPtr",hFont,"UPtr")
        VarSetCapacity(Extent,8)
    }
    DllCall("GetTextExtentPoint32","UPtr",hDC,"Str",String,"Int",StrLen(String),"UPtr",&Extent)
    Return, NumGet(Extent,0,"UInt")
}
GetDateTime(fmt := "yyyy/M/d")
{
    FormatTime, CurrentDateTime,, %fmt%
    return CurrentDateTime
}

RegExFindAll(haystack, needle)
{
    result := []
    pos := 1
    while pos:=RegExMatch(haystack, needle, match, pos)
    {
        ;msgbox %pos% -> %match1%
        pos := pos + StrLen(match1)
        result.push(match1)
    }
    Return result
}
StrEq(str1, str2)
{
    return InStr(str1, str2) && InStr(str2, str1)
}
ToInt(s)
{
    return Format("{:i}", s)
}
ToHex(i)
{
    return Format("{:x}", i)
}
CountSubStr(haystack, needle)
{
    needle := Format("({})", needle)
    result := RegExFindAll(haystack, needle)
    num := result.count()
    return num
}
CountLines(content)
{
    return CountSubStr(content, "`n")
}

IsStrInArray(val, arr)
{
    for key, value in arr
    {
        ;msgbox %val%, %value%
        if StrEq(val, value)
        {
            return True
        }
    }
    return False
}

GetReverseArray(arr)
{
    rarr := []
    for index, value in arr
    {
        rarr.insertat(1, value)
    }
    return rarr
}
;-------http
HttpGet(url, headers := "", proxy := "", timeout := 500) ;proxy 127.0.0.1:1080
{
    try
    {
        whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", url, false)
        whr.SetTimeouts(0, timeout, timeout, timeout)
        If proxy
        {
            whr.SetProxy(2,proxy)
        }
        if (headers != "")
        {
            for key, value in headers
            {
                whr.SetRequestHeader(key, value)
            }
        }
        whr.Send()
        ; Using 'true' above and the call below allows the script to remain responsive.
        ; whr.WaitForResponse()
        return whr.ResponseText
    }
    catch e
    {
        
        return ""
    }
}
;----mouse/coor
MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}
CheckIfCaretNotDetectable()
{
   ;Grab the number of non-dummy monitors
   SysGet, NumMonitors, 80
   
   IfLess, NumMonitors, 1
      NumMonitors = 1
   
   if !(A_CaretX)
   {
      Return, 1
   }
   
   ;if the X caret position is equal to the leftmost border of the monitor +1, we can't detect the caret position.
   Loop, %NumMonitors%
   {
      SysGet, Mon, Monitor, %A_Index%
      if ( A_CaretX = ( MonLeft ) )
      {
         Return, 1
      }
      
   }
   
   Return, 0
}
;----hotkey util
HotKeyCounter(timeout := 500)
{
    static counter := 0
    SetTimer, reset, -%timeout%
    counter += 1
    return counter
    reset:
    counter := 0
    return
}

;----notification
ErrorMsg(e="", msg="")
{
    err_msg := "ERROR`n`n"
    if (msg)
    {
        err_msg .= "Function msg:`n" . msg . "`n`n"
    }
    if (e)
    {
        err_msg .= "Exception:`nwhat: " e.what "`nfile: " e.file
            . "`nline: " e.line "`nmessage: " e.message "`nextra: " e.extra
    }
    
    MsgBox, 16,, % err_msg
}


SuccessMsg(msg)
{
    if (HyperSettings.Notify.MsgLevel <= 1)
    {
        AddNotification(msg, "SUCCESS")
    } 
}
WarningMsg(msg)
{
    if (HyperSettings.Notify.MsgLevel <= 2)
    {
        AddNotification(msg, "WARNING", 6000)
    } 
}
InfoMsg(msg)
{
    if (HyperSettings.Notify.MsgLevel <= 1)
    {
        AddNotification(msg, "INFO")
    } 
}
DebugMsg(msg)
{
    if (HyperSettings.Notify.MsgLevel = 0)
    {
        AddNotification(msg, "DEBUG")
    }
}
AddNotification(msg, title:="", delay:=3000)
{
    if (not A_IsSuspended)
    {
        noti := {"msg":msg, "title":title, "delay":delay}
        HyperSettings.RunTime.Notifications.insertat(1, noti)
    }
}







