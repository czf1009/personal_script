;;;;;;;;;;;鼠标手势
Guesture_Init(G)
{
	Global G_R
	for k,v in G.Exclude[""]
		GroupAdd, G_ExcludeGroup, %v%
	; Gui, 76: +LastFound -Caption +ToolWindow +AlwaysOnTop
	; Gui, 76: Color, FFFFFF
	; WinSet, TransColor, FFFFFF
	; Gui, 76: Show, X0 Y0 W%A_ScreenWidth% H%A_ScreenHeight% NA, AHK 鼠标手势
	; G.ID := WinExist()
	; G.DC := DllCall("GetDC", "uint", G.ID)
	VarSetCapacity(G_R, 16, 0), NumPut(A_ScreenHeight, NumPut(A_ScreenWidth, G_R, 8, "Int"), "Int")	G.ONOFF:=1
}
Guesture_On()
{
	Global
	MouseGetPos,,, G_Id
	Return, !WinExist("ahk_group G_ExcludeGroup ahk_id " G_Id) && G.ONOFF
}

#if Guesture_On()
RButton::
#RButton::G()
#if
G()
{
Global G,G_Id,G_P,G_T,G_R
MouseGetPos, X1,Y1
; DllCall("MoveToEx", "uint", G.DC, "int", X1, "int", Y1, "uint", 0)
WinGetTitle, G_T, ahk_ID %G_Id%
WinGet, G_P, ProcessName, ahk_ID %G_Id%
;~ WinActivate, % "ahk_id " G.ID
While, GetKeyState("RButton","P")
{
	MouseGetPos, X2,Y2
	if (X2==X1 && Y2==Y1)
	{
		Sleep, 20
		Continue
	}
	; DllCall("SelectObject", "uint", G.DC, "uint", DllCall("CreatePen", "int", 0, "int", 8, "uint", DllCall("shlwapi.dll\ColorHLSToRGB",Int,A_Sec*4,Int,120,Int,240)))
	; DllCall("LineTo", "uint", G.DC, "int", X2, "int", Y2)
	Z:=(X2-X1)>-(Y2-Y1) ? 0 : 2, Z+=(X2-X1)>(Y2-Y1) ? 6 : 2
	if (Z<>SubStr(G1, 0, 1)) && (abs(Y1-Y2)>4 || abs(X1-X2)>4)
		G1.=Z
	X1:=X2,Y1:=Y2
	if G[G_P].HasKey(G1)
		Command := G[G_P][G1].Key, Name := G[G_P][G1].Name
	else if G["Default"].HasKey(G1)
		Command := G["Default"][G1].Key, Name := G["Default"][G1].Name
	else	Command := "{RButton}", Name := "无"
	if G1
		Tooltip, % G1 " = " Name
}
if ! G1
{
	Send, {RButton}
	DllCall("FillRect", "uint", G.DC, "int", &G_R, "uint", 0)
	Return
}
; if GetKeyState("LWin","P")			;按住LWin画画
; {
; 	Tooltip
; 	Return
; }
DllCall("FillRect", "uint", G.DC, "int", &G_R, "uint", 0)

if Asc(Command)=64									;@开头的命令是函数
{
	StringSplit, Command, Command, |
	%Command1%(Command2)
}
else if Asc(Command)=36									;$开头的是标签
{
	Command:=SubStr(Command,2)
	if IsLabel(Command)
		GoSub, %Command%
}
else												;发送按键
	Send, %Command%
Tooltip
;~ SetTimer, Timer_G_Tooltip, -1000
}
Timer_G_Tooltip:
	Tooltip
return
;
@Run(Command)
{
	Run, %Command%
}
;
@Close()
{
	Global
	if (G_P=="explorer.exe" && G_T=="")			;桌面
		Return
	else
	{
		WinClose, ahk_id %G_Id%
	}
}
