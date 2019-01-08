#Include lib/BasicFunc.ahk
WindowA(window_class, exec)                                          
{                                                                   
    ;DetectHiddenWindows, on                                         
    IfWinNotExist %window_class%                                    
    {                                                               
        Run %exec%                                                  
        ;WinWait %window_class%                               
    }                                                               
    Else IfWinNotActive %window_class%                              
    {                                                               
        WinShow %window_class%                                      
        WinActivate %window_class%                                  
        ;WinWaitActive %window_class%                                
    }                                                               
    Else                                                            
    {                                                               
        WinMinimize                                                 
        ;WinWaitNotActive %window_class%                             
    }                                                                                                                        
}
WindowB(window_class, exec)                                       
{                                                                  
    ;DetectHiddenWindows, on                                        
    IfWinNotExist %window_class%                                   
    {                                                              
        Run %exec%                                                 
        ;WinWait %window_class%                                     
    }                                                              
    Else IfWinNotActive %window_class%                             
    {                                                              
        WinShow %window_class%                                     
        WinActivateBottom %window_class%                           
        ;WinWaitActive %window_class%                               
    }                                                              
    Else                                                           
    {                                                              
        WinMinimize                                                
        ;WinWaitNotActive %window_class%                            
    }                                                                                                                     
} 

WindowC(idx, opt:=1)                                                  
{ 
    static QuickWindows := { 1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0, 9:0, 0:0}
    if (opt = 0)
    {
        QuickWindows[idx] := 0
    }         
    else
    {            
        windowid := QuickWindows[idx]                                      
        if (windowid != 0)                                                   
        {                                                       
            IfWinNotExist, ahk_id %windowid%                           
            {                                                        
                SplashImage,,x0 y0 b fs12, Window Closed.            
                Sleep, 1500                                          
                SplashImage, Off                                     
                QuickWindows[idx] := 0                                            
            }                                                        
            IfWinActive, ahk_id %windowid%                             
            {                                                        
                WinMinimize                                          
            }                                                        
            else WinActivate ahk_id %windowid%                         
        }                                                            
        else 
        {
            ;ahk_class WorkerW
            ;ahk_exe Explorer.EXE
            ; avoid binding desktop
            WinGet, windowid, ID, A
            WinGet, windowexe, ProcessName, A
            WinGetClass, windowclass, A
            if StrEq(windowexe, "Explorer.EXE") && StrEq(windowclass, "WorkerW")
            {  
                WarningMsg(Format("Don't bind window {} to Desktop", idx))
            }
            else
            {
                QuickWindows[idx] := windowid
                InfoMsg(Format("Bind window {} to {}", idx, windowexe))
            }
        }   
    }                                                                                                
}  


WindowCClear()
{
    ; msgbox getinput
    ; must set hyper to 0 for those who need input
    
    UserInput := ReadDigit()
    if UserInput != -1 ;success
    {
        WindowC(UserInput, opt:=0)                                                
        InfoMsg(Format("QuickWindow {} cleared.", UserInput))    
    }
    ; msgbox get %UserInput%       
    else
    {
        InfoMsg(Format("QuickWindow clear failed, error: {}", ErrorLevel))
    }                    
                                                               
}

WindowKill()
{
    WinGet active_id, ID, A
    WinKill ahk_id %active_id%  
}
WindowToggleOnTop()
{
    WinGet, currentWindow, ID, A                                        
    WinGet, ExStyle, ExStyle, ahk_id %currentWindow%                    
    if (ExStyle & 0x8)  ; 0x8 is WS_EX_TOPMOST.                         
    {                                                                   
        Winset, AlwaysOnTop, off, ahk_id %currentWindow%                
        InfoMsg("Window always on top OFF.")                                                   
    }                                                                   
    else                                                                
    {                                                                   
        WinSet, AlwaysOnTop, on, ahk_id %currentWindow%                 
        InfoMsg("Window always on top ON.")                                                            
    }   
}