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

;--------system function
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
GetSelText()
{
    ClipboardOld:=ClipboardAll
    Clipboard:=""
    SendInput, ^{insert}
    ClipWait, 0.1
    if(!ErrorLevel)
    {
        selText:=Clipboard
        Clipboard:=ClipboardOld
        StringRight, lastChar, selText, 1
        if(Asc(lastChar)!=10) ;如果最后一个字符是换行符，就认为是在IDE那复制了整行，不要这个结果
        {
            return selText
        }
    }
    Clipboard:=ClipboardOld
    return
}

;--------IO function
ReadDigit()
{
    ; avoid hyper block
    old_value := hyper
    hyper := 0
    Input, UserInput,,,1,2,3,4,5,6,7,8,9,0     
    hyper := old_value
    return UserInput
}
;--------msg
SplashText(msg, width := 400, height := 200, delay := 3000)
{
    
    SplashTextOn, %width%, %height%, Capslock++, %msg%
    WinGetPos,,, Width, Height, Capslock++
    WinMove, Capslock++, , (A_ScreenWidth)-(Width)-20, (A_ScreenHeight)-(Height)-40
    SetTimer, splashoff, -%delay%
    return
    splashoff:
    SplashTextOff
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
;--------String function
StringUpper(str)
{
    return Format("{:U}", str)
}
StringLower(str)
{
    return Format("{:L}", str)
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
        ; msgbox %pos% -> %match1%
        pos := pos + StrLen(match1)
        result.push(match1)
    }
    Return result
}
StrEq(str1, str2)
{
    return InStr(str1, str2) && InStr(str2, str1)
}

;-------http
HttpGet(url, headers := "")
{
    try
    {
        whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", url, false)
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
        MsgBox, 16,, % "Exception thrown!`n`nwhat: " e.what "`nfile: " e.file
            . "`nline: " e.line "`nmessage: " e.message "`nextra: " e.extra
        return ""
    }
}
