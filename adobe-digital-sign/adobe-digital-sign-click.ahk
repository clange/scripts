#requires AutoHotkey v2.0

WinActivate("ahk_class AcrobatSDIWindow")
Click
WinWait("ahk_class AVL_AVDialog")
WinActivate("ahk_class AVL_AVDialog")
Sleep(1000)
Send("{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Enter}")
; ^ Click the "Continue" button
Sleep(1000)
Send("{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Enter}")
; ^ Click the "Sign" button
Sleep(2000)
; ^ Wait for the "Save as" dialog to appear (no proper window class)
Send("{End}^{Left}signed.CL.{Enter}")
; ^ Specify file name

