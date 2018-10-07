# CapsLock++
Original idea if from [capslock-plus](https://github.com/wo52616111/capslock-plus) and [Capslock](https://github.com/Vonng/Capslock). But it seems that `capslock-plus` is no longer maintained. And I feel painful to read its source code. So I plan to rewrite it. 
# Feature
- Function based script
- WindowSwitch
- Tabscript
- Autoload configuration and script
  
This project is in progress. Other fantastic funtions will be joined.
# Usage
## Basic
Basic usage is according to the default settings. If you are not starter of `AHK`, just ignore this. These settings are in `HyperSettings.ini`.

In the following part, I will ignore `capslock` in keyset.

| key | function |
| ------ | ------ |
| ` | toggle capslock|
| alt+1 | switch to virtual desktop 1 |
| alt+2 | switch to virtual desktop 2 |
| alt+3 | switch to virtual desktop 3 |
| h | move left |
| j | move down |
| k | move up |
| l | move right |
| u | page up |
| p | page down |
| i | move to start |
| o | move to end |
| c | copy |
| v | paste |
| ↑ | volumne up |
| ↓ | volumne down |
| ← | prev virtual desktop |
| → | next virtual desktop |
| space | toggle window always on top |
| 1,2,3,4,5 | window bind |
| tab | tab script |

By the way, you may want to `suspend` | `restart` the script when you play games. Press `Ctrl + Esc` will help. And its icon will change.


## WindowSwitch
WindowSwitch is designed for quick switch between multiple windows. Extremely good for those who need to work with multiple window applications.

I have implemented 2 types of window switch functions.

### Type 1
- `WindowA` can be used for most applications.
- `WindowB` should be used for `web browser`. There is little difference from `WindowA`

These two functions need to be configured before you use it.

Check default HyperWinSettings.ini
```ini
[Chrome]
exe=C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
id=ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
key=a
typ=B
```
Just put infomation of your application here, and assign a `key` to it, then you can use it by press `Capslock + key`.
`key` can also be `alt_a` if you want `Capslock + alt + a`.

About `id`, you can figure it out by using `windowspy`, which it installed by `autohotkey`.

After you finish configuration, it will be auto loaded. The manner of `Type 1` functions is:
- Start your application if not started
- Active your application window if not actived
- Minimize your application window if actived
  
### Type 2
- `WindowC` can dynamicly bind any window.

`Type 2` function does not require any configuration. But it need to be assigned to keymap.

Check Default HyperSettings.ini
```ini
[Keymap]
hyper_1=WindowC(1)
hyper_2=WindowC(2)
hyper_3=WindowC(3)
hyper_4=WindowC(4)
hyper_5=WindowC(5)
hyper_minus=WindowCClear
```
The manner is similar to `Type 1`:
- If no window bind, bind current window
- Active your application window if not actived
- Minimize your application window if actived

To clear a window bind, you got two ways.
- Close the binded window, press its binded key again
- Press `Casplock + -`, then its binded key

I only assign 5 `WindowC` by default. It supports at most 10 window. But I guess you will never use that much.
## TabScript
TabScript helps you to auto complete some long strings with simple words, triggerd by `CapsLock + Tab`.

Take a look at default HyperSetting.ini, you will find this
```ini
[TabHotString]
sample=this is a TabHotString sample
date1=<GetDateTime>
date2=<GetDateTime("yyyy-M-d")>
```
Move your cursor after the word `sample`, press `CapsLock + Tab`, and it will be auto replaced by `this is a TabHotString sample`

However, I have implemented function support.

In `lib/basicfunc.ahk`, you will find this function
```ahk
GetDateTime(fmt := "yyyy/M/d")
{
    FormatTime, CurrentDateTime,, %fmt%
    return CurrentDateTime
}
```

And just use function between `<>`, it will be automaticly evaluated. What if I need to use `<` or `>` instead of a function call? Use `<<`, `>>` instead. 

Example
```
[before] date1 -> [after] 2018/10/6
[before] date2 -> [after] 2018-10-6
```
Also multiple functions call is supported.

If you want to add your TabScript into it, just change HyperSettings.ini. If you need other function, check `UserScript` in `Usage`.



## UserScript
Now if want to put your script into `capslock++.ahk`, your have to follow these:
- All scripts should not use `global`. If your global variable is important, put them into `HyperSettings` (check `settings.ahk`). However, if you insist to use `global`, there is little chance to get you into trouble.
- All scripts are function based. Prevent the use of `label`.
- If some function can be reused by other script, put it into `basicfunc.ahk`. Also you can `#include lib/basicfunc.ahk` only.
- Leave one function as a entry for keymap.

Then:
- Just move your script into `lib` or `script`, it will be auto loaded.
- If your want to map a key to it, just change `HyperSettings.ini`, it will be auto loaded.

## Modification
Any modification of `ahk` script (scripts in `lib` and `script`, and `capslock++.ahk`) will trigger `Reload`. However there will be a message box to confirm.
# Documention
TODO

# Devlog
## 2018/10/7 version 0.1.3
- add some useful basic func, like `splashtext`, `streq`..
- refine includer to avoid some problem
- add more option like `icon`, `admin` in INI file
- add windowswitch usage to readme
## 2018/10/6 version 0.1.2
- add function support to tabscript
- add tabscript usage to readme
## 2018/10/5 version 0.1.1
- add desktoputil
- better autoloader and settingwatcher
- add startup support
- add some usage
## 2018/10/4 version 0.1.0
- init commit
- add auto includer (all ahk file will be auto include, so you don't need to write a `#Include`)
- add hot change support (autoload scripts and .ini)