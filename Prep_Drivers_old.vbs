'==========================================================================
'
' NAME: Prep_Drivers.vbs
'
' AUTHOR: Brian Gonzalez, PSCNA
' DATE  : 10/9/2012
'
' COMMENT: Shortens names of folders and compresses them.
'==========================================================================
On Error Resume Next
'Setup common objects
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
strScriptFolder = objFSO.GetParentFolderName(Wscript.ScriptFullName)
strFolderLength = 25
str7ZipPath = strScriptFolder & "\7za.exe"

'Populate var with current directory
strScriptFolder = objFSO.GetParentFolderName(Wscript.ScriptFullName) 'No trailing backslash
strDriverParentFolder = strScriptFolder & "\src"

Set objDriverParentFolder = objFSO.GetFolder(strDriverParentFolder)
For Each fol In objDriverParentFolder.SubFolders
	If Not objFSO.FileExists(fol.path & "\pinstall.bat") AND Not LEFT(fol.name, 2) = "99" Then
		strMess = strMess & vbCrlf & fol.name & " ""pinstall.bat"" does not exist."
		strErrors = True
	End If
	If Len(fol.name) > strFolderLength Then
		strNewName = Replace(fol.name, "[", "")
		strNewName = Replace(strNewName, "]", "")
		strNewName = Replace(strNewName, "Utility", "")
		strNewName = Replace(strNewName, "Util", "")
		strNewName = Replace(strNewName, "Driver", "")
		strNewName = Replace(strNewName, "Manager", "")
		strNewName = Replace(strNewName, "MgrApp", "")
		strNewName = Replace(strNewName, " ", "")
		strNewName = Replace(strNewName, "(", "_")
		strNewName = Replace(strNewName, ")", "_")
		strNewName = Replace(strNewName, "__", "_")
		strNewName = Left(strNewName, strFolderLength)
		objFSO.MoveFolder fol.path, strDriverParentFolder & "\" & strNewName
	End If
Next
If strErrors = True Then
	Wscript.Echo strMess
Else
	WScript.Echo "Folders are shortened and ready for compression."
	objShell.CurrentDirectory = strScriptFolder
	For Each fol In objDriverParentFolder.SubFolders
		'strCmd = "cmd /c """ & str7ZipPath & """ a """ & fol.name & ".zip"" " & fol.name & "\*"
		strCmd = "cmd /c 7za.exe a "".\src\" & fol.name & ".zip"" "".\src\" & fol.name & "\*"""
		'WScript.Echo strCmd
		intReturn = objShell.Run(strCmd, 3, True)
		'WScript.Echo intReturn
		If intReturn = 0 Then
			objFSO.DeleteFolder fol.path
		Else
			WScript.Echo "Error when compressing folder: " & fol.path & ", exiting script"
			WScript.Quit
		End If
	Next
End If
