ToggleCapsLock()
{
    GetKeyState, CapsLockState, CapsLock, T                              
    if CapsLockState = D                                                 
        SetCapsLockState, AlwaysOff                                      
    else                                                                 
        SetCapsLockState, AlwaysOn                                       
    KeyWait, ``                                                          
    return     
}
ExitScript()
{
    ExitApp
}
MoveUp()
{
    Send, {Up}
}
MoveDown()
{
    Send, {Down}
}
MoveLeft()
{
    Send, {Left}
}
MoveRight()
{
    Send, {Right}
}
MoveHome()
{
    Send, {Home}
}
MoveEnd()
{
    Send, {End}
}
PageUp()
{
    Send, {PgUp}
}
PageDown()
{
    Send, {PgDn}
}
UnixCopy()
{
    Send, ^{Insert}
}
UnixPaste()
{
    Send, +{Insert}
}
NextDesktop()
{
    Send, #^{Right}
}
PrevDesktop()
{
    Send, #^{Left}
}
VolumeUp()
{
    Send, {Volume_Up}
}
VolumeDown()
{
    Send, {Volume_Down}
}

SuspendScript()
{
    Suspend
}