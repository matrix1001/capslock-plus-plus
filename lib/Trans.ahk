#Include lib/BasicFunc.ahk
#Include lib/Json.ahk
GoogleTrans(content, src := "auto", dst := "zh")
{
    url := Format("http://translate.google.cn/translate_a/single?client=gtx&dt=t&dj=1&ie=UTF-8&sl={1}&tl={2}&q={3}"
        , src
        , dst
        , content)
    ;msgbox %url%
    header := {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36"}
    response := HttpGet(url, header)
    try
    {
        ;msgbox %response%
        json_obj := JSON.Load(response)
        src := json_obj.src
        trans := json_obj.sentences[1].trans
        orig := json_obj.sentences[1].orig

        result := {"src":src, "dst":dst, "trans":trans, "orig":orig}
        return result
    }
    catch
    {
        ;SplashText("ERROR: GoogleTrans Failed. `nurl: " . url)
        return
    }

}
GoogleTransSel()
{
    content := GetSelText()
    result := GoogleTrans(content)
    if result
    {
        msg := Format("{1}->{2}`n{3}", result.src, result.dst, result.trans)
    }
    else
    {
        msg := "error"
    }
    OnMouseToolTip(msg)

}