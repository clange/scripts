#requires AutoHotkey v2.0

Run "C:\Program Files (x86)\Cisco\Cisco Secure Client\UI\csc_ui.exe"
WinWait("ahk_exe csc_ui.exe")
Send("{Tab}{Tab}{Tab}{Space}")
; TODO click buttons in next dialog as well