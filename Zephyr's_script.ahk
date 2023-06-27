#SingleInstance force
SetFormat,float,0.0
SetTitleMatchMode RegEx
SetWorkingDir, %A_ScriptDir%
Menu, TRAY, Icon, A.ico

Menu,Tray,Add,,changeBlackList
Menu,Tray,Add,编辑主脚本,editMain
Menu,Tray,Add,编辑左右键同时按,editL_R
Menu,Tray,Add,编辑鼠标手势,editGesture

EditorPath = D:\Program Files\Sublime Text\sublime_text.exe ;放在热键映射之后会失效

;;;;;;;;;;;;;;;;;;;;;;;;;;获取管理员权限;;;;;;;;;;;;;;;;;;;;;
If not A_IsAdmin    ;验证是否用了管理员权限 否则自动用管理员权限启动
  {
    Run *RunAs "%A_ScriptFullPath%"  ; 需要 AHK_L 57+
    ExitApp
  }


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

;;;;;;;;;;;;;;;;;;;;;;;;热键修改;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#o::SendMessage, 0x112, 0xF170, 2,, Program Manager ;关闭屏幕
;#f::run "D:\Program Files\Everything\Everything.exe"	;Win+f 打开Everything
AppsKey::RCtrl
; RAlt::LWin
#8::
Run C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe %A_ScriptDir%\ScreenScaling.ps1 0
return
#9::
Run C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe %A_ScriptDir%\ScreenScaling.ps1 1
return
#0::
Run C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe %A_ScriptDir%\ScreenScaling.ps1 2
return

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

;genshin
; :://us1::
; Send 365964325@qq.com{Tab}yddgbfxdybt
; Click, 893 841
; Send {enter}
; return

; :://us2::
; Send czf1009@126.com{Tab}yddgbfxdybT1
; Click, 893 841
; Send {enter}
; return

; :://us3::
; Send 19355165193{Tab}yddgbfxdybT1
; Click, 893 841
; Send {enter}
; return

:://psep::
Send 365964325@qq.com{Tab}Monkey2Game
Send {enter}
return

:://psub::
Send 365964325@qq.com{Tab}Monkey2Game~UB
Send {enter}
return

:://pscoolapk::
Send czf1009@qq.com{Tab}yddgbfxdybt
Send {enter}
return

;;;;;;;;;;快速打开程序/搜索(快捷键);;;;;;;;;;;;;;;;;;;;;;;;; 
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
;优酷
#u:: 
Run https://youku.com/
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
; Run https://stackoverflow.com/search?q=%clipboard%
Run https://so.zimuku.org/search?q=%clipboard%
return 	
;csdn搜索
#c:: 
Send ^c
Sleep 300
Run https://so.csdn.net/so/search/all?q=%clipboard%
return 


;;;;;;;;;;;;;;;;; 在屏幕右下角滚动鼠标来调节音量.;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#WheelUp::Send {Volume_Up}  ; 增加 1 个音程的主音量 (通常为 5%).
; #WheelDown::Send {Volume_Down 3}  ; 降低 3 个音程的主音量.
#WheelDown::Send {Volume_Down}  ; 降低 1 个音程的主音量.
; LWin::
;     while GetKeyState("LWin","P")
;     {
;         WheelUp::Volume_Up
;     }
; return
#MButton::Send {Volume_Mute}  ; 对主音量进行静音/取消静音.

;===========\        通用label          \==================
RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	ToolTip
	return

;=======================托盘菜单事件=======================
editMain:
	Run %EditorPath% %A_ScriptFullPath%
	Return
editL_R:
	Run %EditorPath% %A_ScriptDir%\L_R.yml
	Return
editGesture:
	Run %EditorPath% %A_ScriptDir%\Guesture.yml
	Return




changeBlackList:	
	SetBatchLines, -1
	GUI,GQR:Add,Edit,x10 y10 w500 h400 Limit850
	GUI,GQR:Add,Button,x10  y420 w90 h30 gClip,打开剪切板(&V)
	GUI,GQR:Add,Button,x320 y420 w90 h30 gSTART,生成二维码(&G)
	GUI,GQR:Add,Button,x420 y420 w90 h30 gGQRGUIClose,关闭(&C)
	GUI,GQR:Show,w520 h460,GenQR
	Return

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


;=======================Potplayer播放器长按倍速播放=======================
#IfWinActive ahk_class PotPlayer64 ahk_exe PotPlayerMini64.exe
Right::		; 长按0.3秒方向右键进行倍速播放，松开时恢复
	KeyWait, Right, T0.2
	if ErrorLevel {
		Send, c	; 调整此数值修改速度
		ToolTip, >>>
		KeyWait, Right	; 松开按键恢复正常速度
		Send, z
		ToolTip
	} else Send {Right}
	return
s::Send {Media_Stop}

; #IfWinActive ahk_exe Obsidian.exe
; ^1::
; 	Send {Home}{Home}- [ ] {Enter}
; 	return