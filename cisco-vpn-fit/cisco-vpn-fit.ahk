#requires AutoHotkey v2.0

Run "C:\Program Files (x86)\Cisco\Cisco Secure Client\UI\csc_ui.exe"
WinWait("ahk_exe csc_ui.exe")
WinActivate("ahk_exe csc_ui.exe")
Send("{Tab}{Tab}{Tab}{Space}")
; PIN entry is requested here
WinWait("ahk_exe csc_ui.exe ahk_class #32770")
WinActivate("ahk_exe csc_ui.exe ahk_class #32770")
Send("{Tab}{Space}")