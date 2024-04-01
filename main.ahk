;@Ahk2Exe-AddResource *10 %A_ScriptDir%\html\index.html
;@Ahk2Exe-SetMainIcon iwck.ico
;@Ahk2Exe-SetName i wanna clean keyboard
;@Ahk2Exe-ExeName iwck
;@Ahk2Exe-SetDescription iwck

VNT := 0
#include *i setting.ahk

#Requires AutoHotkey v2.0
#NoTrayIcon
#MaxThreadsPerHotkey 1
#Include ./web_gui/Neutron.ahk

block := 0
InHook := InputHook("M L16")
if VNT == 1 {
	InHook.VisibleNonText := True
	title := "iwck*"
} else {
	InHook.VisibleNonText := False
	title := "iwck"
}
dpiScale := A_ScreenDPI / 96
winW := dpiScale * 350
winH := dpiScale * 247
if A_IsCompiled {
	path := "index.html"
} else {
	path := "./html/index.html"
}
neutron := NeutronWindow().Load(path)
	.Opt("-Resize")
	.OnEvent("Close", (neutron) => ExitApp())
	.Show("w" winW " h" winH, "iwck")

neutron.qs(".ver>span#ahk").innerHTML := "ahk" A_AhkVersion
neutron.qs(".ver>span#ahk").classList.add("hidden")
neutron.qs(".ver>span#iwck").innerHTML := version
neutron.qs("html").setAttribute("style", "font-size:" Round(A_ScreenDPI * 100 / 192) "px")
if VNT == 1 {
	neutron.qs("div#vnt").classList.remove("hidden")
}
return

Clicked(neutron, event) {
	; MsgBox "You clicked: " event.target.id
	global
	if StrCompare(event.target.id, "btn_block") == 0 {
		if (block != 1) {
			block := 1
			neutron.qs("button#btn_block").classList.remove("unlocked")
			neutron.qs("button#btn_block").classList.add("locked")
			neutron.qs(".circles").classList.remove("unlocked")
			neutron.qs(".circles").classList.add("locked")
			SetTimer blockKeyboard, -1
		} Else {
			block := 0
			neutron.qs("button#btn_block").classList.remove("locked")
			neutron.qs("button#btn_block").classList.add("unlocked")
			neutron.qs(".circles").classList.remove("locked")
			neutron.qs(".circles").classList.add("unlocked")
			InHook.Stop()
		}
	}
}

blockKeyboard() {
	global block, InHook
	loop {
		InHook.Start()
		InHook.Wait()
		if (!block) {
			Return
		}
	}
}

#HotIf block == 1
LWin:: Return
RWin:: Return
*CapsLock:: Return
PrintScreen:: Return
Sleep:: Return
; F1::Return
; F2::Return
; F3::Return
; F4::Return
; F5::Return
; F6::Return
; F7::Return
; F8::Return
; F9::Return
; F10::Return
; F11::Return
; F12::Return
; F13::Return
; F14::Return
; F15::Return
; F16::Return
; F17::Return
; F18::Return
; F19::Return
; F20::Return
; F21::Return
; F22::Return
; F23::Return
; F24::Return
#HotIf
