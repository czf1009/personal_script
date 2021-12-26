#SingleInstance force
SetFormat,float,0.0
SetTitleMatchMode RegEx
SetWorkingDir, %A_ScriptDir%

Menu,Tray,Add,编辑主脚本,editScript

EditorPath = D:\Program Files\Sublime Text\sublime_text.exe ;放在热键映射之后会失效

;;;;;;;;;;;;;;;;;;;;;;;;;;获取管理员权限;;;;;;;;;;;;;;;;;;;;;
If not A_IsAdmin    ;验证是否用了管理员权限 否则自动用管理员权限启动
  {
    Run *RunAs "%A_ScriptFullPath%"  ; 需要 AHK_L 57+
    ExitApp
  }


;;;;;;;;;;;;;;;;;;;;;;;;热键修改;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#o::SendMessage, 0x112, 0xF170, 2,, Program Manager ;关闭屏幕
;#f::run "D:\Program Files\Everything\Everything.exe"	;Win+f 打开Everything
RAlt::LWin


;===========\        通用label          \==================
RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	ToolTip
	return

;=======================托盘菜单事件=======================
editScript:
	Run %EditorPath% %A_ScriptFullPath%
	Return



changeBlackList:	
	SetBatchLines, -1
	GUI,GQR:Add,Edit,x10 y10 w500 h400 Limit850
	GUI,GQR:Add,Button,x10  y420 w90 h30 gClip,打开剪切板(&V)
	GUI,GQR:Add,Button,x320 y420 w90 h30 gSTART,生成二维码(&G)
	GUI,GQR:Add,Button,x420 y420 w90 h30 gGQRGUIClose,关闭(&C)
	GUI,GQR:Show,w520 h460,GenQR
	Return

