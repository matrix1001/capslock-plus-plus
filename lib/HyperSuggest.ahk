#Include lib/BasicFunc.ahk
#Include lib/Json.ahk

;lst := BaiduSuggest("tes")
;for index, val in lst
;{
;    msgbox %val%
;}
;return

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
