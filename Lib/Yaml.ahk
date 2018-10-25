Yaml(YamlText,IsFile=1,YamlObj=0){
	static base:=Object("Dump","Yaml_Dump","Save","Yaml_Save","Add","Yaml_Add","Merge","Yaml_Merge","Insert","Insert","Remove","Remove","__Delete","__Delete","MaxIndex","MaxIndex","_NewEnum","_NewEnum","Next","Next","GetAddress","GetAddress","SetCapacity","SetCapacity","GetCapacity","GetCapacity","Clone","Clone","HasKey","HasKey","base",Object("__Call","Yaml_Call"))
	static BackupVars:="LVL,SEQ,KEY,SCA,TYP,VAL,CMT,LFL,CNT"
	AutoTrim % ((AutoTrim:=A_AutoTrim)="On")?"Off":"Off"
	LVL0:=pYaml:=YamlObj?YamlObj:Object("base",base),__LVL:=0,__LVL0:=0
	if IsFile
		FileRead,YamlText,%YamlText%
	Loop,Parse,YamlText,`n,`r
	{
		if (A_LoopField=""||(RegExMatch(A_LoopField,"^\s+$")&&__KEY=""&&__SEQ="")){
			if (!(__KEY!="" && __VAL!="") && !(__SEQ||!__CNT)) {
				if ((OBJ:=LVL%__LVL%[""].MaxIndex())&&IsObject(LVL%__LVL%["",OBJ])&&__SEQ){
					if __KEY!=
						Yaml_Continue(LVL%__LVL%["",Obj],__key,"",__SCA)
					else Yaml_Continue(LVL%__LVL%[""],Obj,"",__SCA,__SEQ)
				} else if (__SEQ && OBJ){
					Yaml_Continue(LVL%__LVL%[""],Obj,"",__SCA,__SEQ)
				} else if (OBJ){
					Yaml_Continue(LVL%__LVL%[""],OBJ,"",__SCA,1)
				} else if (__KEY!="")
					Yaml_Continue(LVL%__LVL%,__KEY,"",__SCA)
			}
			Continue
		}
		;~ 解除区分#注释
		LoopField:=A_LoopField
		if InStr(A_LoopField,"#"){
			if (RegexMatch(A_LoopField,"^\s*#.*") || InStr(A_LoopField,"%YAML")=1)
				continue
			else if (RegExMatch(A_LoopField,"S)("".+""\s*:|'.+'\s*:|[^:""'\{\[]+\s*:)?\s*([\|\>][+-]?)?\s*(!!\w+\s)?\s*("".+|'.+)$")&&!RegExMatch(A_LoopField,"S)[^\\]""\s+#"))
				LoopField:=A_LoopField
			else if RegExMatch(A_LoopField,"S)\s+#.*$","",RegExMatch(A_LoopField,"S)(---)?\s*?(-\s)?("".+""\s*:|'.+'\s*:|[^:""'\{\[]+\s*:)?\s*([\|\>][+-]?)?\s*(!!\w+\s)?\s*("".+""|'.+')?\K")-1)
				LoopField:=SubStr(A_LoopField,1,RegExMatch(A_LoopField,"S)\s+#.*$","",RegExMatch(A_LoopField,"S)(---)?\s*?(-\s)?("".+""\s*:|'.+'\s*:|[^:""'\{\[]+\s*:)?\s*([\|\>][+-]?)?\s*(!!\w+\s)?\s*("".+""|'.+')?\K")-1)-1)
			else LoopField:=A_LoopField
		} else LoopField:=A_LoopField
		if (LoopField="---"){
			Loop % (maxLVL)
				LVL%A_Index%:=""
			Loop,Parse,BackupVars,`,
				__%A_LoopField%:="",__%A_LoopField%0:=""
			Loop,Parse,BackupVars,`,
				Loop % maxLVL
				__%A_LoopField%%A_Index%:=""
			maxLVL:=0
			__LVL:=0,__LVL0:=0
			if !IsObject(pYaml[""])
				pYaml[""]:=Object("base",base)
			pYaml[""].Insert(LVL0:=Object("base",base))
			Continue
		} else if (LoopField="..."){
			LVL0:=pYaml
			Loop % (maxLVL)
				LVL%A_Index%:=""
			Loop,Parse,BackupVars,`,
				__%A_LoopField%:="",__%A_LoopField%0:=""
			Loop,Parse,BackupVars,`,
				Loop % maxLVL
				__%A_LoopField%%A_Index%:=""
			maxLVL:=0
			__LVL:=0,__LVL0:=0
			Continue
		}
		;~ ^(?<LVL>\s+)?
		;~ (?<SEQ>-\s)?
		;~ (?<KEY>"".+""\s*:|'.+'\s*:|[^:""'\{\[]+\s*:)?
		;~ \s*(?<SCA>[\|\>][+-]?)?
		;~ \s*
		;~ (?<TYP>!!\w+\s)?
		;~ \s*
		;~ (?<VAL>"".+""|'.+'|.+)?
		;~ \s*$
		RegExMatch(LoopField,"S)^(?<LVL>\s+)?(?<SEQ>-\s)?(?<KEY>"".+""\s*:|'.+'\s*:|[^:""'\{\[]+\s*:)?\s*(?<SCA>[\|\>][+-]?)?\s*(?<TYP>!!\w+\s)?\s*(?<VAL>"".+""|'.+'|.+)?\s*$",_)
		if _KEY
			StringTrimRight,_KEY,_KEY,1
		_KEY:=Yaml_UnQuoteifNeed(_KEY)
		if (SubStr(_VAL,1,1)="'"&&SubStr(_VAL,0)="'")||(SubStr(_VAL,1,1)=""""&&SubStr(_VAL,0)="""")
			IsVal:=1
		else	IsVal:=0
		_VAL:=Yaml_UnQuoteifNeed(_VAL)
		_LVL:=Yaml_S2I(_LVL)
		if (_LVL-__LVL>1&&!(__SEQ&&__KEY!=""&&_KEY!=""))
			LVL%_LVL%:=LVL%_NXT% ,_LVL:=__LVL+1
		if (maxLVL<_LVL)
			maxLVL:=_LVL+(_SEQ?1:0)
		SubStr:=0,Tabs:=0
		Loop,Parse,LoopField
			if ((_LVL*2=SubStr) || !(SubStr:=SubStr+(A_LoopField=A_Tab?2:1))), Tabs:=Tabs+(A_LoopField=A_Tab?1:0)
				break
		_LFL:=SubStr(LoopField,SubStr-Tabs+1+(_SEQ?2:0))
		_LFL:=Yaml_UnQuoteifNeed(_LFL)
		_NXT:=_LVL+1
		__NXT:=_NXT+1
		_PRV:=_LVL=0?0:_LVL-1
		Loop,Parse,BackupVars,`,
			__%A_LoopField%:=__%A_LoopField%%_PRV%
		if RegExMatch(_LFL,"^-\s*$"){
			_SEQ:="-",_KEY:="",_VAL:=""
		}
		_CNT:=Yaml_Incomplete(Trim(_LFL))||Yaml_Incomplete(Trim(_VAL))
		if (_LVL<__LVL){
			Loop % (maxLVL)
				if (A_Index>_LVL){
					Loop,Parse,BackupVars,`,
						__%A_LoopField%%maxLVL%:=""
					LVL%A_Index%:="",maxLVL:=maxLVL-1
				}
			if (_LVL=0 && !(__LVL:=__LVL0:=0))
				Loop,Parse,BackupVars,`,
					__%A_LoopField%:="",__%A_LoopField%0:=""
		}
		if ((_SEQ&&_LVL>__LVL&&(__VAL!=""||__SCA)))
			_SEQ:="",_KEY:="",_VAL:="",_LFL:="- " _LFL
		if (__CNT)||(_LVL>__LVL&&(__KEY!=""&&_KEY="")&&(__VAL!=""||__SCA))||(__SEQ&&__SCA)
			_KEY:="",_VAL:=""
		if (__CNT||(_LVL>__LVL&&((__KEY!="")||(__SEQ&&(__LFL||__SCA)&&!Yaml_IsSeqMap(__LFL)))&&!(_SEQ||_KEY!=""))){
			if ((OBJ:=LVL%__LVL%[""].MaxIndex())&&IsObject(LVL%__LVL%["",OBJ])&&__SEQ){
				if __KEY!=
					Yaml_Continue(LVL%__LVL%["",Obj],__key,_LFL,__SCA),__CNT:=Yaml_SeqMap(LVL%__LVL%["",OBJ],__KEY,LVL%__LVL%["",OBJ,__KEY])?"":__CNT
				else Yaml_Continue(LVL%__LVL%[""],Obj,_LFL,__SCA,__SEQ),__CNT:=Yaml_SeqMap(LVL%__LVL%[""],OBJ,LVL%__LVL%["",OBJ],__SEQ)?"":__CNT
			} else if (__SEQ && OBJ){
				Yaml_Continue(LVL%__LVL%[""],Obj,_LFL,__SCA,__SEQ)
				__CNT:=Yaml_SeqMap(LVL%__LVL%[""],OBJ,LVL%__LVL%["",OBJ],__SEQ)?"":__CNT
			} else if (OBJ && __KEY=""){
				Yaml_Continue(LVL%__LVL%[""],OBJ,_LFL,__SCA,1)
				__CNT:=Yaml_SeqMap(LVL%__LVL%[""],OBJ,LVL%__LVL%["",OBJ],1)?"":__CNT
			} else {
				Yaml_Continue(LVL%__LVL%,__KEY,_LFL,__SCA)
				__CNT:=Yaml_SeqMap(LVL%__LVL%,__KEY,LVL%__LVL%[__KEY])?"":__CNT
			}
			Continue
		}
		if (__SEQ&&(_LVL>__LVL)&&_KEY!=""&&__KEY!=""){
			OBJ:=LVL%__LVL%[""].MaxIndex()
			if (_LVL-__LVL>1){
				if !Yaml_SeqMap(LVL%__LVL%["",OBJ],_KEY,_VAL)
					LVL%__LVL%["",OBJ,__KEY,_KEY]:=(_VAL!="")?_VAL:(LVL%_NXT%:=Object("base",base))
			} else if !Yaml_SeqMap(LVL%_LVL%["",OBJ],_KEY,_VAL)
				LVL%__LVL%["",OBJ,_KEY]:=_VAL!=""?_VAL:(LVL%_NXT%:=Object("base",base))
			if _VAL!=
				continue
		} else if (_SEQ){
			if !IsObject(LVL%_LVL%[""])
				LVL%_LVL%[""]:=Object("base",base)
			While (SubStr(_LFL,1,2)="- "){
				_LFL:=SubStr(_LFL,3),_KEY:=(_KEY!="")?_LFL:=SubStr(_KEY,3):_KEY,LVL%_LVL%[""].Insert(LVL%_NXT%:=Object("",Object("base",base),"base",base)),_LVL:=_LVL+1,_NXT:=_NXT+1,__NXT:=_NXT+1,_PRV:=_LVL-1,maxLVL:=(maxLVL<_LVL)?_LVL:maxLVL
				Loop,Parse,BackupVars,`,
					__%A_LoopField%:=_%A_LoopField%, __%A_LoopField%%_PRV%:=_%A_LoopField%
			}
			if (_KEY="" && _VAL="" && !IsVal){
				if !Yaml_SeqMap(LVL%_LVL%[""],"",_LFL)
					LVL%_LVL%[""].Insert(LVL%_NXT%:=Object("base",base))
			} else if (_KEY!="") {
				LVL%_LVL%[""].Insert(Object(_KEY,LVL%__NXT%:=LVL%_NXT%:=Object("base",base),"base",base))
				if !Yaml_SeqMap(LVL%__NXT%,_KEY,_VAL){
					LVL%_LVL%[""].Remove()
					LVL%_LVL%[""].Insert(Object(_KEY,(_VAL!=""||IsVal)?_VAL:LVL%__NXT%:=LVL%_NXT%:=Object("base",base),"base",base))
				}
			} else {
				if !Yaml_SeqMap(LVL%_LVL%[""],"",_LFL)
					LVL%_LVL%[""].Insert(_LFL)
			}
			if !LVL%_LVL%[""].MaxIndex()
				LVL%_LVL%.Remove("")
		} else if (_KEY!=""){
			if (__SEQ) {
				if (OBJ:=LVL%_PRV%[""].MaxIndex())&&IsObject(LVL%_PRV%["",OBJ]){
					if !Yaml_SeqMap(LVL%_PRV%["",OBJ],_KEY,_VAL)
						LVL%_PRV%["",OBJ,_KEY]:=(_VAL!=""||IsVal)?_VAL:(LVL%_NXT%:=Object("base",base))
				} else {
					LVL%_PRV%[""].Insert(Object(_KEY,(_VAL!=""||IsVal)?_VAL:(LVL%_NXT%:=Object("base",base)),"base",base))
					Yaml_SeqMap(LVL%_PRV%["",OBJ?OBJ+1:1],_KEY,_VAL)
				}
			} else
				{
				if !Yaml_SeqMap(LVL%_LVL%,_KEY,_VAL)
					LVL%_LVL%[_KEY]:=_VAL!=""?_VAL:(LVL%_NXT%:=Object("base",base))
				if "!!str "=_TYP	;~ 为!!Type修改
					LVL%_LVL%[_KEY]:=_VAL
				}
		} else if (_LVL>__LVL && (__KEY!="")) {
			if (__VAL!="" || __SCA){
				Yaml_Continue(LVL%__LVL%,__KEY,_LFL,__SCA)
				Yaml_SeqMap(LVL%__LVL%,__KEY,LVL%__LVL%[__KEY])
				Continue
			} else {
				if !Yaml_SeqMap(LVL%__LVL%[__KEY],_KEY,_VAL)
					LVL%__LVL%[__KEY,_KEY]:=_VAL
					Continue
			}
		} else {
			if (_LVL>__LVL&&(OBJ:=LVL%__LVL%[""].MaxIndex())&&IsObject(LVL%__LVL%["",OBJ])&&__SEQ){
				if __CNT
					Yaml_Continue(LVL%__LVL%[""],LVL%__LVL%[""].MaxIndex(),_LFL,__SCA,1)
				if (__CNT:=Yaml_SeqMap(LVL%__LVL%[""],"",_LFL)?"":1)
					LVL%__LVL%[""].Insert(_LFL)
			} else {
				if !IsObject(LVL%_LVL%[""])
					LVL%_LVL%[""]:=Object("base",base)
				if __CNT
					Yaml_Continue(LVL%__LVL%[""],LVL%__LVL%[""].MaxIndex(),_LFL,__SCA,1)
				if (__CNT:=Yaml_SeqMap(LVL%_LVL%[""],"",_LFL)?"":1)
					LVL%_LVL%[""].Insert(_LFL)
			}
			Continue
		}
		Loop,Parse,BackupVars,`,
			__%A_LoopField%:=_%A_LoopField%, __%A_LoopField%%_LVL%:=_%A_LoopField%
	}
	AutoTrim %AutoTrim%
	Return pYaml,pYaml.base:=base
}
Yaml_Save(obj,file,level=""){
	FileMove,% file,% file ".bakup.yml",1
	FileAppend,% obj.Dump(),% file
	if !ErrorLevel
		FileDelete,% file ".bakup.yml"
	else {
		FileMove,% file ".bakup.yml",% file
		MsgBox, 48, Yaml.ahk, 创建文件 %file% 出错，已还原原文件。
	}
}
Yaml_Call(NotSupported,f,p*){
	if (p.MaxIndex()>1){
		Loop % p.MaxIndex()
			if A_Index>1
				f:=f[""][p[A_Index-1]]
	}
	Return (!p.MaxIndex()?f[""].MaxIndex():f[""][p[p.MaxIndex()]])
}
Yaml_Merge(obj,merge){
	for k,v in merge
	{
		if IsObject(v){
			if obj.HasKey(k){
				if IsObject(obj[k])
					Yaml_Merge(obj[k],v)
				else obj[k]:=v
			} else obj[k]:=v
		} else obj[k]:=v
	}
}
Yaml_Add(O,Yaml="",IsFile=0){
	static base:=Object("Dump","Yaml_Dump","Save","Yaml_Save","Add","Yaml_Add","Merge","Yaml_Merge","Insert","Insert","Remove","Remove","__Delete","__Delete","MaxIndex","MaxIndex","_NewEnum","_NewEnum","Next","Next","GetAddress","GetAddress","SetCapacity","SetCapacity","GetCapacity","GetCapacity","Clone","Clone","HasKey","HasKey","base",Object("__Call","Yaml_Call"))
	if Yaml_IsSeqMap(Trim(Yaml)){
		if !IsObject(O[""])
			O[""]:=Object("base",base)
		Yaml_SeqMap(O[""],"",Yaml)
	} else Yaml(Yaml,IsFile,O)
}
Yaml_Dump(O,J="",R=0,Q=0){
	static M1:="{",M2:="}",S1:="[",S2:="]",N:="`n",C:=",",S:="- ",E:="",K:=": "
	if (J=0&&!R)
		dump.= S1
	for key in O
		M:=A_Index
	if IsObject(O[""]){
		M--
		for key in O[""]
			MX:=A_Index
		if IsObject(O[""][""])
			MX--
		if O[""].MaxIndex()
			for key, value in O[""]
			{
				if key=
					continue
				I++
				F:=IsObject(value)?(IsObject(value[""])?"S":"M"):E
				if (J!=""&&(J<=R)){
					dump.=(F?(%F%1 Yaml_Dump(value,J,R+1,F) %F%2):Yaml_EscifNeed(value)) (I=MX&&!M?E:C)
				} else if F,dump:=dump ((N Yaml_I2S(R))) S
					dump.= ((J!=""&&(J<=(R+1)))?%F%1:E) Yaml_Dump(value,J,R+1,F) ((J!=""&&(J<=(R+1)))?%F%2:E)
				else {
					if RegexMatch(value,"S)[\x{007E}-\x{FFFF}""#:\{\[']")
						dump .= """" Yaml_CharUni(value) """"
					else {
						value:= (value=""?"''":RegExReplace(RegExReplace(Value,"mS)^(.*[\r\n].*)$","|" (SubStr(value,-1)="`n`n"?"+":(SubStr(value,0)=N?"":"-")) "`n$1"),"ms)(*ANYCRLF)\R",N Yaml_I2S(R+1)))
						StringReplace,value,value,% N Yaml_I2S(R+1) N Yaml_I2S(R+1),% N Yaml_I2S(R+1),A
						dump.=value
					}
				}
			}
	}
	I=0
	for key, value in O
	{
		if key=
			continue
		I++
		F:=IsObject(value)?(IsObject(value[""])?"S":"M"):E
		if (J=0&&!R)
			dump.= M1
		if (J!=""&&(J<=R)){
			dump.=((Q="S"&&I=1?M1:E)(Yaml_EscifNeed(key) K))
			dump.=(F?(%F%1 Yaml_Dump(value,J,R+1,F) %F%2):Yaml_EscifNeed(value))
			dump.=(Q="S"&&I=M?M2:E) (J!=0||R?(I=M?E:C):E)
		} else if F,dump:=dump (N Yaml_I2S(R)) (Yaml_EscifNeed(key) K)
			dump.= ((J!=""&&(J<=(R+1)))?%F%1:E) Yaml_Dump(value,J,R+1,F) ((J!=""&&(J<=(R+1)))?%F%2:E)
		else {
			if RegexMatch(value,"S)[\x{007E}-\x{FFFF}""#:\{\[']")
				dump .= """" Yaml_CharUni(value) """"
			else {
				value:= (value=""?"''":RegExReplace(RegExReplace(Value,"mS)^(.*[\r\n].*)$","|" (SubStr(value,-1)="`n`n"?"+":(SubStr(value,0)="`n"?"":"-")) "`n$1"),"msS)(*ANYCRLF)\R","`n" Yaml_I2S(R+1)))	
				value := RegExReplace(value,"S).*\{.*\}.*|.*\[.*\].*","!!str " value)	;~ 为!!Type修改
				if instr(value,"#")
					value:="'" value "'"
				StringReplace,value,value,% "`n" Yaml_I2S(R+1) "`n" Yaml_I2S(R+1),% "`n" Yaml_I2S(R+1),A
				dump.= value
			}
		}
		if (J=0&&!R){
			dump.=M2 (I<M?C:E)
		}
	}
	if (J=0&&!R)
		dump.=S2
	if (R=0)
		dump:=RegExReplace(dump,"S)^\R+")
	Return dump
}
Yaml_UniChar( string ) {
	static a:="`a",b:="`b",t:="`t",n:="`n",v:="`v",f:="`f",r:="`r",e:=Chr(0x1B)
	Loop,Parse,string,\
	{
		if (A_Index=1){
			var.=A_LoopField
			continue
		} else if lastempty {
			var.="\" A_LoopField
			lastempty:=0
			Continue
		} else if (A_LoopField=""){
			lastempty:=1
			Continue
		}
		if InStr("ux",SubStr(A_LoopField,1,1))
			str:=SubStr(A_LoopField,1,RegExMatch(A_LoopField,"S)^[ux]?([\dA-F]{4})?([\dA-F]{2})?\K")-1)
		else
			str:=SubStr(A_LoopField,1,1)
		if (str=="N")
			str:="\x85"
		else if (str=="P")
			str:="\x2029"
		else if (str=0)
			str:="\x0"
		else if (str=="L")
			str:="\x2028"
		else if (str=="_")
			str:="\xA0"
		if RegexMatch(str,"iS)^[ux][\da-f]+$")
			var.=Chr(Abs("0x" SubStr(str,2)))
		else if str in a,b,t,n,v,f,r,e
			var.=%str%
		else var.=str
		if InStr("ux",SubStr(A_LoopField,1,1))
			var.=SubStr(A_LoopField,RegExMatch(A_LoopField,"S)^[ux]?([\dA-F]{4})?([\dA-F]{2})?\K"))
		else var.=SubStr(A_LoopField,2)
	}
	return var
}
Yaml_CharUni( string ) {
	static ascii:={"\":"\","`a": "a","`b": "b","`t": "t","`n": "n","`v": "v","`f": "f","`r": "r",Chr(0x1B): "e","""": """",Chr(0x85): "N",Chr(0x2029): "P",Chr(0x2028): "L","": "0",Chr(0xA0): "_"}
	if !RegexMatch(string,"S)[\x{007E}-\x{FFFF}]"){
		Loop,Parse,string
		{
			if ascii[A_LoopField]
				var.="\" ascii[A_LoopField]
			else
				var.=A_LoopField
		}
		return var
	}
	format:=A_FormatInteger
	SetFormat,Integer,H
	Loop,Parse,string
	{
		if ascii[A_LoopField]
			var.="\" ascii[A_LoopField]
		else if Asc(A_LoopField)<128
			var.=A_LoopField
		else	var.="\u" SubStr("0000" SubStr(Asc(A_LoopField),3),-3)
	}
	SetFormat,Integer,%Format%
	return var
}
Yaml_EscifNeed(s){
	if s=
		return "''"
	else if RegExMatch(s,"mS)[\{\[""'\r\n:,#]")||RegExMatch(s,"m)^\s")||RegExMatch(s,"mS)\s$")||RegExMatch(s,"mS)[\x{7F}-\x{7FFFFFFF}]"){
		return ("""" . Yaml_CharUni(s) . """")
	} else return s
}
Yaml_UnQuoteifNeed(s){
	s:=Trim(s)
	if !(SubStr(s,1,1)=""""&&SubStr(s,0)="""")
		return (SubStr(s,1,1)="'"&&SubStr(s,0)="'")?SubStr(s,2,-1):s
	else return Yaml_UniChar(SubStr(s,2,-1))
}
Yaml_S2I(str){
	idx:=0
	Loop,Parse,str
		if (A_LoopField=A_Tab) || !Mod(A_index,2)
			idx++
	Return idx
}
Yaml_I2S(idx){
	Loop % idx
		str .= "  "
	Return str
}
Yaml_Continue(Obj,key,value,scalar="",isval=0){
	if !IsObject(isObj:=obj[key])
		v:=IsObject(isObj)?"":isObj
	if scalar {
		StringTrimLeft,scaopt,scalar,1
		scalar:=Asc(scalar)=124?"`n":" "
	} else scalar:=" ",scaopt:="-"
	temp := ((value="")?"`n":((SubStr(v,0)="`n"&&scalar="`n")?"":(v=""?"":scalar))) value (scaopt!="-"?(value=""?"`n":""):(""))
	obj[key]:=Yaml_UnQuoteifNeed(v temp)
}
Yaml_Quote(ByRef L,F,Q,B,ByRef E){
	Return (F="\"&&!E&&(E:=1))||(E&&!(E:=0)&&(L:=L ("\" F)))
}
Yaml_SeqMap(o,k,v,isVal=0){
	v:=Trim(v,A_Tab A_Space "`n"),m:=SubStr(v,1,1) SubStr(v,0)
	if Yaml_IsSeqMap(v)
		return m="[]"?Yaml_Seq(o,k,SubStr(v,2,-1),isVal):m="{}"?Yaml_Map(o,k,SubStr(v,2,-1),isVal):0
}
Yaml_Seq(obj,key,value,isVal=0){
	static base:=Object("Dump","Yaml_Dump","Save","Yaml_Save","Add","Yaml_Add","Merge","Yaml_Merge","Insert","Insert","Remove","Remove","__Delete","__Delete","MaxIndex","MaxIndex","_NewEnum","_NewEnum","Next","Next","GetAddress","GetAddress","SetCapacity","SetCapacity","GetCapacity","GetCapacity","Clone","Clone","HasKey","HasKey","base",Object("__Call","Yaml_Call"))
	if (obj=""){
		if (SubStr(value,0)!="]")
			Return 0
		else	value:=SubStr(value,2,-1)
	} else {
		if (key=""){
			obj.Insert(Object("",cObj:=Object("base",base),"base",base))
		} else if (isval && IsObject(obj[key,""])){
			cObj:=obj[key,""]
		} else obj[key]:=Object("",cObj:=Object("base",base),"base",base)
	}
	Count:=StrLen(value)
	Loop,Parse,value
	{
		if (Quote=""""&&Yaml_Quote(LF,A_LoopField,Quote,Bracket,Escape))
			Continue
		if (Quote){
			if (A_LoopField=Quote){
				Quote=
				if Bracket
					LF.= A_LoopField
				else LF:=SubStr(LF,2)
				Continue
			}
			LF .= A_LoopField
			continue
		} else if (!Quote&&InStr("""'",A_LoopField)){
			Quote:=A_LoopField
			if !Bracket
				VQ:=Quote
			LF.=A_LoopField
			Continue
		} else if (!Quote&&Bracket){
			if (Asc(A_LoopField)=Asc(Bracket)+2)
				BCount--
			else if (A_LoopField=Bracket)
				BCount++
			if (BCount=0)
				Bracket=
			LF .= A_LoopField
			Continue
		} else if (!Quote&&!Bracket&&InStr("[{",A_LoopField)){
			Bracket:=A_LoopField
			BCount=1
			LF.=A_LoopField
			Continue
		}
		if (A_Index=Count)
			LF .= A_LoopField
		else if (!Quote&&!Bracket&&A_LoopField=",")
			LF:=LF
		else {
			LF .= A_LoopField
			continue
		}
		if (obj=""){
			if !VQ && ((Asc(LF)=91 && !Yaml_Seq("","",LF))||(Asc(LF)=123 && !Yaml_Map("","",LF)))
				Return 0
		} else {
			if (VQ || !Yaml_SeqMap(cObj,"",LF))
				cObj.Insert(VQ?Yaml_UniChar(LF):Trim(LF))
		}
		LF:="",VQ:=""
	}
	if (LF){
		if (obj=""){
			if !VQ && ((Asc(LF)=91 && !Yaml_Seq("","",LF))||(Asc(LF)=123 && !Yaml_Map("","",LF)))
				Return 0
		} else if (VQ || !Yaml_SeqMap(cObj,"",LF))
			cObj.Insert(VQ?Yaml_UniChar(LF):Trim(LF))
	}
	Return (obj=""?(Quote Bracket=""):1)
}
Yaml_Map(obj,key,value,isVal=0){
	static base:=Object("Dump","Yaml_Dump","Save","Yaml_Save","Add","Yaml_Add","Merge","Yaml_Merge","Insert","Insert","Remove","Remove","__Delete","__Delete","MaxIndex","MaxIndex","_NewEnum","_NewEnum","Next","Next","GetAddress","GetAddress","SetCapacity","SetCapacity","GetCapacity","GetCapacity","Clone","Clone","HasKey","HasKey","base",Object("__Call","Yaml_Call"))
	if (obj=""){
		if (SubStr(value,0)!="}")
			Return 0
		else
			value:=SubStr(value,2,-1)
	} else {
		if (key="")
			obj.Insert(cObj:=Object("base",base))
		else obj[key]:=(cObj:=Object("base",base))
	}
	Count:=StrLen(value)
	Loop,Parse,value
	{
		if (Quote=""""&&Yaml_Quote(LF,A_LoopField,Quote,Bracket,Escape))
			Continue
		if (Quote){
			if (A_LoopField=Quote){
				Quote=
				LF.=A_LoopField
			} else LF .= A_LoopField
			continue
		} else if (!Quote&&(k=""||v="")&&InStr("""'",A_LoopField)){
			Quote:=A_LoopField
			if (k && !Bracket)
				VQ:=Quote
			else if !Bracket
				KQ:=Quote
			LF.=Quote
			Continue
		} else if (k!=""&&LF=""&&InStr("`n`r `t",A_LoopField)){
			Continue
		}
		if (!Quote&&Bracket){
			if (Asc(A_LoopField)=Asc(Bracket)+2)
				BCount--
			else if (A_LoopField=Bracket)
				BCount++
			if (BCount=0)
				Bracket=
			LF .= A_LoopField
			Continue
		} else if (!Quote&&!Bracket&&InStr("[{",A_LoopField)){
			Bracket:=A_LoopField
			BCount=1
			LF.=A_LoopField
			Continue
		}
		if (A_Index=Count&&k!=""){
			v:=LF A_LoopField
			v:=Trim(v)
			if (InStr("""'",SubStr(v,0))&&SubStr(v,1,1)=SubStr(v,0))
				v:=SubStr(v,2,-1)
		} else if (!Quote&&!Bracket&&k!=""&&A_LoopField=","){
			LF:=Trim(LF)
			if VQ
				LF:=SubStr(LF,2,-1)
			v:=LF,LF:=""
		} else if (!Quote&&!Bracket&&k=""&&A_LoopField=":"){
			LF:=Trim(LF)
			if (InStr("""'",SubStr(LF,0))&&SubStr(LF,1,1)=SubStr(LF,0))
				LF:=SubStr(LF,2,-1)
			k:=LF,LF:=""
			continue
		} else {
			LF .= A_LoopField
			continue
		}
		if (obj=""){
			if VQ=
				if (Asc(v)=91 && !Yaml_Seq("","",v))||(Asc(v)=123 && !Yaml_Map("","",v))
					Return 0
		} else {
			if (VQ || !Yaml_SeqMap(cObj,k,v))
				cObj[KQ?Yaml_UniChar(k):k]:=(VQ?Yaml_UniChar(v):Trim(v))
		}
		k:="",v:="",VQ:="",KQ:=""
	}
	if (k){
		if (obj=""){
			if (Asc(LF)=91 && !Yaml_Seq("","",LF))||(Asc(LF)=123 && !Yaml_Map("","",LF))
				Return 0
		} else {
			LF:=Trim(LF)
			if (VQ)
				LF:=SubStr(LF,2,-1),cObj[k]:=Yaml_UniChar(LF)
			else if (!Yaml_SeqMap(cObj,k,LF))
				cObj[k]:=Trim(LF)
		}
	}
	Return (obj=""?(Quote Bracket=""):1)
}
Yaml_Incomplete(value){
	if (Asc(Trim(value,"`n" A_Tab A_Space))=91 && !Yaml_Seq("","",Trim(value,"`n" A_Tab A_Space)))
	|| (Asc(Trim(value,"`n" A_Tab A_Space))=123 && !Yaml_Map("","",Trim(value,"`n" A_Tab A_Space)))
		Return 1
}
Yaml_IsSeqMap(value){
	if (Asc(Trim(value,"`n" A_Tab A_Space))=91 && Yaml_Seq("","",Trim(value,"`n" A_Tab A_Space)))
	|| (Asc(Trim(value,"`n" A_Tab A_Space))=123 && Yaml_Map("","",Trim(value,"`n" A_Tab A_Space)))
		Return 1
}
