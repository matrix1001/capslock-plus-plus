ToggleCapsLock()
{
    GetKeyState, CapsLockState, CapsLock, T                              
    if CapsLockState = D                                                 
        SetCapsLockState, AlwaysOff                                      
    else                                                                 
        SetCapsLockState, AlwaysOn                                       
    KeyWait, ``                                                          
    return     
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

RunFunc(str){
    if(!RegExMatch(Trim(str), "\)$"))
    {
        %str%()
        return
    }
    if(RegExMatch(str, "(\w+)\((.*)\)$", match))
    {
        func:=Func(match1)
        
        if(!match2)
        {
            func.()
            return
        }

        params:={}
        loop, Parse, match2, CSV
        {
            params.insert(A_LoopField)
        }

        parmasLen:=params.MaxIndex()
        
        func.(params*)
    }
}
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