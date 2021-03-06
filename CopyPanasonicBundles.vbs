'==========================================================================
' NAME: CopyPanasonicDriverBundles.vbs
'
' AUTHOR: Brian Gonzalez , Panasonic
' DATE  : 12/13/2012
'
' COMMENT:
' Copies appropiate Panasonic Bundle downn to local machine for execution
'	on startup.
'==========================================================================

On Error Resume Next
dim oFSO, oFile, oShell, oWMI, oRef
dim sScriptFolder, i, sShortModel
 
set oFSO = CreateObject("Scripting.FileSystemObject")
set oShell = CreateObject("WScript.Shell")
Set oWMI = GetObject("Winmgmts://.")
sScriptFolder = oFSO.GetParentFolderName(WScript.ScriptFullName) 'No trailing backslash
Const cReturnImmediately=&h10
Const cForwardOnly=&h20
sLocalDriverFolder = "C:\SCSO\PostImage"

sQuery = "Select Model FROM Win32_ComputerSystem"
Set oRef = oWMI.ExecQuery(strQuery,"WQL",cForwardOnly+cReturnImmediately)
For Each i In oRef
	sShortModel = Left(item.model, 5)
Next

sPanaBundleFolder = "T:\PanaBundles\" & sShortModel
If objFSO.FolderExists(sPanaBundleFolder) Then
	sRet = objShell.Run("xcopy.exe """ & sPanaBundleFolder & "\*.*"" """ & sLocalDriverFolder & "\"" /heyi /EXCLUDE:""" & sScriptFolder & "\exclude.txt""", 3, True)
End If