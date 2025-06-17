#requires AutoHotkey v2.0

WinWait("ahk_class AVL_AVDialog")
WinActivate("ahk_class AVL_AVDialog")
Sleep(2000)
Send("{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Enter}")
; ^ Click the "Continue" button
WinWait("ahk_class AVL_AVDialog")
WinActivate("ahk_class AVL_AVDialog")
Sleep(2000)
Send("{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Enter}")
; ^ Click the "Sign" button
Sleep(2000)
WinWait("ahk_exe AcroRd32.exe ahk_class #32770")
WinActivate("ahk_exe AcroRd32.exe ahk_class #32770")
; ^ Wait for the "Save as" dialog to appear (no proper window class)
Send("{End}^{Left}signed.CL.{Enter}")
; ^ Specify file name
