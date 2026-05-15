' ═══════════════════════════════════════════════════════════════
'  Remove-Startup.vbs — 取消待办事项的开机自启
' ═══════════════════════════════════════════════════════════════

Option Explicit
Dim objShell, startupPath, shortcutPath, fso

Set objShell = CreateObject("WScript.Shell")
startupPath = objShell.SpecialFolders("Startup")
shortcutPath = startupPath & "\待办事项.lnk"

Set fso = CreateObject("Scripting.FileSystemObject")
If fso.FileExists(shortcutPath) Then
    fso.DeleteFile(shortcutPath, True)
    MsgBox "已从开机自启中移除。", 64, "完成"
Else
    MsgBox "开机自启中未找到"待办事项"的快捷方式。", 48, "提示"
End If
