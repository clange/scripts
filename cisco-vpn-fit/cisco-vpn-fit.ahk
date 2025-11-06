#requires AutoHotkey v2.0

network := "Fraunhofer FIT"

Run "C:\Program Files (x86)\Cisco\Cisco Secure Client\UI\csc_ui.exe"
WinWait("ahk_exe csc_ui.exe")
WinActivate
If(ControlGetText("ComboBox1") != network) {
        ControlChooseString(network, "ComboBox1")
}
if (ControlGetText("Button1") = "Connect") {
        ControlClick("Button1")
}
; PIN entry is requested here
WinWait("Cisco Secure Client | " network " ahk_exe csc_ui.exe ahk_class #32770")
WinActivate
ControlChooseString("Smartcard (Split-Tunnel)", "ComboBox1")
if (ControlGetText("Button1") = "OK") {
        ControlClick("Button1")
}        