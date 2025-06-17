#requires AutoHotkey v2.0

WinActivate("ahk_class AcrobatSDIWindow")
Send("^fDigitally Sign")
Sleep(2000)
Send("{Down}{Enter}")
; ^ Then, let the user draw the rectangle for the signature
#include adobe-digital-sign.ahk
