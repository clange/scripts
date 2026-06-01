#requires AutoHotkey v2.0
; 
; personalformular: automates the filling of HR form fields
;
; Usage: run this with AutoHotkey
; 
; © Christoph Lange <math.semantic.web@gmail.com> 2026

Institutsnummer := "3140"
Institutskürzel := "FIT"
Personalnummer := "10013705"
Vorname := "Christoph"
Nachname := "Lange-Bever"

WinActivate("ahk_class AcrobatSDIWindow")
SendText(Institutsnummer)
Send("{Tab}")
SendText(Institutskürzel)
Send("{Tab}")
SendText(Personalnummer)
Send("{Tab}")
SendText(Vorname)
Send("{Tab}")
SendText(Nachname)