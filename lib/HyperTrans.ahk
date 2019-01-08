#Include lib/BasicFunc.ahk
#Include lib/Json.ahk


Translate(content, backend := "google", src := "auto", dst := "zh")
{
    if StrEq(backend, "google")
        return GoogleTranslate(content, src, dst)
    if StrEq(backend, "cgdict")
        return CgdictTranslate(content)
}
TransSel()
{
    content := GetSelText()
    msg := Translate(content, HyperSettings.Trans.TransSelBackend, HyperSettings.Trans.SourceLanguage, HyperSettings.Trans.TargetLanguage)
    OnMouseToolTip(msg)
}

TransDoubleClick(toggle := 0)
{
    if toggle=1
    {
        ;msgbox toggle
        if HyperSettings.RunTime.DoubleClickTrans = 1
        {
            InfoMsg("Disable DoubleClick Translation")
            HyperSettings.RunTime.DoubleClickTrans := 0
        }
        else
        {
            InfoMsg("Enable DoubleClick Translation")
            HyperSettings.RunTime.DoubleClickTrans := 1
        }
        return
    }

    if HyperSettings.RunTime.DoubleClickTrans = 1
    {
        content := GetSelText()
        msg := Translate(content, HyperSettings.Trans.TransDoubleClickBackend, HyperSettings.Trans.SourceLanguage, HyperSettings.Trans.TargetLanguage)
        OnMouseToolTip(msg)
    }
}
GoogleTranslate(content, src := "auto", dst := "zh")
{
    local LANGUAGES = {"af": "afrikaans"
    ,"sq": "albanian"
    ,"am": "amharic"
    ,"ar": "arabic"
    ,"hy": "armenian"
    ,"az": "azerbaijani"
    ,"eu": "basque"
    ,"be": "belarusian"
    ,"bn": "bengali"
    ,"bs": "bosnian"
    ,"bg": "bulgarian"
    ,"ca": "catalan"
    ,"ceb": "cebuano"
    ,"ny": "chichewa"
    ,"zh": "chinese"
    ,"zh-cn": "chinese (simplified)"
    ,"zh-tw": "chinese (traditional)"
    ,"co": "corsican"
    ,"hr": "croatian"
    ,"cs": "czech"
    ,"da": "danish"
    ,"nl": "dutch"
    ,"en": "english"
    ,"eo": "esperanto"
    ,"et": "estonian"
    ,"tl": "filipino"
    ,"fi": "finnish"
    ,"fr": "french"
    ,"fy": "frisian"
    ,"gl": "galician"
    ,"ka": "georgian"
    ,"de": "german"
    ,"el": "greek"
    ,"gu": "gujarati"
    ,"ht": "haitian creole"
    ,"ha": "hausa"
    ,"haw": "hawaiian"
    ,"iw": "hebrew"
    ,"hi": "hindi"
    ,"hmn": "hmong"
    ,"hu": "hungarian"
    ,"is": "icelandic"
    ,"ig": "igbo"
    ,"id": "indonesian"
    ,"ga": "irish"
    ,"it": "italian"
    ,"ja": "japanese"
    ,"jw": "javanese"
    ,"kn": "kannada"
    ,"kk": "kazakh"
    ,"km": "khmer"
    ,"ko": "korean"
    ,"ku": "kurdish (kurmanji)"
    ,"ky": "kyrgyz"
    ,"lo": "lao"
    ,"la": "latin"
    ,"lv": "latvian"
    ,"lt": "lithuanian"
    ,"lb": "luxembourgish"
    ,"mk": "macedonian"
    ,"mg": "malagasy"
    ,"ms": "malay"
    ,"ml": "malayalam"
    ,"mt": "maltese"
    ,"mi": "maori"
    ,"mr": "marathi"
    ,"mn": "mongolian"
    ,"my": "myanmar (burmese)"
    ,"ne": "nepali"
    ,"no": "norwegian"
    ,"ps": "pashto"
    ,"fa": "persian"
    ,"pl": "polish"
    ,"pt": "portuguese"
    ,"pa": "punjabi"
    ,"ro": "romanian"
    ,"ru": "russian"
    ,"sm": "samoan"
    ,"gd": "scots gaelic"
    ,"sr": "serbian"
    ,"st": "sesotho"
    ,"sn": "shona"
    ,"sd": "sindhi"
    ,"si": "sinhala"
    ,"sk": "slovak"
    ,"sl": "slovenian"
    ,"so": "somali"
    ,"es": "spanish"
    ,"su": "sundanese"
    ,"sw": "swahili"
    ,"sv": "swedish"
    ,"tg": "tajik"
    ,"ta": "tamil"
    ,"te": "telugu"
    ,"th": "thai"
    ,"tr": "turkish"
    ,"uk": "ukrainian"
    ,"ur": "urdu"
    ,"uz": "uzbek"
    ,"vi": "vietnamese"
    ,"cy": "welsh"
    ,"xh": "xhosa"
    ,"yi": "yiddish"
    ,"yo": "yoruba"
    ,"zu": "zulu"
    ,"fil": "Filipino"
    ,"he": "Hebrew"}

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
        trans := ""
        orig := ""
        origs := []
        for value, sentence in json_obj.sentences
        {
            trans .= sentence.trans . "`n"
            if not IsStrInArray(sentence.orig, origs)
            {
                origs.push(sentence.orig)
                orig .= sentence.orig . " "
            }
            
        }
        ;trans := json_obj.sentences[1].trans
        ;orig := json_obj.sentences[1].orig

        result := {"src":LANGUAGES[src], "dst":LANGUAGES[dst], "trans":trans, "orig":orig}
        msg := Format("{1}->{2}`n{3}", result.src, result.dst, result.trans)
        return msg
    }
    catch
    {
        ;SplashText("ERROR: GoogleTrans Failed. `nurl: " . url)
        return "error"
    }

}
CgdictTranslate(word)
{
    url := Format("http://www.cgdict.com/index.php?app=cigen&ac=word&w={}", word)
    header := {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36"}
    response := HttpGet(url, header)
    pattern := "<p><strong>([^<]*)<\/strong>([^<]*)\s?<\/p>"
    result := []
    pos := 1
    while pos:=RegExMatch(response, pattern, match, pos)
    {
        pos := pos + StrLen(match1)
        result.push(Format("{} {}", match1, match2))
    }
    txt := ""
    for idx, par in result
        txt .= par
    return txt
}