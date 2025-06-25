#requires AutoHotkey v2.0
; 
; adobe-digital-sign: perform a digital signature in a PDF document in Adobe Reader
;
; Usage: to be invoked from adobe-digital-sign-click.ahk or adobe-digital-sign-draw.ahk, which initiates the signing
; 
; © Christoph Lange <math.semantic.web@gmail.com> 2025

WinWait("ahk_class AVL_AVDialog")
WinActivate
Sleep(2000)
Send("{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Enter}")
; ^ Click the "Continue" button
WinWait("ahk_class AVL_AVDialog")
WinActivate
Sleep(2000)
Send("{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Enter}")
; ^ Click the "Sign" button
Sleep(2000)
WinWait("ahk_exe AcroRd32.exe ahk_class #32770")
WinActivate
; ^ Wait for the "Save as" dialog to appear (no proper window class)
Send("{End}^{Left}signed.CL.{Enter}")
; ^ Specify file name
