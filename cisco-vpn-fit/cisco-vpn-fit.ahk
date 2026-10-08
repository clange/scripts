#requires AutoHotkey v2.0
#SingleInstance Ignore

network := "Fraunhofer FIT"

Run "C:\Program Files (x86)\Cisco\Cisco Secure Client\UI\csc_ui.exe"
mainWindow := "ahk_id " WinWait("ahk_exe csc_ui.exe")
WinActivate(mainWindow)
If(ControlGetText("ComboBox1", mainWindow) != network) {
        ControlChooseString(network, "ComboBox1", mainWindow)
}
if (ControlGetText("Button1", mainWindow) = "Connect") {
        ControlClick("Button1", mainWindow)
}
; PIN entry is requested at this point
tunnel := "Smartcard (Split-Tunnel)"
; Cisco may request the group again after smartcard authentication.
; Allow two minutes for PIN entry before giving up on an optional second prompt.
loop 2 {
        selector := WaitForTunnelSelector("ahk_exe csc_ui.exe", tunnel, A_Index = 1 ? 60000 : 120000)
        if !selector {
                if A_Index = 1
                        MsgBox("Could not find the Cisco tunnel selection for " tunnel " within 60 seconds.")
                break
        }
        ConfirmTunnelSelection(selector)
        ; Do not submit the same prompt repeatedly while Cisco processes OK.
        if !WinWaitClose("ahk_id " selector.window,, 10) {
                MsgBox("Cisco did not close the tunnel selection after confirmation.")
                break
        }
}

ConfirmTunnelSelection(selector) {
        dialog := "ahk_id " selector.window
        try {
                WinActivate(dialog)
                ; Changing an already selected group can trigger redundant Cisco events.
                if ControlGetIndex(selector.control, dialog) != selector.index
                        ControlChooseIndex(selector.index, selector.control, dialog)
                ; The OK button's control number and accelerator marker can vary.
                for control in WinGetControls(dialog) {
                        if RegExMatch(control, "^Button\d+$") && StrReplace(ControlGetText(control, dialog), "&") = "OK" {
                                ControlClick(control, dialog)
                                return
                        }
                }
                throw Error("Could not find the Cisco tunnel selection's OK button.")
        } catch TargetError as err {
                ; Cisco may dismiss the dialog in response to the selection itself.
                if WinExist(dialog)
                        throw err
        }
}

WaitForTunnelSelector(winTitle, tunnel, timeoutMs := 60000) {
        deadline := A_TickCount + timeoutMs
        loop {
                ; Match the option itself: Cisco dialog titles and window classes vary.
                for window in WinGetList(winTitle) {
                        try {
                                dialog := "ahk_id " window
                                for control in WinGetControls(dialog) {
                                        if !RegExMatch(control, "^ComboBox\d+$")
                                                continue
                                        if !ControlGetVisible(control, dialog) || !ControlGetEnabled(control, dialog)
                                                continue
                                        for index, item in ControlGetItems(control, dialog) {
                                                if item = tunnel
                                                        return {window: window, control: control, index: index}
                                        }
                                }
                        } catch Error {
                                ; A window/control may disappear while Cisco changes dialogs.
                        }
                }
                if A_TickCount >= deadline
                        return false
                Sleep(100)
        }
}
