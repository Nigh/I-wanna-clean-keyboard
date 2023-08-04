
.PHONY: default

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
