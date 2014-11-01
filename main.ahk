#include gdip.ahk
#NoTrayIcon
#MaxThreadsPerHotkey 1

blockExKey:=Object()
blockExKey.Insert("LWin")
blockExKey.Insert("RWin")
blockExKey.Insert("CapsLock")
blockExKey.Insert("PrintScreen")
blockExKey.Insert("Sleep")

block:=0
ui:=Object()
ui["size"]:={w:320,h:160}
ui["title","pos"]:={x:0,y:5}
ui["title","size"]:={w:ui["size"].w-ui["title","pos"].x,h:51}
ui["button1","pos"]:={x:20,y:60}
ui["button1","size"]:={w:120,h:61}
rectBtn1:={x:ui["button1","pos"].x
			,y:ui["button1","pos"].y
			,w:ui["button1","size"].w
			,h:ui["button1","size"].h}
ui["button2","pos"]:={x:ui["button1","pos"].x+ui["button1","size"].w+40,y:ui["button1","pos"].y}
ui["button2","size"]:={w:120,h:61}
rectBtn1:={x:ui["button2","pos"].x
			,y:ui["button2","pos"].y
			,w:ui["button2","size"].w
			,h:ui["button2","size"].h}
ui["by","size"]:={w:ui["size"].w-20,h:21}
ui["by","pos"]:={x:10,y:130}
hBitmap:=Object()
If(!pToken := Gdip_Startup())
	ExitApp, -1

OnExit, Exit
Gui, -Caption +AlwaysOnTop +hwndGui1 -Owner
Gui, Color, EAEAEA,1ba1e2
OnMessage(0x200, "WM_MOUSEMOVE")
;~ --------------------------------------------------title
Gui, Add, Pic, % "x" ui["title","pos"].x " y" ui["title","pos"].y " w" ui["title","size"].w " h" ui["title","size"].h " 0xe hwndtitle gtitle",
;~ --------------------------------------------------border
Gui, Add, Pic, % "x0 y0 w" ui.size.w " h1 0xe hwndborderw1",
Gui, Add, Pic, % "x0 y" ui.size.h-2 " w" ui.size.w " h1 0xe hwndborderw2",
Gui, Add, Pic, % "x0 y0 w1 h" ui.size.h " 0xe hwndborderh1",
Gui, Add, Pic, % "x" ui.size.w-2 " y0 w1 h" ui.size.h " 0xe hwndborderh2",
;~ --------------------------------------------------button
Gui, Add, Pic, % "x" ui.button1.pos.x " y" ui.button1.pos.y " w" ui.button1.size.w " h" ui.button1.size.h " 0xe hwndbutton1 gbtn1", b1
Gui, Add, Pic, % "x" ui.button2.pos.x " y" ui.button2.pos.y " w" ui.button2.size.w " h" ui.button2.size.h " 0xe hwndbutton2 gbtn2", b2
;~ --------------------------------------------------by
Gui, Add, Pic, % "x" ui.by.pos.x " y" ui.by.pos.y " w" ui.by.size.w " h" ui.by.size.h " 0xe hwndby", by

hBitmap.borderH:=hBitmapByColorAndText(2,ui.size.h,0xffa8a8a8)
hBitmap.borderW:=hBitmapByColorAndText(ui.size.w,2,0xffa8a8a8)

hBitmap.button1:=hBitmapByColorAndText(ui.button1.size.w,ui.button1.size.h,0xff1ba1e2,"Block")
hBitmap.button1Hover:=hBitmapByColorAndText(ui.button1.size.w,ui.button1.size.h,0xc01ba1e2,"Block")
hBitmap.button1Disable:=hBitmapByColorAndText(ui.button1.size.w,ui.button1.size.h,0xff757772,"Block")

hBitmap.button2:=hBitmapByColorAndText(ui.button2.size.w,ui.button2.size.h,0xffe2514b,"Exit")
hBitmap.button2Hover:=hBitmapByColorAndText(ui.button2.size.w,ui.button2.size.h,0xc0e2514b,"Exit")
hBitmap.title:=hBitmapByColorAndText(ui.title.size.w,ui.title.size.h,0x0000ffff,"I Wanna Clean Keyboard","bold cE0333224 S24 Center vCenter")
hBitmap.by:=hBitmapByColorAndText(ui.by.size.w,ui.by.size.h,0x0000ffff,"jiyucheng007@gmail.com","cE0333224 S14 Right vCenter")

SetImage(borderw1,hBitmap.borderW)
SetImage(borderw2,hBitmap.borderW)
SetImage(borderh1,hBitmap.borderH)
SetImage(borderh2,hBitmap.borderH)
SetImage(button1,hBitmap.button1)
SetImage(button2,hBitmap.button2)
SetImage(title,hBitmap.title)
SetImage(by,hBitmap.by)
Gui, Show,% "w" ui.size.w " h" ui.size.h
Return

title:
PostMessage, 0xA1, 2
Return

btn1:
if(!block){
	SetImage(button1,hBitmap.button1Disable)
	block:=1
	Loop, % blockExKey.maxIndex()
	Hotkey, % blockExKey[A_Index], block, On
	SetTimer, blockKeyboard, -1
}Else{
	SetImage(button1,hBitmap.button1Hover)
	block:=0
	Loop, % blockExKey.maxIndex()
	Hotkey, % blockExKey[A_Index], block, Off
	Input, _,T0.1
}
Return

block:
Return

blockKeyboard:
loop{
	Input, _,
	if(!block)
		Exit
}
Return

btn2:
goto Exit

buttonRelease(mouseFlag)
{
	global
	if(mouseFlag="btn1"){
		if(block=0)
			SetImage(button1,hBitmap.button1)
	}
	if(mouseFlag="btn2")
		SetImage(button2,hBitmap.button2)
}

WM_MOUSEMOVE(wp,lp,msg,hwnd)
{
	global
	static mouseFlag:=""
	lpy:=(lp>>16)&0xffff
	lpx:=lp&0xffff
	; tooltip, % "WM_MOUSEMOVE:`n" hwnd+0 "," msg+0 "," lpx "," lpy
	if(hwnd=button1){
		if(mouseFlag!="btn1"){
			buttonRelease(mouseFlag)
			if(block=0){
				SetImage(button1,hBitmap.button1Hover)
				mouseFlag:="btn1"
			}Else{
				mouseFlag:=""
			}
		}
	}Else if(hwnd=button2){
		if(mouseFlag!="btn2"){
			buttonRelease(mouseFlag)
			SetImage(button2,hBitmap.button2Hover)
		}
		mouseFlag:="btn2"
	}Else{
		buttonRelease(mouseFlag)
		mouseFlag:=""
	}

}


hBitmapByColorAndText(w,h,bgcolor=0xffff0000,text="",option="")
{
	pBitmap := Gdip_CreateBitmap(w, h)
	, G := Gdip_GraphicsFromImage(pBitmap)
	, Gdip_SetSmoothingMode(G, 4)
	pBrush := Gdip_BrushCreateSolid(bgcolor)
	Gdip_FillRectangle(G, pBrush, -1, -1, w+1, h+1)
	if(text!=""){
		if(option="")
			Gdip_TextToGraphics(G, text,"cFFf0f0f0 S20 Center vCenter","Arial",w,h)
		Else
			Gdip_TextToGraphics(G, text,option,"Arial",w,h)
	}
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	Gdip_DeleteBrush(pBrush)
	,Gdip_DeleteGraphics(G)
	,Gdip_DisposeImage(pBitmap)
	Return, hBitmap
}

Exit:
GuiClose:
Gdip_Shutdown(pToken)
ExitApp
