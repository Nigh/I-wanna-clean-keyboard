#Requires AutoHotkey v2.0
#NoTrayIcon
#MaxThreadsPerHotkey 1
#include *i compile_prop.ahk
#Include ./webview2/WebViewToo.ahk
;@Ahk2Exe-AddResource *10 %A_ScriptDir%\html\index.html
;@Ahk2Exe-AddResource *10 %A_ScriptDir%\webview2\64bit\WebView2Loader.dll, 64bit\WebView2Loader.dll

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
	path := A_ScriptDir "\html\index.html"
}
WebViewSettings := {}
if A_IsCompiled {
	WebViewCtrl.CreateFileFromResource("64bit\WebView2Loader.dll", WebViewCtrl.TempDir)
	WebViewSettings := { DllPath: WebViewCtrl.TempDir "\64bit\WebView2Loader.dll" }
}

wvGui := WebViewGui("-Caption -Resize", title, , WebViewSettings)
wvGui.OnEvent("Close", (*) => ExitProc())
wvGui.AddCallbackToScript("Clicked", Clicked)
wvGui.IsParentWindowDraggingEnabled := true
wvGui.NavigationCompleted((*) => InitUi())
wvGui.Navigate(path)
wvGui.Show("w" winW " h" winH)
return

InitUi(*) {
	global version
	jsSetAttr("html", "style", "font-size:" Round(A_ScreenDPI * 100 / 192) "px")
	jsSetHtml(".ver>span#ahk", "ahk" A_AhkVersion)
	jsAddClass(".ver>span#ahk", "hidden")
	jsSetHtml(".ver>span#iwck", "v" version)
}

js(script) {
	global wvGui
	try wvGui.ExecuteScriptAsync(script)
}

jsStr(value) {
	value := StrReplace(value, "\", "\\")
	value := StrReplace(value, '"', '\"')
	value := StrReplace(value, "`r", "\r")
	value := StrReplace(value, "`n", "\n")
	return '"' value '"'
}

jsSetHtml(selector, value) {
	js("document.querySelector(" jsStr(selector) ").innerHTML = " jsStr(value) ";")
}

jsSetAttr(selector, name, value) {
	js("document.querySelector(" jsStr(selector) ").setAttribute(" jsStr(name) ", " jsStr(value) ");")
}

jsAddClass(selector, cls) {
	js("document.querySelector(" jsStr(selector) ").classList.add(" jsStr(cls) ");")
}

jsRemoveClass(selector, cls) {
	js("document.querySelector(" jsStr(selector) ").classList.remove(" jsStr(cls) ");")
}

bgClass(c) {
	switch c {
		case "locked":
			jsRemoveClass(".circles", "unlocked")
			jsAddClass(".circles", "locked")
		case "unlocked":
			jsRemoveClass(".circles", "locked")
			jsAddClass(".circles", "unlocked")
	}
}
btnClass(id, cls) {
	switch cls {
		case "locked":
			jsRemoveClass("button#" id, "unlocked")
			jsAddClass("button#" id, "locked")
		case "unlocked":
			jsRemoveClass("button#" id, "locked")
			jsAddClass("button#" id, "unlocked")
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
			jsRemoveClass("div.mouse-icon", "hidden")
			jsAddClass("div.press-esc", "hidden")
		case "kbd":
			btnClass(btn_ids[1], "locked")
			btnClass(btn_ids[2], "unlocked")
			bgClass("locked")
			jsRemoveClass("div.mouse-icon", "hidden")
			jsAddClass("div.press-esc", "hidden")
		case "mouseready":
			btnClass(btn_ids[1], "unlocked")
			btnClass(btn_ids[2], "unlocked")
			bgClass("unlocked")
			jsAddClass("div.mouse-icon", "hidden")
			jsRemoveClass("div.press-esc", "hidden")
		case "mouse":
			btnClass(btn_ids[2], "locked")
			btnClass(btn_ids[1], "unlocked")
			bgClass("locked")
			jsRemoveClass("div.mouse-icon", "hidden")
			jsAddClass("div.press-esc", "hidden")
	}
}

Clicked(webview, id) {
	; MsgBox "You clicked: " id
	global
	switch id {
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
