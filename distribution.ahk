#SingleInstance Force
SetWorkingDir(A_ScriptDir)

#include meta.ahk

write_prop(vnt) {
	global
	try
	{
		_name := baseName
		if(vnt > 0) {
			_name .= "-VNT"
		}
		binaryFilename := _name ".exe"
		downloadFilename := _name ".zip"
		props := FileOpen("compile_prop.ahk", "w")
		props.WriteLine(";@Ahk2Exe-SetName " _name)
		props.WriteLine(";@Ahk2Exe-SetVersion " version)
		props.WriteLine(";@Ahk2Exe-SetMainIcon iwck.ico")
		props.WriteLine(";@Ahk2Exe-ExeName " _name)
		props.WriteLine("VNT := " vnt)
		props.Close()
	}
	catch as e
	{
		MsgBox("Writting compile props`nERROR CODE=" . e.Message)
		ExitApp
	}
}

if InStr(FileExist("dist"), "D")
{
	try
	{
		DirDelete("dist", 1)
	}
	catch as e
	{
		MsgBox("removing dist`nERROR CODE=" . e.Message)
		ExitApp
	}
}

DirCreate("dist")

compile() {
	global
	if FileExist(binaryFilename)
	{
		FileDelete(binaryFilename)
	}

	try
	{
		RunWait("./ahk-compile-toolset/ahk2exe.exe /in " ahkFilename " /out " binaryFilename " /base `"" A_AhkPath "`" /compress 1")
	}
	catch as e
	{
		MsgBox(ahkFilename . "`nERROR CODE=" . e.Message)
		ExitApp
	}

	try
	{
		RunWait("powershell -command `"Compress-Archive -Path .\" binaryFilename " -DestinationPath " downloadFilename '"', , "Hide")
	}
	catch as e
	{
		MsgBox("compress`nERROR CODE=" . e.Message)
		ExitApp
	}
	FileDelete(binaryFilename)
	FileMove(downloadFilename, "dist\" downloadFilename, 1)
}
write_prop(0)
compile()
write_prop(1)
compile()
MsgBox("Build Finished")
