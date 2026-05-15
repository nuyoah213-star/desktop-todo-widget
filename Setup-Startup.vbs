' ═══════════════════════════════════════════════════════════════
'  Setup-Startup.vbs — 将待办事项添加到 Windows 开机自启
'  双击运行即可。如果要取消，请运行 Remove-Startup.vbs
' ═══════════════════════════════════════════════════════════════

Option Explicit
Dim objShell, startupPath, shortcutPath, htaPath

Dim fso
Set fso = CreateObject("Scripting.FileSystemObject")

' HTA 文件路径（与脚本同目录）
htaPath = fso.GetParentFolderName(WScript.ScriptFullName) & "\todo.hta"

' 开机启动文件夹
Set objShell = CreateObject("WScript.Shell")
startupPath = objShell.SpecialFolders("Startup")
shortcutPath = startupPath & "\待办事项.lnk"
If Not fso.FileExists(htaPath) Then
    MsgBox "找不到 todo.hta 文件！" & vbCrLf & vbCrLf & _
           "请确保此脚本与 todo.hta 放在同一文件夹下。", 48, "错误"
    WScript.Quit 1
End If

' 创建快捷方式
Dim shortcut
Set shortcut = objShell.CreateShortcut(shortcutPath)
shortcut.TargetPath = htaPath
shortcut.WorkingDirectory = fso.GetParentFolderName(WScript.ScriptFullName)
shortcut.Description = "桌面待办事项"
shortcut.Save()

MsgBox "已添加到开机自启！" & vbCrLf & vbCrLf & _
       "下次开机时，待办事项会自动启动。" & vbCrLf & vbCrLf & _
       "如需取消，请运行 Remove-Startup.vbs", 64, "设置成功"
