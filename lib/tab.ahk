#Include basicfunc.ahk
HyperTab()
{
    TabHotString := HyperSettings.TabHotString
    static regexHotString := ""
    if not regexHotString
    {
        regexHotString:="iS)("
        for key,value in TabHotString
        {
            regexHotString.="\Q" . key . "\E" . "|"
        }
        regexHotString.=")$"
    }

    ClipboardOld:=ClipboardAll
    selText:=GetSelText()
    
    if (selText)
    {
        Clipboard := selText
    }
    else
    {
        Clipboard := ""
        SendInput, +{Home}
        sleep, 10 ;make sure text is selecting
        UnixCopy()
        ClipWait, 0.1

        ;msgbox % Clipboard
    }

    matchKey:=""
    RegExMatch(Clipboard, regexHotString, matchKey)
    if (matchKey)
    {
        if (TabHotString[matchKey])
        {
            temp:=RegExReplace(Clipboard, "\Q" . matchKey . "\E$", TabHotString[matchKey])
            StringReplace, temp, temp, \n, `n, All ;替换换行符
            StringReplace, temp, temp, \`n, \n, All ;有转义符的换回来
            Clipboard:=temp
            UnixPaste()
            Sleep, 200
        }
    }
    else
    {
        SendInput, {End}
    }
    Clipboard:=ClipboardOld
    return calResult
}

