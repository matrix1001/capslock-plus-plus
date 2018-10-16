#Include lib/BasicFunc.ahk
#Include lib/HyperTrans.ahk
;lst := ["www.google.com"
;    ,"http://www.baidu.com"
;    ,"https://git.io"
;    ,"c:\"
;    ,"d:\file.txt"
;    ,"e:\test"
;    ,"word"
;    ,"this is a sentence"
;    ,"Hello, it's a good day today!`n it is 3:40pm, i got 2.5$ "
;    ,"12345"
;    ,""
;    ,"0x1234"]
;for index, value in lst
;{
;    result := CheckStrType(value)
;    msgbox %value% ->%result%
;}

HyperSearch()
{
    sel := GetSelText()
    typ := CheckStrType(sel)
    if (StrEq(typ, "file") || StrEq(typ, "folder"))
    {
        if FileExist(sel)
            Run %sel%
        else
            WarningMsg("File " . sel . " not exist")
    }
        
    if StrEq(typ, "web")
        Run %sel%
    if (StrEq(typ, "word") || StrEq(typ, "sentence"))
    {
        GoogleTransToolTip(sel)
    }
        
}

CheckStrType(str)
{

    if (RegExMatch(str,"iS)^[a-z]:\\.+\..+$"))
        return "file"
    if (RegExMatch(str,"iS)^[a-z]:\\[^.]*$"))
        return "folder"
    
    if (RegExMatch(str,"iS)^((https?:\/\/)|www\.)([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?|(https?:\/\/)?([\da-z\.-]+)\.(com|net|org)(\W[\/\w \.-]*)*\/?$"))
        return "web"
    if (RegExMatch(str, "i)^ftp://"))
        return "ftp"

    if (RegExMatch(str, "i)^\d+$"))
        return "number"
    if (RegExMatch(str, "i)^0x\d+"))
        return "hex"
    if (RegExMatch(str, "i)^\w+$"))
        return "word"
    else if (RegExMatch(str, "i)^[\w\.,?!'\$:\s]*$"))
        return "sentence"
    
    return "unknown"
}
