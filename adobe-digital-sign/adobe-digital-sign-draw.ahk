#requires AutoHotkey v2.0
; 
; adobe-digital-sign-draw: draw a digital signature into a PDF document in Adobe Reader
;
; Usage: run this with AutoHotkey
; 
; © Christoph Lange <math.semantic.web@gmail.com> 2025

WinActivate("ahk_class AcrobatSDIWindow")
Send("^fDigitally Sign")
Sleep(2000)
Send("{Down}{Enter}")
; ^ Then, let the user draw the rectangle for the signature
#include adobe-digital-sign.ahk
