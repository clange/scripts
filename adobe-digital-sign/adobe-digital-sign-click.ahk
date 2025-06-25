#requires AutoHotkey v2.0
; 
; adobe-digital-sign-click: create a digital signature in a PDF document in Adobe Reader, by clicking on a prepared signature field
;
; Usage: run this with AutoHotkey
; 
; © Christoph Lange <math.semantic.web@gmail.com> 2025

WinActivate("ahk_class AcrobatSDIWindow")
Click
#include adobe-digital-sign.ahk
