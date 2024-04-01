
.PHONY: default

VERSION ?= v3.04

default:
	@echo build normal version
	@echo ;@Ahk2Exe-ExeName iwck > setting.ahk
	@echo ;@Ahk2Exe-SetVersion $(VERSION) >> setting.ahk
	@echo version := "$(VERSION)" >> setting.ahk
	@echo VNT:=0 >> setting.ahk
	@./ahk-compile-toolset/ahk2exe.exe /in "main.ahk" /base "./ahk-compile-toolset/AutoHotkey64.exe" /compress 1

	@echo build VNT version
	@echo ;@Ahk2Exe-ExeName iwck-VNT > setting.ahk
	@echo ;@Ahk2Exe-SetVersion $(VERSION) >> setting.ahk
	@echo version := "$(VERSION) VNT" >> setting.ahk
	@echo VNT:=1 >> setting.ahk
	@./ahk-compile-toolset/ahk2exe.exe /in "main.ahk" /base "./ahk-compile-toolset/AutoHotkey64.exe" /compress 1

	@del setting.ahk
