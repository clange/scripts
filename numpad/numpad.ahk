#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"

; --- Home-row Numpad mappings ---

; u i o -> Numpad7 8 9
u::Send "{Numpad7}"
i::Send "{Numpad8}"
o::Send "{Numpad9}"

; j k l -> Numpad4 5 6
j::Send "{Numpad4}"
k::Send "{Numpad5}"
l::Send "{Numpad6}"

; m , . -> Numpad1 2 3
m::Send "{Numpad1}"
,::Send "{Numpad2}"
.::Send "{Numpad3}"

; Space -> Numpad0
Space::Send "{Numpad0}"

; 8 9 0 -> Numpad =, /, *
; NOTE: NumpadEqual may not exist / may not work on all layouts.
; If {NumpadEqual} doesn't work for you, consider sending "=" literally: Send "="
8::Send "="
9::Send "{NumpadDiv}"
0::Send "{NumpadMult}"

; p ; / -> Numpad -, +, Enter
p::Send "{NumpadSub}"
`;::Send "{NumpadAdd}"      ; semicolon needs escaping in AHK hotkey labels
/::Send "{NumpadEnter}"

; n -> Numpad .
n::Send "{NumpadDot}"

; x -> Exit this script
x::ExitApp
