#requires AutoHotkey v2.0

WinWait("ahk_class AVL_AVDialog")
WinActivate("ahk_class AVL_AVDialog")
Sleep(1000)
Send("{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Enter}")
; ^ Click the "Continue" button
WinWait("ahk_class AVL_AVDialog")
WinActivate("ahk_class AVL_AVDialog")
Sleep(1000)
Send("{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Enter}")
; ^ Click the "Sign" button
Sleep(1000)
WinWait("ahk_class #32770")
WinActivate("ahk_class #32770")
; ^ Wait for the "Save as" dialog to appear (no proper window class)
; FIXME add, separated by a space, ahk_exe or another criterion
Send("{End}^{Left}signed.CL.{Enter}")
; ^ Specify file name
