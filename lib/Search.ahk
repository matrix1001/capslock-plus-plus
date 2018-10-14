CheckStrType(str, fuzzy:=0)
{
    if(!FileExist(str))
    {
        ;  msgbox, % str
        if(RegExMatch(str,"iS)^((https?:\/\/)|www\.)([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?|(https?:\/\/)?([\da-z\.-]+)\.(com|net|org)(\W[\/\w \.-]*)*\/?$"))
            return "web"
    }
    if(RegExMatch(str, "i)^ftp://"))
        return "ftp"
    else
    {
        if(fuzzy)
            return "fileOrFolder"
        if(RegExMatch(str,"iS)^[a-z]:\\.+\..+$"))
            return "file"
        if(RegExMatch(str,"iS)^[a-z]:\\[^.]*$"))
            return "folder"
    }
    return "unknown"
}