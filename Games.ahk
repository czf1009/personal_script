﻿#SingleInstance force
SetFormat,float,0.0
SetTitleMatchMode RegEx
SetWorkingDir, %A_ScriptDir%

Menu,Tray,Add,Edit...,myEdit
Menu,Tray,Add,,changeBlackList

;;;;;;;;;;;;;;;;;;;;;;;;;;获取管理员权限;;;;;;;;;;;;;;;;;;;;;
/*
Loop, %0%  ; For each parameter:
{
    param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
    params .= A_Space . param
}
ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"

if not A_IsAdmin
{
    If A_IsCompiled
    DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A_WorkingDir, int, 1)
    Else
    DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int, 1)
    ExitApp
}
*/
If not A_IsAdmin    ;验证是否用了管理员权限 否则自动用管理员权限启动
  {
    Run *RunAs "%A_ScriptFullPath%"  ; 需要 AHK_L 57+
    ExitApp
  }


a::
    while GetKeyState("a","P")
    {
        Click
        Sleep, 100
    }
return
/*
F1::
    Sleep,300
    loop
    {
        Send,1{Click}
        Sleep,70
        if GetKeyState("F1")
        {
            break
        }
    }
return

*NumpadAdd::
MouseClick, left,,, 1, 0, D  ; Hold down the left mouse button.
Loop
{
    Sleep, 10
    if !GetKeyState("NumpadAdd", "P")  ; The key has been released, so break out of the loop.
        break
    ; ... insert here any other actions you want repeated.
}
MouseClick, left,,, 1, 0, U  ; Release the mouse button.
return
*/
/*
┌──────────────────┐
├─托盘菜单事件
└──────────────────┘
*/
myEdit:
    run,D:\Program Files\Sublime Text 3.3126x64\sublime_text.exe,"%A_ScriptFullPath%"
    Return

changeBlackList:    
    SetBatchLines, -1
    GUI,GQR:Add,Edit,x10 y10 w500 h400 Limit850
    GUI,GQR:Add,Button,x10  y420 w90 h30 gClip,打开剪切板(&V)
    GUI,GQR:Add,Button,x320 y420 w90 h30 gSTART,生成二维码(&G)
    GUI,GQR:Add,Button,x420 y420 w90 h30 gGQRGUIClose,关闭(&C)
    GUI,GQR:Show,w520 h460,GenQR
    Return