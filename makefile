
.PHONY: default

define NORMAL_SETTING
;@Ahk2Exe-ExeName iwck
VNT:=0
endef

define VNT_SETTING
;@Ahk2Exe-ExeName iwck-VNT
VNT:=1
endef

default:
	@echo build normal version
	@echo ;@Ahk2Exe-ExeName iwck > setting.ahk
	@echo VNT:=0 >> setting.ahk
	@ahk2exe.exe /in "main.ahk"

	@echo build VNT version
	@echo ;@Ahk2Exe-ExeName iwck-VNT > setting.ahk
	@echo VNT:=1 >> setting.ahk
	@ahk2exe.exe /in "main.ahk"

	@del setting.ahk
