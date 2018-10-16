#Include lib/BasicFunc.ahk
#If HyperSettings.RunTime.AutoComplete = 1
#If

AutoComplete(opt := "")
{
    static MaxResults := 20, CurrentWord := "", ShowLength := 4, MatchList := "", CorrectCase := True, init := 0

    if (init = 0)
    {
        NormalKeyList := "a`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl`nm`nn`no`np`nq`nr`ns`nt`nu`nv`nw`nx`ny`nz" ;list of key names separated by `n that make up words in upper and lower case variants
        NumberKeyList := "1`n2`n3`n4`n5`n6`n7`n8`n9`n0" ;list of key names separated by `n that make up words as well as their numpad equivalents
        OtherKeyList := "'`n-" ;list of key names separated by `n that make up words

        Hotkey, If, HyperSettings.RunTime.AutoComplete = 1
        Hotkey, ~BackSpace, Back, UseErrorLevel
        Loop, Parse, NormalKeyList, `n
        {
            Hotkey, ~%A_LoopField%, Key, UseErrorLevel
            Hotkey, ~+%A_LoopField%, ShiftedKey, UseErrorLevel
        }

        Loop, Parse, NumberKeyList, `n
        {
            Hotkey, ~%A_LoopField%, Key, UseErrorLevel
            Hotkey, ~Numpad%A_LoopField%, NumpadKey, UseErrorLevel
        }

        Loop, Parse, OtherKeyList, `n
            Hotkey, ~%A_LoopField%, Key, UseErrorLevel


        Hotkey, If
        
        init := 1
    }


    if StrEq(opt, "toggle")
    {
        if (HyperSettings.RunTime.AutoComplete = 1)
        {
            HyperSettings.RunTime.AutoComplete := 0
            CurrentWord := ""
        }
        else
        {
            HyperSettings.RunTime.AutoComplete := 1
        }
    }
    else if StrEq(opt, "on")
    {
        HyperSettings.RunTime.AutoComplete := 1
    }
    else if StrEq(opt, "off")
    {
        HyperSettings.RunTime.AutoComplete := 0
        CurrentWord := ""
    }

    return

    showup:
    SplashTextOn, , , %CurrentWord% 

    ;check word length against minimum length
    If StrLen(CurrentWord) < ShowLength
    {
        Return
    }

    MatchList := SuggestWords(CurrentWord)

    ;check for a lack of matches
    If (MatchList.count() = 0)
    {
        Return
    }

    ;limit the number of results
    While (MatchList.count() > MaxResults)
        MatchList.pop()
    SuggestGui("show", MatchList, CurrentWord)
    Return


    Back:
    CurrentWord := SubStr(CurrentWord,1,-1)
    gosub showup
    Return

    Key:
    CurrentWord .= SubStr(A_ThisHotkey,1)
    ;msgbox %CurrentWord%
    gosub showup
    Return

    ShiftedKey:
    Char := SubStr(A_ThisHotkey,3)
    StringUpper, Char, Char
    CurrentWord .= Char
    gosub showup
    return

    NumpadKey:
    CurrentWord .= SubStr(A_ThisHotkey,8)
    gosub showup
    return

    ResetWord:
    CurrentWord := ""
    return
}

SuggestGui(opt := "", val := "", val2 := "")
{
    static CorrectCase := True, BoxHeight := 165, CurrentWord := ""
    static ListBoxHwnd, init := 0, DisplayList := "", MaxWidth := 0, hWindow := 0

    ;splashtexton,,, %opt%
    if (init = 0)
    {
        Gui, Suggestions:Font, s10, Courier New
        Gui, Suggestions:+Delimiter`n
        Gui, Suggestions:Add, ListBox, x0 y0 h%BoxHeight% 0x100 gCompleteWord AltSubmit +HwndListBoxHwnd
        Gui, Suggestions:-Caption +ToolWindow +AlwaysOnTop +LastFound
        Gui, Suggestions:Show, h%BoxHeight% Hide, AutoComplete

        NormalKeyList := "a`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl`nm`nn`no`np`nq`nr`ns`nt`nu`nv`nw`nx`ny`nz" ;list of key names separated by `n that make up words in upper and lower case variants
        NumberKeyList := "1`n2`n3`n4`n5`n6`n7`n8`n9`n0" ;list of key names separated by `n that make up words as well as their numpad equivalents
        OtherKeyList := "'`n-" ;list of key names separated by `n that make up words

        TriggerKeyList := "Tab`nEnter" ;list of key names separated by `n that trigger completion
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
        Gui, Suggestions:Hide
        SetTimer, SuggestGuiWatcher, off
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

    Gui, Suggestions:Hide
    SetTimer, SuggestGuiWatcher, off
    ;retrieve the word that was selected
    GuiControlGet, Index,, %ListBoxHwnd%

    GuiControl, -AltSubmit, %ListBoxHwnd%
    GuiControlGet, NewWord, , %ListBoxHwnd%
    GuiControl, +AltSubmit, %ListBoxHwnd%

    SendWord(CurrentWord,NewWord,CorrectCase)
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
    If (window != hWindow)
    {
        Gui, Suggestions:Hide
        SetTimer, SuggestGuiWatcher, off
    }
    return
}


SuggestWords(CurrentWord)
{
    static MaxResults := 20, WordList := ""
    if (WordList = "")
    {
        FileRead, WordList, %A_ScriptDir%\WordList.txt
        If InStr(WordList,"`r")
            StringReplace, WordList, WordList, `r,, All
        While, InStr(WordList,"`n`n") ;remove blank lines within the list
            StringReplace, WordList, WordList, `n`n, `n, All
        WordList := StrSplit(WordList, "`n")
    }

    WordList := ["test1aaa", "test2bbb"]
    return WordList
}




SendWord(CurrentWord,NewWord,CorrectCase = False)
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
    Send, % "{BS " . StrLen(CurrentWord) . "}" ;clear the typed word
    SendRaw, %NewWord%
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

