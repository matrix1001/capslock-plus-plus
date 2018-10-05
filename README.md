# CapsLock++
Original idea if from [capslock-plus](https://github.com/wo52616111/capslock-plus) and [Capslock](https://github.com/Vonng/Capslock). But it seems that `capslock-plus` is no longer maintained. And I feel painful to read its source code. So I plan to rewrite it (Some codes are directly copied from `capslock-plus`. 
# Feature
- Function based script. Easy to understand for most AHK user. (Try to have a look at `capslock-plus` and you will know why)
- Quick window swift & quick desktop swift
- Tabscript (something like auto replace)
- Easy configuration & auto reload configuration & auto reload all scripts if there is any change
# Usage
## HyperSettings.ini
In this section, I will show you how to do with HyperSettings.ini

Default Settings:
```ini
[Keymap] ;map key to functions
;hyper is CapsLock

; heres window bind, select a window, press CapsLock + 1, 
; then press again and again, you will know.
hyper_1=WindowC(1)
hyper_2=WindowC(2)
hyper_3=WindowC(3)
hyper_4=WindowC(4)
hyper_5=WindowC(5)
; heres virtual desktop swift. you need to create in your windows before you use
; pay attention to ALT, press CapsLock before ALT
; example : Press CapsLock then Alt then 1
hyper_alt_1=switchDesktopByNumber(1)
hyper_alt_2=switchDesktopByNumber(2)
hyper_alt_3=switchDesktopByNumber(3)
; CapsLock + `(the one on the top of Tab)
hyper_backquote=ToggleCapsLock
; as its name
; UnixCopy and UnixPaste use Shift/Ctrl+Insert,
; they work well and will not send Ctrl+C to interrupt some task
hyper_c=UnixCopy
hyper_down=VolumeDown
hyper_g=WindowKill
hyper_h=MoveLeft
hyper_i=MoveHome
hyper_j=MoveDown
hyper_k=MoveUp
hyper_l=MoveRight
hyper_left=PrevDesktop
hyper_minus=WindowCClear
hyper_o=MoveEnd
hyper_p=PageDown
hyper_right=NextDesktop
hyper_space=WindowToggleOnTop
; CapsLock + Tab is the TabHotString feature
hyper_tab=HyperTab
hyper_u=PageUp
hyper_up=VolumeUp
hyper_v=UnixPaste
hyper_wheeldown=VolumeDown
hyper_wheelup=VolumeUp
[TabHotString]
; move your cursor after word `sample` , 
; press CapsLock + Tab, it will be replaces
sample=this is a TabHotString sample
[Basic]
Debug=0
; Start at startup of your system
StartUp=1

```
You can find all those names (`MoveRight` for example) in `script` and `lib` dir. All of them are actually functions. What if I want to change those settings? Just change it and save it. `capslock++` will auto reload your settings.
## HyperWinSettings.ini
I give you my setting as a template
```ini
[Chrome] ;just a name
;you have to assign `exe` `id` `key` `typ`
exe=C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
;you can figure out `id` with `window spy`(ahk has it)
id=ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
;it means CapsLock + a , also you can use `alt_a`
;press CapsLock + a, chrome will start automaticly, 
;press again, it will minimize
;then press again, it will show up
key=a
;this `typ` is `A` or `B`, web browser should use `B`, others `A` will suit.
typ=B
[NotePad]
exe=C:\Program Files\Notepad++\notepad++
id=ahk_class Notepad++
key=w
typ=A
```
So many keys, what if there is a conflict ? Don't worry, my script will give you a message box to warn you.
## UserScript
Now if want to put your script into `capslock++.ahk`, your have to follow these:
- All scripts should not use `global`. If your global variable is important, put them into `HyperSettings` (check `settings.ahk`). However, if you insist to use `global`, there is little change to get you into trouble.
- All scripts are function based. Prevent the use of `label`.
- If some function can be reused by other script, put it into `basicfunc.ahk`. Also you can `#include lib/basicfunc.ahk` only.
- Leave one function as a entry for keymap.

Then:
- Just move your script into `lib` or `script`, it will be auto loaded.
- If your want to map a key to it, just change `HyperSettings.ini`, it will be auto loaded.

## Modification
Any modification of `ahk` script (scripts in `lib` and `script` and `capslock++.ahk`) will trigger `Reload`. However there will be a message box to confirm.
# Documention
TODO

# Devlog
2018/10/5 version 0.1.1
- add desktoputil
- better autoloader and settingwatcher
- add startup support
- add some usage
2018/10/4 version 0.1.0
- init commit
- add auto includer (all ahk file will be auto include, so you don't need to write a `#Include`)
- add hot change support (autoload scripts and .ini)