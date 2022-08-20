
; !!! NOTICE: works only on AHK 2.0 alpha
; tested on: Version 2.0-a108

#include Gdip_All.ahk
#NoTrayIcon
#MaxThreadsPerHotkey 1

blockExKey:=Array()
blockExKey.Push("LShift")
blockExKey.Push("RShift")
blockExKey.Push("LWin")
blockExKey.Push("RWin")
blockExKey.Push("CapsLock")
blockExKey.Push("PrintScreen")
blockExKey.Push("Sleep")

block:=0
ui_gap:=23
ui:=Object()
ui.size:={w:350,h:237}
ui.title:={}
ui.title.pos:={x:ui_gap,y:ui_gap}
ui.title.size:={w:ui.size.w-2*ui.title.pos.x,h:51}
ui.button1:={}
ui.button1.pos:={x:ui.title.pos.x,y:ui.title.pos.y+ui.title.size.h+ui_gap}
ui.button1.size:={w:(ui.size.w-3*ui_gap)//2,h:86}
ui.button2:={}
ui.button2.pos:={x:ui.size.w-ui.button1.size.w-ui.button1.pos.x,y:ui.button1.pos.y}
ui.button2.size:={w:ui.button1.size.w,h:ui.button1.size.h}
ui.by:={}
ui.by.size:={w:ui.title.size.w,h:21}
ui.by.pos:={x:ui.title.pos.x,y:ui.size.h-ui.by.size.h-ui_gap}
hBitmap:=Object()
If(!pToken := Gdip_Startup())
{
	ExitApp -1
}

ui.hatch:=50
ui.bgcolor:=0xff2c2c2c
ui.fgcolor:=0xff323232
OnExit("ExitFunc")
mgui:=GuiCreate("-Caption -AlwaysOnTop -Owner -DPIScale","iwck")
mgui.BackColor := "1c1c1c"
OnMessage(0x200, "WM_MOUSEMOVE")
;~ --------------------------------------------------bg
gui_bg:=mgui.Add("Pic","x0 y0 w1 h1 0xe")
;~ --------------------------------------------------title
gui_title:=mgui.Add("Pic","x" ui.title.pos.x " y" ui.title.pos.y " w" ui.title.size.w " h" ui.title.size.h " 0xe vtitle")
gui_title.OnEvent("Click", (*)=>titleMove())
;~ --------------------------------------------------button
gui_button1:=mgui.Add("Pic","x" ui.button1.pos.x " y" ui.button1.pos.y " w" ui.button1.size.w " h" ui.button1.size.h " 0xe")
gui_button1.OnEvent("Click", (*)=>btn_onEvt(gui_button1.Hwnd))
gui_button2:=mgui.Add("Pic","x" ui.button2.pos.x " y" ui.button2.pos.y " w" ui.button2.size.w " h" ui.button2.size.h " 0xe")
gui_button2.OnEvent("Click", (*)=>btn_onEvt(gui_button2.Hwnd))
;~ --------------------------------------------------by
gui_by:=mgui.Add("Pic","x" ui.by.pos.x " y" ui.by.pos.y " w" ui.by.size.w " h" ui.by.size.h " 0xe")

hBitmap.title:=hBitmapBy2ColorAndText(ui.title.size.w,ui.title.size.h,ui.fgcolor,"iwck","bold cFFf1f1f1 S48 Left")
hBitmap.by:=hBitmapBy2ColorAndText(ui.by.size.w,ui.by.size.h,ui.fgcolor,"github.com/Nigh","cFFf1f1f1 S14 Right")

hBitmap.button1:=hBitmapByBorderHatchAndText(ui.button1.size.w,ui.button1.size.h,
0xffad395c,2,ui.fgcolor,ui.bgcolor,ui.hatch,"Block")
hBitmap.button1Hover:=hBitmapByBorderHatchAndText(ui.button1.size.w,ui.button1.size.h,
0xffad395c,8,0xffad395c,ui.bgcolor,38,"Block")
hBitmap.button1Disable:=hBitmapByBorderHatchAndText(ui.button1.size.w,ui.button1.size.h,
0xff4b4b4b,4,0xff4b4b4b,ui.bgcolor,ui.hatch,"Block")

hBitmap.button2:=hBitmapByBorderHatchAndText(ui.button2.size.w,ui.button2.size.h,
0xff4b4b4b,2,ui.fgcolor,ui.bgcolor,23,"Exit")
hBitmap.button2Hover:=hBitmapByBorderHatchAndText(ui.button2.size.w,ui.button2.size.h,
0xffad395c,8,0xffad395c,ui.bgcolor,23,"Exit")

hBitmap.bg:=hBitmapByBorderHatchAndText(ui.size.w,ui.size.h,
0xff646464,4,0xff323232,ui.bgcolor,ui.hatch)

SetImage(gui_bg.Hwnd,hBitmap.bg)
SetImage(gui_title.Hwnd,hBitmap.title)
SetImage(gui_by.Hwnd,hBitmap.by)
SetImage(gui_button1.Hwnd,hBitmap.button1)
SetImage(gui_button2.Hwnd,hBitmap.button2)
mgui.Show("w" ui.size.w " h" ui.size.h)
Return

titleMove(*)
{
	PostMessage 0xA1, 2
}

btn_onEvt(hwnd)
{
	global	
	if(hwnd=gui_button1.Hwnd){
		if(block!=1){
			SetImage(gui_button1.Hwnd,hBitmap.button1Disable)
			block:=1
			Loop blockExKey.Length
			Hotkey blockExKey[A_Index], "donothing", "On"
			SetTimer "blockKeyboard", -1
		}Else{
			SetImage(gui_button1.Hwnd,hBitmap.button1Hover)
			block:=0
			Loop blockExKey.Length
			Hotkey blockExKey[A_Index], "donothing", "Off"
			InputEnd
		}
	}
	if(hwnd=gui_button2.Hwnd){
		ExitApp
	}
}

donothing:
Return

blockKeyboard()
{
	global block
	loop{
		Input _,
		if(!block){
			Return
		}
	}
}

buttonRelease(mouseFlag)
{
	global
	if(mouseFlag="btn1"){
		if(block=0)
			SetImage(gui_button1.Hwnd,hBitmap.button1)
	}
	if(mouseFlag="btn2")
		SetImage(gui_button2.Hwnd,hBitmap.button2)
}

WM_MOUSEMOVE(wp,lp,msg,hwnd)
{
	global
	static mouseFlag:=""
	lpy:=(lp>>16)&0xffff
	lpx:=lp&0xffff
	; tooltip, % "WM_MOUSEMOVE:`n" hwnd+0 "," msg+0 "," lpx "," lpy
	if(hwnd=gui_button1.Hwnd){
		if(mouseFlag!="btn1"){
			buttonRelease(mouseFlag)
			if(block=0){
				SetImage(gui_button1.Hwnd,hBitmap.button1Hover)
				mouseFlag:="btn1"
			}Else{
				mouseFlag:=""
			}
		}
	}Else if(hwnd=gui_button2.Hwnd){
		if(mouseFlag!="btn2"){
			buttonRelease(mouseFlag)
			SetImage(gui_button2.Hwnd,hBitmap.button2Hover)
		}
		mouseFlag:="btn2"
	}Else{
		buttonRelease(mouseFlag)
		mouseFlag:=""
	}

}



hBitmapHatch(w,h,bgcolor:=0xffff0000,fgcolor:=0xff00ff00,hatch:=0)
{
	pBitmap := Gdip_CreateBitmap(w, h)
	G := Gdip_GraphicsFromImage(pBitmap)
	Gdip_SetSmoothingMode(G, 4)
	pBrush := Gdip_BrushCreateHatch(fgcolor,bgcolor,hatch)
	Gdip_FillRectangle(G, pBrush, -1, -1, w+1, h+1)
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	Gdip_DeleteBrush(pBrush)
	Gdip_DeleteGraphics(G)
	Gdip_DisposeImage(pBitmap)
	Return hBitmap
}
hBitmapByBorderHatchAndText(w,h,bdcolor:=0xffffffff,bdwidth:=1,fgcolor:=0xff00ff00,bgcolor:=0xff00ff00,hatch:=1,text:="",option:="")
{
	global ui
	pBitmap := Gdip_CreateBitmap(w, h)
	G := Gdip_GraphicsFromImage(pBitmap)
	Gdip_SetSmoothingMode(G, 4)
	pBrush := Gdip_BrushCreateHatch(fgcolor,bgcolor,hatch)
	Gdip_FillRectangle(G, pBrush, -1, -1, w+1, h+1)
	if(text!=""){
		if(option="")
			Gdip_TextToGraphics(G, text,"cFFf1f1f1 S20 Center vCenter","Consolas",w,h)
		Else
			Gdip_TextToGraphics(G, text,option,"Consolas",w,h)
	}
	Gdip_DeleteBrush(pBrush)
	if(bdwidth>0){
		pBrush := Gdip_BrushCreateSolid(bdcolor)
		Gdip_FillRectangle(G, pBrush, -1, -1, w, bdwidth+1)
		Gdip_FillRectangle(G, pBrush, 1, h-bdwidth-1, w, h)
		Gdip_FillRectangle(G, pBrush, -1, -1, bdwidth+1, h)
		Gdip_FillRectangle(G, pBrush, w-bdwidth-1, 1, w-1, h)
	}
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	Gdip_DeleteBrush(pBrush)
	Gdip_DeleteGraphics(G)
	Gdip_DisposeImage(pBitmap)
	Return hBitmap
}
hBitmapBy2ColorAndText(w,h,fgcolor:=0xff00ff00,text:="",option:="")
{
	global ui
	Return hBitmapByBorderHatchAndText(w,h,,0,fgcolor,ui.bgcolor,ui.hatch,text,option)
}
hBitmapByColorAndText(w,h,bgcolor:=0xffff0000,text:="",option:="")
{
	pBitmap := Gdip_CreateBitmap(w, h)
	G := Gdip_GraphicsFromImage(pBitmap)
	Gdip_SetSmoothingMode(G, 4)
	pBrush := Gdip_BrushCreateSolid(bgcolor)
	Gdip_FillRectangle(G, pBrush, -1, -1, w+1, h+1)
	if(text!=""){
		if(option="")
			Gdip_TextToGraphics(G, text,"cFFf1f1f1 S20 Center vCenter","Consolas",w,h)
		Else
			Gdip_TextToGraphics(G, text,option,"Consolas",w,h)
	}
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	Gdip_DeleteBrush(pBrush)
	Gdip_DeleteGraphics(G)
	Gdip_DisposeImage(pBitmap)
	Return hBitmap
}

ExitFunc(ExitReason, ExitCode)
{
	global pToken
	Gdip_Shutdown(pToken)
}
Exit:
GuiClose:
Gdip_Shutdown(pToken)
ExitApp
