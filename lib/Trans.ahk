#Include lib/BasicFunc.ahk
#Include lib/Json.ahk

GoogleTrans(content, src := "auto", dst := "zh")
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
        trans := json_obj.sentences[1].trans
        orig := json_obj.sentences[1].orig

        result := {"src":LANGUAGES[src], "dst":LANGUAGES[dst], "trans":trans, "orig":orig}
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
    result := GoogleTrans(content, HyperSettings.Trans.SourceLanguage, HyperSettings.Trans.TargetLanguage)
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
GoogleTransDoubleClick(toggle := 0)
{
    static en := 0
    if toggle=1
    {
        ;msgbox toggle
        if en=1
        {
            InfoMsg("Disable DoubleClick Translation")
            en := 0
        }
        else
        {
            InfoMsg("Enable DoubleClick Translation")
            en := 1
        }
        return
    }

    if en=1
    {
        GoogleTransSel()
    }
}