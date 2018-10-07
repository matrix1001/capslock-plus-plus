#Include lib/BasicFunc.ahk
AppWox(){
    selText:=GetSelText()

    sendinput, !{Space}
    winwait, ahk_exe Wox.exe, , 0.5

    if(selText){
        selText:="g " . selText
        sendinput, %selText%{home}{right}
    }
}
AppListary(){
    selText:=GetSelText()

    sendinput, !{Space}
    winwait, ahk_exe Listary.exe, , 0.5

    if(selText){
        selText:="g " . selText
        sendinput, %selText%{home}{right}
    }
}