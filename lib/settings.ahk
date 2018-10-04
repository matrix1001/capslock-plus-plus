global HyperSettings := {"Keymap":{}, "TabHotString":{}, "UserWindow":{}}

#Include basickey.ahk
#Include basicfunc.ahk
#Include windowutil.ahk
#Include apps.ahk
#Include tab.ahk


; main 
InitSettings()
SetTimer, WatchSettings, 1000

; end



WatchSettings()
{
    WatchList := ["HyperSettings.ini", "HyperWinSettings.ini"]
    static LastModified := [0, 0]
    for index, filename in WatchList
    {
        if LastModified[index] := 0
        {
            FileGetTime, temp, %filename%
            LastModified[index] := temp
            Continue
        }
        FileGetTime, last, %filename%
        if (last != LastModified[index])
        {
            if (filename = "HyperSettings.ini")
            {
                ReadSettings()
            }
            if (filename = "HyperWinSettings.ini")
            {
                ReadWinSettings()
                MapUserWindowKey()
            }
        }
    }
}

InitSettings()
{
    ; main settings

    if FileExist("HyperSettings.ini")
    {
        ReadSettings()
    }
    else
    {
        MsgBox HyperSettings.ini not found, using default
        DefaultKeySettings()
        HyperSettings.TabHotString["sample"] := "this is a TabHotString sample"
        SaveSettings()
    }

    ; for window
    if FileExist("HyperWinSettings.ini")
    {
        ReadWinSettings()
        ;for key, value in HyperSettings.UserWindow
        ;{
        ;    msgbox %key%
        ;}`
    }
    else
    {
        MsgBox HyperWinSettings.ini not found, using default
        DefaultWinSettings()
        SaveWinSettings()
    }

    MapUserWindowKey()
}


; only functions

ReadWinSettings()
{
    IniRead, OutputVarSectionNames, HyperWinSettings.ini
    OutputVarSectionNames := StrSplit(OutputVarSectionNames, "`n")
    for index, appname in OutputVarSectionNames
    {
        IniRead, typ, HyperWinSettings.ini, %appname%, typ
        IniRead, key, HyperWinSettings.ini, %appname%, key
        IniRead, exe, HyperWinSettings.ini, %appname%, exe
        IniRead, id, HyperWinSettings.ini, %appname%, id
        ;msgbox %appname%, %typ%, %key%, %exe%, %id%
        HyperSettings.UserWindow[appname] := {"typ":typ
            ,"key":key
            ,"exe":exe
            ,"id":id}
    }
}
SaveWinSettings()
{
    for name, content in HyperSettings.UserWindow
    {
        for key, val in content
        {
            IniWrite, % val, HyperWinSettings.ini, %name%, % key
        }
    }
}
ReadSettings()
{
    IniRead, Keymap, HyperSettings.ini, Keymap
    Keymaps := StrSplit(Keymap, "`n")
    for index, line in Keymaps
    {
        pair := StrSplit(line, "=")
        keyname := pair[1]
        funcname := pair[2]
        AssignKeymap(keyname, funcname)
    }
}
SaveSettings()
{
    for key, val in HyperSettings.Keymap
    {
        IniWrite, % val, HyperSettings.ini, Keymap, % key
    }
    for key, val in HyperSettings.TabHotString
    {
        IniWrite, % val, HyperSettings.ini, TabHotString, % key
    }
}

AssignKeymap(key, func_name)
{
    old_val := HyperSettings.Keymap[key]
    if (old_val && old_val != func_name)
    {
        MsgBox Duplicate key: %key%`nold value: %old_val%`nnew value: %func_name%
    }
    ;msgbox %key%, %func_name%
    HyperSettings.Keymap[key] := func_name
}

MapUserWindowKey()
{
    for appname, value in HyperSettings.UserWindow
    {
        key := "hyper_" . value["key"]
        func_name := Format("Window{1}(""{2}"",""{3}"")", value["typ"], value["id"], value["exe"])
        ; msgbox %key%, %funcname%
        AssignKeymap(key, func_name)
    }
    ;test := HyperSettings.Keymap["hyper_a"]
    ;msgbox %test%
}
AddHotString(key, replace)
{
    HyperSettings.TabHotString[key] := replace
}

DefaultWinSettings()
{
    HyperSettings.UserWindow := {"Chrome":{"key":"a"
                                ,"typ":"B"
                                ,"id":"ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe"
                                ,"exe":"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"}

                            , "NotePad":{"key":"w"
                                ,"typ":"A"
                                ,"id":"ahk_class Notepad++"
                                ,"exe":"C:\Program Files\Notepad++\notepad++"}
                                
                            , "Qdir":{"key":"e"
                                ,"typ":"A"
                                ,"id":"ahk_class ATL:0000000140163FE0"
                                ,"exe":"D:\Tools\Q-Dir\Q-Dir_x64.exe"}

                            , "Msys2":{"key":"r"
                                ,"typ":"A"
                                ,"id":"ahk_class mintty"
                                ,"exe":"D:\Tools\msys2\msys2.exe"}

                            , "YoudaoNote":{"key":"q"
                                ,"typ":"A"
                                ,"id":"ahk_class NeteaseYoudaoYNoteMainWnd"
                                ,"exe":"C:\Program Files (x86)\Youdao\YoudaoNote\YoudaoNote.exe"}}
}
DefaultKeySettings()
{
    HyperSettings.Keymap.hyper_wheelup := "VolumeUp"
    HyperSettings.Keymap.hyper_wheeldown := "VolumeDown"

    HyperSettings.Keymap.hyper_up := "VolumeUp"
    HyperSettings.Keymap.hyper_down := "VolumeDown"
    HyperSettings.Keymap.hyper_left := "PrevDesktop"
    HyperSettings.Keymap.hyper_right := "NextDesktop"

    HyperSettings.Keymap.hyper_c := "UnixCopy"
    HyperSettings.Keymap.hyper_v := "UnixPaste"

    HyperSettings.Keymap.hyper_h := "MoveLeft"
    HyperSettings.Keymap.hyper_j := "MoveDown"
    HyperSettings.Keymap.hyper_k := "MoveUp"
    HyperSettings.Keymap.hyper_l := "MoveRight"

    HyperSettings.Keymap.hyper_i := "MoveHome"
    HyperSettings.Keymap.hyper_o := "MoveEnd"
    HyperSettings.Keymap.hyper_u := "PageUp"
    HyperSettings.Keymap.hyper_p := "PageDown"

    HyperSettings.Keymap.hyper_esc := "SuspendScript"
    HyperSettings.Keymap.hyper_backquote := "ToggleCapsLock"

    HyperSettings.Keymap.hyper_space := "WindowToggleOnTop"
    HyperSettings.Keymap.hyper_g := "WindowKill"

    HyperSettings.Keymap.hyper_1 := "WindowC(1)"
    HyperSettings.Keymap.hyper_2 := "WindowC(2)"
    HyperSettings.Keymap.hyper_3 := "WindowC(3)"
    HyperSettings.Keymap.hyper_4 := "WindowC(4)"
    HyperSettings.Keymap.hyper_5 := "WindowC(5)"
    HyperSettings.Keymap.hyper_minus := "WindowCClear"

    HyperSettings.Keymap.hyper_tab := "HyperTab"
}
