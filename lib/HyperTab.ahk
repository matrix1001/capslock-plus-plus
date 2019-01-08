#Include lib/BasicFunc.ahk
#Include lib/Json.ahk
#Include lib/Gui.ahk
HyperTab()
{
    clip_old := ClipboardAll
    Clipboard := ""
    Send, +{Home}
    Send, ^{Insert}
    ClipWait, 0.5
    line := Clipboard
    
    len := StrLen(line)
    ; tabstring
    for key, val in HyperSettings.Tab
    {
        pos := InStr(line, key,, 0) ; search from back
        if (pos != 0 && pos + StrLen(key) = len+1)
        {
            match := SubStr(line, pos)
            temp := EvalString(val)
            ;SendWordReplace(match, temp)

            newline := SubStr(line, 1, pos-1) . temp

            Clipboard := newline
            Send, +{Insert}
            Sleep, 50
            Send, {End}
            Clipboard := clip_old
            return
        }   
    }
    Send, {End}
    ; tabstring not found, turn to suggest
    Clipboard := clip_old
    last_word := GetLastWord(line)

    SuggestWord(last_word)
}

EvalString(str)
{
    func_array := RegExFindAll("S" . str . "E", "[^<]<([^<>]+)>[^>]")
    result := str
    for index, match in func_array
    {
        ;msgbox %index%:%match%
        replace := RunFunc(match)
        ;msgbox out func: %replace%
        result := StrReplace(result, "<" . match . ">" , replace)
    }
    ;msgbox %result%

    ; replace <<>> to <>
    result := StrReplace(result, "<<", "<")
    result := StrReplace(result, ">>", ">")
    return result
    
}

GoogleSuggest(query)
{
    url := Format("http://suggestqueries.google.com/complete/search?output=firefox&q={}", query)
    ;msgbox %url%
    header := {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36"}
    ;response := HttpGet(url, header, "127.0.0.1:1080")
    response := HttpGet(url, header)
    try
    {
        msgbox %response%
        json_obj := JSON.Load(response)
        ;msgbox % json_obj[1]

        return json_obj[2]
    }
    catch
    {
        return
    }

}
BaiduSuggest(query)
{
    url := Format("http://suggestion.baidu.com/su?wd={}", query)
    header := {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36"}
    response := HttpGet(url, header)
    try
    {
        ;msgbox %response%
        beg := InStr(response, "s:[")
        end := InStr(response, "]})", 0)

        if (beg && end)
        {
            json_text := SubStr(response, beg+2, end-beg-1)
            ;msgbox %json_text%

            json_obj := JSON.Load(json_text)
            return json_obj
        }
        
        return
    }
    catch
    {
        return
    }

}

SuggestWord(word, opt := "baidu", style := "suggest")
{
    if StrEq(opt, "baidu")
    {
        candidate := BaiduSuggest(word)
        ;msgbox test
    }
    else if StrEq(opt, "google")
    {
        candidate := GoogleSuggest(word)
    }
    
    if (candidate.count() = 0)
    {
        ;msgbox no candi
        return
    }
    SuggestGui("show", candidate, word)
    ;content := ""
    ;for index, value in candidate
    ;{
    ;    content .= value . "`n"
    ;}
    ;content := SubStr(content, 1, -1)
    ;;msgbox %content%
    ;OnCaretToolTip(content)

}