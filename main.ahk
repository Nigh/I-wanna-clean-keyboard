#Requires AutoHotkey v2.0
#NoTrayIcon
#MaxThreadsPerHotkey 1
#include *i compile_prop.ahk
#Include ./web_gui/Neutron.ahk
;@Ahk2Exe-AddResource *10 %A_ScriptDir%\html\index.html

#include *i setting.ahk
#include meta.ahk

#HotIf !A_IsCompiled
F6::Reload()
#HotIf

WH_KEYBOARD_LL := 13
WH_MOUSE_LL    := 14
WM_KEYDOWN     := 0x0100
WM_SYSKEYDOWN  := 0x0104
global hHookKbd := 0, hHookMouse := 0
global mode := "" ; "kbd" or "mouse"

title := "iwck"

btn_ids := ["btn_kbd", "btn_mouse", "btn_exit"]

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
	.OnEvent("Close", (neutron) => ExitProc())
	.Show("w" winW " h" winH, "iwck")

neutron.qs(".ver>span#ahk").innerHTML := "ahk" A_AhkVersion
neutron.qs(".ver>span#ahk").classList.add("hidden")
ver := "v" version
neutron.qs(".ver>span#iwck").innerHTML := ver
neutron.qs("html").setAttribute("style", "font-size:" Round(A_ScreenDPI * 100 / 192) "px")
return


bgClass(c) {
	switch c {
		case "locked":
			neutron.qs(".circles").classList.remove("unlocked")
			neutron.qs(".circles").classList.add("locked")
		case "unlocked":
			neutron.qs(".circles").classList.remove("locked")
			neutron.qs(".circles").classList.add("unlocked")
	}
}
btnClass(id, cls) {
	switch cls {
		case "locked":
			neutron.qs("button#" id).classList.remove("unlocked")
			neutron.qs("button#" id).classList.add("locked")
		case "unlocked":
			neutron.qs("button#" id).classList.remove("locked")
			neutron.qs("button#" id).classList.add("unlocked")
	}
}

ExitProc() {
	if(mode!="") {
		Unhook(mode)
	}
	ExitApp()
}

uiMode(m) {
	switch(m) {
		case "":
			for id in btn_ids {
				btnClass(id, "unlocked")
			}
			bgClass("unlocked")
			neutron.qs("div.mouse-icon").classList.remove("hidden")
			neutron.qs("div.press-esc").classList.add("hidden")
		case "kbd":
			btnClass(btn_ids[1], "locked")
			btnClass(btn_ids[2], "unlocked")
			bgClass("locked")
			neutron.qs("div.mouse-icon").classList.remove("hidden")
			neutron.qs("div.press-esc").classList.add("hidden")
		case "mouseready":
			btnClass(btn_ids[1], "unlocked")
			btnClass(btn_ids[2], "unlocked")
			bgClass("unlocked")
			neutron.qs("div.mouse-icon").classList.add("hidden")
			neutron.qs("div.press-esc").classList.remove("hidden")
		case "mouse":
			btnClass(btn_ids[2], "locked")
			btnClass(btn_ids[1], "unlocked")
			bgClass("locked")
			neutron.qs("div.mouse-icon").classList.remove("hidden")
			neutron.qs("div.press-esc").classList.add("hidden")
	}
}

Clicked(neutron, event) {
	; MsgBox "You clicked: " event.target.id
	global
	switch event.target.id {
		case "btn_kbd":
			if(mode=="" || mode=="mouse" || mode=="mouseready") {
				if(mode=="mouse") {
					Unhook("mouse")
				}
				StartBlock("kbd")
				mode := "kbd"
			} Else {
				Unhook("kbd")
				mode := ""
			}
			uiMode(mode)
		case "btn_mouse":
			switch(mode) {
				case "":
					mode:="mouseready"
				case "kbd":
					Unhook("kbd")
					mode:="mouseready"
				case "mouseready":
					mode:=""
			}
			uiMode(mode)
		case "btn_exit":
			ExitProc()
	}
	if(mode=="mouseready") {
		Hotkey("Esc", EscOnMouseReady, "On")
	} else {
		Hotkey("Esc", (*)=>{}, "Off")
	}
}

EscOnMouseReady(*) {
	global mode := "mouse"
	
	StartBlock("mouse")
	uiMode(mode)
	Hotkey("Esc", EscOnMouseLock, "On")
}
EscOnMouseLock(*) {
	global mode := ""
	
	Unhook("mouse")
	uiMode(mode)
}

StartBlock(which){
    global mode, hHookKbd, hHookMouse
    if (which = "kbd" && !hHookKbd){
        mode := "kbd"
        hHookKbd := SetWindowsHookEx(WH_KEYBOARD_LL, KeyboardProc)
        if !hHookKbd { 
			MsgBox "键盘钩子安装失败", "错误" 
		}
    } else if (which = "mouse" && !hHookMouse){
        mode := "mouse"
        hHookMouse := SetWindowsHookEx(WH_MOUSE_LL, MouseProc)
        if !hHookMouse { 
			MsgBox "鼠标钩子安装失败", "错误" 
		}
    }
}

Unhook(which){
    global hHookKbd, hHookMouse, mode
    if (which="kbd" && hHookKbd){
        UnhookWindowsHookEx(hHookKbd)
        hHookKbd := 0, mode := ""
    } else if (which="mouse" && hHookMouse){
        UnhookWindowsHookEx(hHookMouse)
        hHookMouse := 0, mode := ""
    }
}

KeyboardProc(nCode, wParam, lParam){
    global
    if (nCode >= 0){
        return 1
    }
    return CallNextHookEx(0, nCode, wParam, lParam)
}

MouseProc(nCode, wParam, lParam){
    global
    if (nCode >= 0){
        return 1
    }
    return CallNextHookEx(0, nCode, wParam, lParam)
}

SetWindowsHookEx(idHook, callback){
    cb := CallbackCreate(callback, "Fast")
    hMod := DllCall("GetModuleHandle","Ptr",0,"Ptr")
    return DllCall("SetWindowsHookExW"
        ,"Int",idHook
        ,"Ptr",cb
        ,"Ptr",hMod
        ,"UInt",0
        ,"Ptr")
}

UnhookWindowsHookEx(hHook){
    return DllCall("UnhookWindowsHookEx","Ptr",hHook)
}

CallNextHookEx(hHook, nCode, wParam, lParam){
    return DllCall("CallNextHookEx","Ptr",hHook,"Int",nCode,"UInt",wParam,"Ptr",lParam)
}
