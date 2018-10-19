# CapsLock++

这个文档用于描述一些基本用法，如果你是开发者，请参考英文文档。对应版本0.2.2。

[最新发行版V0.2.2](https://github.com/matrix1001/capslock-plus-plus/archive/V0.2.2.zip)

__最新功能__

- 智能搜索
- 智能建议

# 特色

- 开箱即用
- 自动翻译
- 窗口快速切换
- 智能补全
- 好看的UI
- 易于修改的配置文件

这个项目仍然在开发中，遇到任何问题请issue，描述清楚问题或者想法，最好能附带截图。另外，此文档可能不会实时更新，最新功能请参考以英文文档。

# 更新

更新后，请把原有的`HyperSettings.ini`和`HyperWinSettings.ini`删除（备份自己的设置），然后重启`Capslock++`，否则新功能可能不会加载进去。

# 使用指南

## 基础

主要描述默认的键位绑定，这些键位都在配置文件`HyperSettings.ini`，你可以随时修改或者解除绑定。

以下省略`Capslock`键。

| 按键 | 功能 | 备注 |
| ------ | ------ | ----- |
| ` | 大小写开关 |
| alt+1 | 切换到虚拟桌面1（win10） | 
| alt+2 | 切换到虚拟桌面2（win10） | 需要首先创建虚拟桌面
| alt+3 | 切换到虚拟桌面3（win10） |
| h | 左 |
| j | 下 |
| k | 上 |
| l | 右 |
| u | 向上翻页 |
| p | 向下翻页 |
| i | 移动到句首 |
| o | 移动到句末 |
| c | 复制 |
| v | 粘贴 |
| ↑ | 音量加 |
| ↓ | 音量减 |
| ← | 前一个虚拟桌面 |
| → | 后一个虚拟桌面 |
| space | 窗口前置 |
| 1,2,3,4,5 | 窗口绑定/激活/最小化 |
| tab | 智能补全 |
| s | 智能搜索 |
| t | 谷歌翻译（无墙） |
| alt+s | 重载配置 |
| alt+r | 重载脚本 |
| alt+t | 开启左键双击翻译 |

另外，如果想要临时暂停或者激活脚本，请按 `Alt + Esc` 。图标会有所变化，便于你观察。

这里是 `HyperSettings.ini` 的一些基本配置

```ini
[Basic]
Admin=0 ;管理员权限
DebugMsg=0 ;调试信息，你可以自己看看
ScriptMonitor=1 ;脚本监控
SettingMonitor=1 ;配置文件监控
StartUp=1 ;开机启动
```

## 翻译

翻译请按 `Capslock + t`。但首先要选中需要翻译的内容。

以下是几个测试用例。

```
hola
Olá
 مرحبا 
```

以下是效果。

![demo1](img/trans1.png)
![demo2](img/trans2.png)
![demo3](img/trans3.png)

目前支持左键双击翻译了，需要先`Capslock + alt + t`开启，不用时关闭即可。

## 窗口快速切换

窗口快速切换适合经常在电脑上同时使用多种软件的人。

我总体设计了两种类型。

### 类型一

- `WindowA` 适用于大多数窗口应用
- `WindowB` 适用于浏览器等多标签应用

这两个功能都需要在 `HyperWinSettings.ini` 里面提前配置好。配置模板已给出。

```ini
[Chrome]
exe=C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
id=ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
key=a
typ=B
```

只需要填一些基本信息，然后绑定一个 `key`，用 `Capslock + key`即可触发。
`key` 也可以是 `alt_a` 如果你想用 `Capslock + alt + a`。

关于 `id`，请用`autohotkey`自带的 `windowspy`，来观察。

完成配置后重新加载配置，默认`Capslock + Alt + s`，即可。以下是按键功能。

- 若未启动程序，则启动
- 若窗口未激活，则激活
- 若窗口激活，则最小化
  
### 类型二

- `WindowC` 支持实时绑定窗口

无需提前配置，实时动态绑定。

默认键位绑定在`HyperSettings.ini`。即`Capslock + 1,2,3,4,5`。

```ini
[Keymap]
hyper_1=WindowC(1)
hyper_2=WindowC(2)
hyper_3=WindowC(3)
hyper_4=WindowC(4)
hyper_5=WindowC(5)
hyper_minus=WindowCClear
```

其按键功能和之前一类相似。

- 若未绑定，则绑定当前窗口
- 若窗口未激活，则激活
- 若窗口激活，则最小化

有两种方法取消绑定

- 关闭窗口，再次按对于绑定键
- 按 `Casplock + -`，接着按对应数字

注：数字键不是小键盘的。

## 智能补全

智能补全由`CapsLock + Tab`触发。

`HyperSetting.ini`里面有示例，自行添加后重载配置即可。

```ini
[TabHotString]
sample=this is a TabHotString sample
date1=<GetDateTime>
date2=<GetDateTime("yyyy-M-d")>
```

找个地方输入`sample`，按 `CapsLock + Tab`，即可自动替换为 `this is a TabHotString sample`

这个功能实现了函数支持。

在 `lib/basicfunc.ahk`里面，有这样一个函数。

```ahk
GetDateTime(fmt := "yyyy/M/d")
{
    FormatTime, CurrentDateTime,, %fmt%
    return CurrentDateTime
}
```

将默认配置的两个日期补全，会有如下结果。

```
[before] date1 -> [after] 2018/10/6
[before] date2 -> [after] 2018-10-6
```

调用函数用 `<>`即可，如果需要使用 `<` 或 `>`，请用 `<<`， `>>` ，它们会被替换回来。 

最新更新的智能建议也是用这个键触发，参考下图。

![tabsample1](img/tab1.png)

使用`tab`或者`enter`进行补全，使用`up`，`down`或`capslock+k`，`capslock+j`进行选择，你也可以只用鼠标点击。

## 消息提示UI

![noti1](img/notify1.png)

![noti2](img/notify2.png)

![noti3](img/notify3.png)

默认出现`INFO`，`SUCCESS`，`WARNING`这三类消息，配置如下。

```ini
[Notify]
Enable=1
MsgLevel=1
Style=slide
Max=5
```

将`MsgLevel`改成`0`将出现`DEBUG`信息，方便调试用，改成`2`只允许`WARNING`出现。此外`Style`还可以是`fade`，及淡入淡出。

## 智能搜索

智能搜索由`Capslock + s`触发，首先你得选中你想要搜索的东西。目前可以做到自动打开网页、程序，自动搜单词等。开发者请看`HyperSearch.ahk`，代码很短。普通用户有想法请`issue`。