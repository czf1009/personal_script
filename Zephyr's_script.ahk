#SingleInstance force
SetFormat,float,0.0
SetTitleMatchMode RegEx
SetWorkingDir, %A_ScriptDir%
Menu, TRAY, Icon, A.ico

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

/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;开机选项;;;;;;;;;;;;;;;;;;;;;;;;
SetTimer, ChangeButtonNames, 50
MsgBox, 3, 你现在在哪里, 你现在在哪里
IfMsgBox, No
{
	;Run D:\Program Files (x86)\Tencent\QQ\Bin\QQScLauncher.exe
	return
}
else IfMsgBox, Yes
{
	Run C:\Drcom\DrUpdateClient\DrMain.exe
	WinWait 网络选择,,3
	WinActivate
	Send, {Enter}
	;WinWait, ahk_class #32770, NetStateWin
	;Run D:\Program Files (x86)\Tencent\QQ\Bin\QQScLauncher.exe
	;Run D:\Program Files (x86)\uTorrent\uTorrent.exe,,Hide
	;Run D:\Users\lenovo\AppData\Local\Youdao\Dict\YodaoDict.exe
	;Run D:\Program Files (x86)\kingsoft\kwifi\kwifi.exe
	return
}
else
{	
	return
}
ChangeButtonNames:
IfWinNotExist, 你现在在哪里
return  ; Keep waiting.
SetTimer, ChangeButtonNames, off
WinActivate
ControlSetText, Button1, &学校
ControlSetText, Button2, &家
return

Run C:\Drcom\DrUpdateClient\DrMain.exe
WinWait 错误,,1
if !ErrorLevel
{
	WinActivate
	Send, {Enter}
}

WinWait 网络选择,,3
if !ErrorLevel
{
	WinActivate
	Send, {Enter}
}
*/

;;;;;;;;;;;;加载配置;;;;;;;;;;;;
SETTING := Yaml("L_R.yml")
for k,v in SETTING.Nothing[""]
	GroupAdd, Nothing, %v%
for k,v in SETTING.CtrlW[""]
	GroupAdd, CtrlW, %v%
for k,v in SETTING.AltF4[""]
	GroupAdd, AltF4, %v%
for k,v in SETTING.Esc[""]
	GroupAdd, Esc, %v%

;;;;;;;;;;;;;;;;鼠标手势;;;;;;;;;;;;;;;;;;
CoordMode, Mouse, Screen
SetTitleMatchMode, RegEx
G := Yaml("Guesture.yml")
G.Exclude := SETTING.Nothing
Guesture_Init(G)

;;;;;;;;;;;;;;;;;;左右键同时按关闭窗口;;;;;;;;;;;;;;;;;;;;;

~LButton & RButton::		
{
	IfWinActive, ahk_group CtrlW
	{
		Send, ^w
		Return
	}		
	IfWinActive, ahk_group AltF4
	{
		Send, !{F4}
		Return
	}
	IfWinActive, ahk_group Esc
	{
		Send, {esc}
		Return
	}
	IfWinActive, ahk_group Nothing
	{
		Return
	}	
	MouseGetPos,,, G_Id
	WinClose, ahk_id %G_Id%
	Return
}
;;;;;;;;;;;;;;;;;;;;;;;;热键修改;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#f::run "D:\Program Files\Everything\Everything.exe"	;Win+f 打开Everything
AppsKey::RCtrl
; RAlt::LWin

;打开BlackBoard----------------------------------------------------
:://html::
Run http://www.w3school.com.cn/tags/index.asp
return

:://css::
Run http://www.w3school.com.cn/cssref/index.asp
return

:://js::
Run http://www.w3school.com.cn/jsref/index.asp
return
;;;;;;;;;;快速打开程序/搜索(快捷键);;;;;;;;;;;;;;;;;;;;;;;;; 
{

	;用google搜索 
	#h:: 
	Send ^c
	Sleep 300
	Run https://www.google.com.hk/search?q=%clipboard% 
	return 
	;用百度搜索 
	#b:: 
	Send ^c
	Sleep 300
	Run http://www.baidu.com/s?wd=%clipboard% 
	return 
	;用淘宝搜索
	#t:: 
	Send ^c
	Sleep 300
	Run http://s.taobao.com/search?q=%clipboard% 
	return 
	;用知乎搜索
	#z:: 
	Send ^c
	Sleep 300
	Run https://www.zhihu.com/search?type=content&q=%clipboard%
	return 
	;用Youtube搜索
	#y:: 
	Send ^c
	Sleep 300
	Run https://www.youtube.com/results?search_query=%clipboard%
	return 
	;用京东搜索
	#j:: 
	Send ^c
	Sleep 300
	Run http://search.jd.com/Search?keyword=%clipboard%&enc=utf-8
	return 	
	;用亚马逊搜索
	#a:: 
	Send ^c
	Sleep 300
	Run https://www.amazon.cn/s/field-keywords=%clipboard%
	return 
	;用维基百科搜索
	#w:: 
	Send ^c
	Sleep 300
	Run http://zh.wikipedia.org/wiki/%clipboard%
	return 
	;用B站搜索
	#n:: 
	Send ^c
	Sleep 300
	Run http://search.bilibili.com/all?keyword=%clipboard%
	return 
	;stackoverflow搜索
	#s:: 
	Send ^c
	Sleep 300
	Run https://stackoverflow.com/search?q=%clipboard%
	return 

}

;;;;;;;;;;;;;;;;; 在屏幕右下角滚动鼠标来调节音量.;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#WheelUp::Send {Volume_Up}  ; 增加 1 个音程的主音量 (通常为 5%).
; #WheelDown::Send {Volume_Down 3}  ; 降低 3 个音程的主音量.
#WheelDown::Send {Volume_Down}  ; 降低 1 个音程的主音量.
#MButton::Send {Volume_Mute}  ; 对主音量进行静音/取消静音.
; #If MouseIsOver()
; 	WheelUp::
; 		Send {Volume_Up}
; 		return
; 	WheelDown::
; 		Send {Volume_Down}
; 		return
; 	MButton::
; 		Send {Volume_Mute}
; 		return

; 	MouseIsOver() {
; 		CoordMode ,Mouse
; 		MouseGetPos, xpos, ypos 
; 		if(xpos<5  and ypos <5)
; 		return true
; 	}
; #If



;===========\        通用label          \==================
RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	ToolTip
	return

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
