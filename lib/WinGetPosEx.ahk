;------------------------------------------------------------------------------
;
; Function: WinGetPosEx
;
; Description:
;
;   Gets the position, size, and offset of a window. See the *Remarks* section
;   for more information.
;
; Parameters:
;
;   hWindow - Handle to the window.
;
;   X, Y, Width, Height - Output variables. [Optional]
;       If defined, these variables contain the coordinates of the window
;       relative to the upper-left corner of the screen (X and Y), and the
;       Width and Height of the window.
;
;   Offset_X, Offset_Y - Output variables. [Optional]
;       [Vista++]
;           Offset, in pixels, of the actual position of the window versus the
;           position of the window as reported by GetWindowRect.  If moving the
;           window to specific coordinates, add these offset values to the
;           appropriate coordinate (X and/or Y) to reflect the true size of the
;           window.
;       [XP]
;           The offset values take on a different meaning for XP users and
;           basically give the user the values for how many pixels of a window
;           are considered the transparent "pink" region.  The user can than
;           uses these offsets however they want in their functions.
;
; Returns:

;   If successful, the address of a RECTPlus structure is returned.  The first
;   16 bytes contains a RECT structure that contains the dimensions of the
;   bounding rectangle of the specified window.  The dimensions are given in
;   screen coordinates that are relative to the upper-left corner of the
;   screen. The next 8 bytes contain of X and Y offsets (4-byte integer for
;   X and 4-byte integer for Y).
;
;   Also if successful (and if defined), the output variables (X, Y, Width,
;   Height, Offset_X, and Offset_Y) are updated.  See the *Parameters* section
;   for more more information.
;
;   If not successful, FALSE is returned.
;
; Requirement:
;
;   Windows 2000+
;
; Remarks:
;
; * Starting with Windows Vista, Microsoft includes the Desktop Window Manager
;   (DWM) along with Aero-based themes that use DWM.  Aero themes provide new
;   features like a translucent glass design with subtle window animations.
;   Unfortunately, DWM doesn't always conform to the OS rules for size and
;   positioning of windows. If using an Aero theme, many of the windows are
;   actually larger than reported by Windows when using standard commands (Ex:
;   WinGetPos, GetWindowRect, etc.) and because of that, are not positioned
;   correctly when using standard commands (Ex: gui Show, WinMove, etc.)
;
;   This function was created to 1) identify the true position and size of all
;   windows regardless of the window attributes, desktop theme, or version of
;   Windows and to 2) identify the appropriate offset that is needed to
;   position the window if the window is a different size than reported.
;
; * The true size, position, and offset of a window cannot be determined until
;   the window has been rendered.  See the example script for an example of how
;   to use this function to position a new window.
;
; Credit:
;
;   Idea and some code from *KaFu* (AutoIt forum)
;
;------------------------------------------------------------------------------
WinGetPosEx(
    hWindow,
    ByRef X="",
    ByRef Y="",
    ByRef Width="",
    ByRef Height="",
    ByRef Offset_X="",
    ByRef Offset_Y="") {

    Static Dummy5693
        , RECTPlus
        , S_OK := 0x0
        , DWMWA_EXTENDED_FRAME_BOUNDS := 9

    ; Workaround for AutoHotkey Basic
    PtrType := (A_PtrSize = 8) ? "Ptr" : "UInt"

    ; Get the window's dimensions
    ;   Note: Only the first 16 bytes of the RECTPlus structure are used by the
    ;   DwmGetWindowAttribute and the GetWindowRect functions.
    VarSetCapacity(RECTPlus,24,0)
    DWMRC := DllCall("dwmapi\DwmGetWindowAttribute"
        , PtrType, hWindow                                  ; hwnd
        , "UInt",  DWMWA_EXTENDED_FRAME_BOUNDS              ; dwAttribute
        , PtrType, &RECTPlus                                ; pvAttribute
        , "UInt",  16)                                      ; cbAttribute

    if (DWMRC <> S_OK) {
        if (ErrorLevel in -3, -4) { ;-- Dll or function not found (older than Vista)
            VarSetCapacity(RECT, 16, 0)
            DllCall("GetWindowRgnBox", PtrType, hWindow, PtrType, &RECT)
            DllCall("GetWindowRect",   PtrType, hWindow, PtrType, &RECTPlus)
        } else {
            OutputDebug,
            (ltrim join`s
                 Function: %A_ThisFunc% -
                 Unknown error calling the "dwmapi\DwmGetWindowAttribute"
                 function. RC = %DWMRC%,
                 ErrorLevel = %ErrorLevel%,
                 A_LastError = %A_LastError%
            )

            Return False
        }
    }

    ; Populate the output variables
    Left     := NumGet(RECTPlus, 0,  "Int")
    Top      := NumGet(RECTPlus, 4,  "Int")
    Right    := NumGet(RECTPlus, 8,  "Int")
    Bottom   := NumGet(RECTPlus, 12, "Int")
    X        := Left
    Y        := Top
    Width    := Right - Left
    Height   := Bottom - Top
    OffSet_X := NumGet(RECT,     0,  "Int")
    OffSet_Y := NumGet(RECT,     4,  "Int")

    ; If DWM is not used (older than Vista), we're done
    if (DWMRC <> S_OK) {
        ; Calculate offsets and update output variables
        NumPut(Offset_X, RECTPlus, 16, "Int")
        NumPut(Offset_Y, RECTPlus, 20, "Int")

        Return &RECTPlus
    }
    ; Collect dimensions via GetWindowRect
    VarSetCapacity(RECT, 16, 0)
    DllCall("GetWindowRect", PtrType, hWindow, PtrType, &RECT)

    ; Width = Right - Left
    GWR_Width  := NumGet(RECT, 8,  "Int") - NumGet(RECT, 0, "Int")

    ; Height = Bottom - Top
    GWR_Height := NumGet(RECT, 12, "Int") - NumGet(RECT, 4, "Int")

    ; Calculate offsets and update output variables
    NumPut(Offset_X := (Width - GWR_Width)   // 2, RECTPlus, 16, "Int")
    NumPut(Offset_Y := (Height - GWR_Height) // 2, RECTPlus, 20, "Int")

    Return &RECTPlus
}