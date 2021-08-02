
;该脚本会导致右键长按失灵, 不想使用的程序可以加到notNeedGesture分组内进行屏蔽
#IfWinNotActive AHK_Group notNeedGesture
    ;左手势
    MouseLeftGesture(){
        SendInput, ^{PgUp}
    }
    
    ;右手势
    MouseRightGesture(){
        SendInput, ^{PgDn}
    }
    
    ;上手势
    MouseUpGesture(){
        SendInput, {F5}
    }
    
    ;下手势
    MouseDownGesture(){
        if(WinActive("Ahk_group idea")){
            SendInput, !3
            return
        }
        SendInput, ^w
    }
    
    ;下左手势
    MouseDownLeftGesture(){
        if(WinActive("Ahk_group idea")){
            SendInput, !z
            return
        }
        SendInput, ^+t
    }
    
    ;下右手势
    MouseDownRightGesture(){
        SendInput, !+w
    }
    
    ;上右手势
    MouseUpRightGesture(){
        SendInput, !{F4}
    }
    
    ;上左手势
    MouseUpLeftGesture(){
        SendInput, {rbutton}
    }
    
    ;; 鼠标手势
    rbutton::    
        minGap  = 30 ; 设定的识别阈值，大于此阈值，说明在某方向上有移动
        mousegetpos xpos1,ypos1
        Keywait, RButton, U
        mousegetpos xpos2, ypos2
        if (abs(xpos1-xpos2) < minGap and abs(ypos1-ypos2)<minGap) ; nothing 没有运动，直接输出rbutton 
            SendInput, {rbutton}
        else if (xpos1-xpos2 > minGap and abs(ypos1-ypos2)<minGap) ; left pageup
            MouseLeftGesture()
        else if (xpos2-xpos1 > minGap and abs(ypos1-ypos2)<minGap) ; right pagedown
            MouseRightGesture()
        else if (abs(xpos1-xpos2)< minGap and (ypos1-ypos2)>minGap) ; up refresh
            MouseUpGesture()
        else if (abs(xpos1-xpos2)< minGap and (ypos2-ypos1)>minGap) ; down close
            MouseDownGesture()
        else if (ypos2-ypos1 > minGap and (xpos1-xpos2) > minGap) ; down and left , ctrl+shift+T
            MouseDownLeftGesture()
        else if (ypos2-ypos1 > minGap and (xpos2-xpos1) > minGap) ; down and right, ctrl others
            MouseDownRightGesture()
        else if (ypos1-ypos2 > minGap and (xpos2-xpos1) > minGap) ; up and right killApplication
            MouseUpRightGesture()
        else if (ypos1-ypos2 > minGap and (xpos1-xpos2) > minGap) ; up and left nothing
            MouseUpLeftGesture()
        else  
            SendInput, {rbutton}
    return
#IfWinNotActive