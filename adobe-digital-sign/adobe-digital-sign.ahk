#requires AutoHotkey v2.0
; 
; adobe-digital-sign: perform a digital signature in a PDF document in Adobe Reader
;
; Usage: to be invoked from adobe-digital-sign-click.ahk or adobe-digital-sign-draw.ahk, which initiates the signing
; 
; Prerequisite: in Preferences / Signatures / Creation and Appearance, uncheck "Use modern user interface for signing and Digital ID configuration"
; 
; © Christoph Lange <math.semantic.web@gmail.com> 2025

issuer := "Fraunhofer User CA"
; Adapt this to your desired certificate issuer, or adapt the matching of the Static2 / "Issued by:" label below.

WinWait("Sign Document ahk_exe AcroRd32.exe ahk_class #32770")
WinActivate
Sleep(500)

items := ControlGetItems("ComboBox1")
limit := items.Length - 2
; ^ The last two entries are not signatures.
i := 1
for item in items {
        if (i > limit)
                break
        ControlChooseIndex(i, "ComboBox1")
        Sleep(200)
        if (InStr(ControlGetText("Static2"), "Issued by: " issuer, , 1)) {
                ; ^ Make sure the signature has the right issuer; if so, continue with the first signature of that issuer
                ; It would be better to match the whole item text, but Adobe Reader somehow cripples it to the first four characters. 
                ControlClick("&Sign")
                ; ^ Click the "Sign" button
                break
        }
        i++
}
Sleep(1000)
WinWait("ahk_exe AcroRd32.exe ahk_class #32770")
WinActivate
; ^ Wait for the "Save as" dialog to appear (no proper window class)
Send("{End}^{Left}signed.CL.{Enter}")
; ^ Specify file name
