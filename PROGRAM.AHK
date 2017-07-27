#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include file\Functionscript.ahk
#include COM_L.ahk
#include IE_Macro_By_Tag_L.ahk
GUI,Color,White
Gui, Add, GroupBox, x12 y0 w170 h90 , 로그인
Gui, Add, Text, x22 y20 w30 h20 , ID:
Gui, Add, Edit, x52 y20 w120 h20 vID, 
Gui, Add, Text, x22 y50 w30 h20 , PW:
Gui, Add, Edit, x52 y50 w120 h20 +Password* vPW, 
Gui, Add, GroupBox, x12 y100 w340 h330 , 카페
Gui, Add, ListBox, x22 y120 w320 h310 v카페박스 g카페박스, 카페
Gui, Add, GroupBox, x352 y100 w260 h330 , 카테고리
Gui, Add, ListBox, x362 y120 w240 h310 v카테고리박스 g카테고리박스, 카테고리
Gui, Add, GroupBox, x612 y100 w290 h330 , 게시글
Gui, Add, ListBox, x622 y120 w270 h310 v게시글박스, 게시글
Gui, Add, Button, x192 y10 w100 h30 g로그인, 로그인
Gui, Add, Button, x192 y60 w100 h30 , 카페새로고침
Gui, Add, GroupBox, x312 y0 w170 h90 , 통계
Gui, Add, Text, x322 y20 w110 h20 v글쓴횟수, 글쓴횟수:
Gui, Add, Text, x322 y60 w110 h20 , 카페가입수:
Gui, Add, Text, x502 y20 w130 h60 v현재상태, ◆대기중◆
Gui, Add, GroupBox, x492 y0 w150 h90 , 현재상태
Gui, Add, GroupBox, x12 y439 w190 h200 , 설정
Gui, Add, Radio, x22 y460 w170 h20 v일반, 일반형식으로올리기
Gui, Add, Radio, x22 y490 w170 h20 vHTML, HTML형식으로올리기
Gui, Add, Text, x22 y520 w50 h20 , DELAY:
Gui, Add, Edit, x72 y520 w100 h20 vdelay, 1
Gui, Add, Text, x172 y520 w20 h20 , 초
Gui, Add, CheckBox, x22 y550 w170 h20 v모두, 모든 카페 글쓰기
Gui, Add, GroupBox, x212 y440 w350 h260 , 글양식
Gui, Add, Text, x222 y460 w30 h20 , 제목:
Gui, Add, Edit, x252 y460 w300 h20 v제목, 
Gui, Add, Text, x222 y490 w30 h20 , 내용:
Gui, Add, Edit, x222 y510 w330 h180 v내용, 
Gui, Add, Text, x662 y50 w-830 h960 , 이름:
Gui, Add, Button, x22 y649 w180 h50 g글올리기, 글올리기
Gui, Add, CheckBox, x22 y579 w170 h20 v웹띄우기, 글 올린거 웹 띄우기
Gui, Add, Text, x652 y39 w270 h20 hwnd설명, PLORENCE가 개발하였습니다.
; Generated using SmartGUI Creator 4.0
Gui, Show, w939 h720, 자동 네이버 카페 글쓰기

IniRead, PW,set.ini, 로그인,PW
GuiControl,,PW,%PW%
IniRead, ID,set.ini, 로그인 ,ID
GuiControl,,ID,%ID%
IniRead, 일반,set.ini, 설정,일반
GuiControl,,일반,%일반%
IniRead, HTML,set.ini, 설정 ,HTML
GuiControl,,HTML,%HTML%
IniRead, delay,set.ini, 설정 ,delay
GuiControl,,delay,%delay%
IniRead, 제목,set.ini, 설정 ,제목
GuiControl,,제목,%제목%
IniRead, 내용,set.ini, 설정 ,내용
GuiControl,,내용,%내용%
IniRead, 모두,set.ini, 설정 ,모두
GuiControl,,모두,%모두%
CtlColors.Attach(설명, "42a5f5","ffffff")
return
로그인:
Gui,submit,nohide
IniWrite, %ID%,  set.ini,  로그인,ID
IniWrite, %PW%,  set.ini,  로그인,PW
IniWrite, %일반%,  set.ini,  설정,일반
IniWrite, %HTML%,  set.ini,  설정,HTML
IniWrite, %delay%,  set.ini,  설정,delay
IniWrite, %제목%,  set.ini,  설정,제목
IniWrite, %내용%,  set.ini,  설정,내용
IniWrite, %모두%,  set.ini,  설정,모두
if ( id = "ERROR" || id = "")
{ msgbox,,, ID를 입력하세요,10
  return
}
if ( PW = "ERROR" || PW = "")
{ msgbox,,, 비밀번호를 입력하세요,10
  return
}
if (Naver_Login(ID,PW) = true)
 GuiControl,,현재상태,◆로그인성공!!◆
else
 GuiControl,,현재상태,◆로그인실패!!◆
sendmessage,0x184,,,listbox1, % title 
count = 1
cafeURL := "http://section.cafe.naver.com/JoinCafeList.nhn?search.groupid=0&search.sortby=group&search.page=" count
Winhttp.Open("GET",cafeURL)
Winhttp.Send()
Winhttp.WaitForResponse
txt_str := Winhttp.Responsetext
txt_str := RegExReplace(txt_str,"\s","") ;띄어쓰기없애줌
Loop
{
RegExMatch(txt_str,"<tdclass=\Ctit\C>(.*?)</p>",cafestate)
RegExMatch(cafestate1,"title=\C(.*?)\Cclass",cafe_name) ;카페링크
GuiControl,,카페박스,%cafe_name1%
StringReplace,txt_str,txt_str,%cafestate%,+ ;찾은문자열은 +로 치환

IfNotInString,txt_str,<tdclass=`"tit
{
 count++
 url11 := "/JoinCafeList.nhn?search.groupid=0&search.sortby=group&search.page=" count
 IfNotInString,txt_str,%url11%
{
 break
}
 cafeURL := "http://section.cafe.naver.com/JoinCafeList.nhn?search.groupid=0&search.sortby=group&search.page=" count
 Winhttp.Open("GET",cafeURL)
Winhttp.Send()
Winhttp.WaitForResponse
txt_str := Winhttp.Responsetext
txt_str := RegExReplace(txt_str,"\s","") ;띄어쓰기없애줌
}
}
 GuiControl,,현재상태,◆카페목록 로딩완료◆
;URLDownloadToFile,http://cafe.naver.com/ArticleList.nhn?search.clubid=26702907&search.menuid=1&search.boardtype=L,navercafe.txt
return

카페박스:
 GuiControl,,현재상태,◆선택한 카페 카테고리 리스트 불러오기 시작◆
sendmessage,0x184,,,listbox2, % title 
controlget, getITEM, choice,, listbox1, % title
count = 1
cafeURL := "http://section.cafe.naver.com/JoinCafeList.nhn?search.groupid=0&search.sortby=group&search.page=" count
Winhttp.Open("GET",cafeURL)
Winhttp.Send()
Winhttp.WaitForResponse
txt_str := Winhttp.Responsetext
txt_str := RegExReplace(txt_str,"\s","") ;띄어쓰기없애줌
Loop
{
RegExMatch(txt_str,"<tdclass=\Ctit\C>(.*?)</p>",cafestate)
IfInString,cafestate1,%getITEM%
{
 RegExMatch(cafestate1,"<ahref=\C(.*?)\Ctarget",cafe_link) ;카페링크
 PostMessage, 0x185, 0, -1, ListBox1  ; Deselect all items.
 break
}
else{
;없으면 찾은문자열은 +로 치환
StringReplace,txt_str,txt_str,%cafestate%,+ ;찾은문자열은 +로 치환
}
IfNotInString,txt_str,<tdclass=`"tit
{
 count++
 cafeURL := "http://section.cafe.naver.com/JoinCafeList.nhn?search.groupid=0&search.sortby=group&search.page=" count
 Winhttp.Open("GET",cafeURL)
Winhttp.Send()
Winhttp.WaitForResponse
txt_str := Winhttp.Responsetext
txt_str := RegExReplace(txt_str,"\s","") ;띄어쓰기없애줌
}
}


URLDownloadToFile,%cafe_link1%,navercafe.txt
FileRead,string,navercafe.txt
FileDelete,navercafe.txt
Loop
{
RegExMatch(string,"id=\CmenuLink\w\w\C>(.*?)</a>",cafe_category)
if(cafe_category1 = ""){
 break
}
GuiControl,,카테고리박스,%cafe_category1%
;없으면 찾은문자열은 +로 치환
StringReplace,string,string,%cafe_category%,+ ;찾은문자열은 +로 치환
}
URLDownloadToFile,%cafe_link1%,navercafe.txt
FileRead,string,navercafe.txt
FileDelete,navercafe.txt
Loop
{
RegExMatch(string,"id=\CmenuLink\w\C>(.*?)</a>",cafe_category)
if(cafe_category1 = ""){
 break
}
GuiControl,,카테고리박스,%cafe_category1%
;없으면 찾은문자열은 +로 치환
StringReplace,string,string,%cafe_category%,+ ;찾은문자열은 +로 치환
}

URLDownloadToFile,%cafe_link1%,navercafe.txt
FileRead,string,navercafe.txt
FileDelete,navercafe.txt
Loop
{
RegExMatch(string,"id=\CmenuLink\w\w\w\C>(.*?)</a>",cafe_category)
if(cafe_category1 = ""){
 break
}
GuiControl,,카테고리박스,%cafe_category1%
;없으면 찾은문자열은 +로 치환
StringReplace,string,string,%cafe_category%,+ ;찾은문자열은 +로 치환
}

 GuiControl,,현재상태,◆선택한 카페 카테고리 리스트 불러오기 완료◆
return

카테고리박스:
 GuiControl,,현재상태,◆선택한 카테고리 게시글 불러오기 시작◆
sendmessage,0x184,,,listbox3, % title 
controlget, getITEM, choice,, listbox2, % title
URLDownloadToFile,%cafe_link1%,navercafe.txt
FileRead,txt_str,navercafe.txt
FileDelete,navercafe.txt

;txt_str := RegExReplace(txt_str,"\s","")
Loop{
RegExMatch(txt_str,"<li><img src=\Chttp://cafeimgs.naver.net/cafe4/hidden.gif\C(.*?)</a>",categorystate)
IfInString,categorystate1,%getITEM%
{
 RegExMatch(categorystate1,"<a href=\C(.*?)\C target",category_link) ;카테고리 링크
 PostMessage, 0x185, 0, -1, ListBox2  ; 아이템 체크 헤제
 break
}
else{
;없으면 찾은문자열은 +로 치환
StringReplace,txt_str,txt_str,%categorystate%,+ ;찾은문자열은 +로 치환
}
}
URL := "http://cafe.naver.com" category_link1
URLDownloadToFile,%URL%,aaaa.txt
FileRead,note_link,aaaa.txt
FileDelete,aaaa.txt
Loop
{
 RegExMatch(note_link,"onmouseover=\C\C class=\Cm-tcol-c\C>(.*?)</a>",note_name) ;게시글 제목 긁어오기
 GuiControl,,게시글박스,%note_name1%
 if(note_name1 =""){
  break
 }
 StringReplace,note_link,note_link,%note_name%,+
}
 GuiControl,,현재상태,◆선택한 카테고리 게시글 불러오기 완료◆

pwb := COM_CreateObject("InternetExplorer.Application") 
pwb.Navigate("https://nid.naver.com/nidlogin.login?url=https%3A%2F%2Fwww.naver.com") 
if IE_Loading_Check(pwb) 
;로그인 정보 입력
네이버아이디=%id%
네이버비밀번호=%pw%
; ! 로그인 정보 입력
method=value 
method_value=%네이버아이디% 
method_usage_type:=1 
tag_type=INPUT 
tag_option_name=name 
tag_option_value=id 
tag_search_count:=1 
tag_search_Exact:=1 
;frame=IFRAME=loginframe 
IE_Macro( pwb , method , method_value , method_usage_type , tag_type , tag_option_name, tag_option_value , tag_search_count, tag_search_Exact , frame)
method=value 
method_value=%네이버비밀번호% 
method_usage_type:=1 
tag_type=INPUT 
tag_option_name=name 
tag_option_value=pw 
tag_search_count:=1 
tag_search_Exact:=1 
;frame=IFRAME=loginframe 
IE_Macro( pwb , method , method_value , method_usage_type , tag_type , tag_option_name, tag_option_value , tag_search_count, tag_search_Exact , frame)

method=click() 
method_value= 
method_usage_type:=1 
tag_type=INPUT 
tag_option_name=title 
tag_option_value=로그인
tag_search_count:=1 
tag_search_Exact:=1
;frame=IFRAME=loginframe 
IE_Macro( pwb , method , method_value , method_usage_type , tag_type , tag_option_name, tag_option_value , tag_search_count, tag_search_Exact , frame)
if IE_Loading_Check(pwb) 
sleep,500

GuiControl,,현재상태,◆네이버 로그인 완료◆


pwb.Navigate(URL)
if IE_Loading_Check(pwb) 
sleep,1000

GuiControl,,현재상태,◆해당 카페로 이동◆
 ;:= b := a.document.documentElement.innerHTML
a := pwb.document.getElementById("cafe_main").contentWindow.document.documentElement.innerHTML
IfNotInString,a,btn _rosRestrict
{
 msgbox,글쓰기가 불가능한 카테고리입니다.
return
}
else{
 msgbox,글쓰기가 가능한 카테고리입니다.
}
return

F1::
글올리기:
Gui,submit,nohide
 GuiControl,,현재상태,◆글올리기 시작◆
IniWrite, %ID%,  set.ini,  로그인,ID
IniWrite, %PW%,  set.ini,  로그인,PW
IniWrite, %일반%,  set.ini,  설정,일반
IniWrite, %HTML%,  set.ini,  설정,HTML
IniWrite, %delay%,  set.ini,  설정,delay
IniWrite, %제목%,  set.ini,  설정,제목
IniWrite, %내용%,  set.ini,  설정,내용
IniWrite, %모두%,  set.ini,  설정,모두
pwb := COM_CreateObject("InternetExplorer.Application") 
pwb.Navigate("https://nid.naver.com/nidlogin.login?url=https%3A%2F%2Fwww.naver.com") 
if IE_Loading_Check(pwb) 
;로그인 정보 입력
네이버아이디=%id%
네이버비밀번호=%pw%
; ! 로그인 정보 입력
method=value 
method_value=%네이버아이디% 
method_usage_type:=1 
tag_type=INPUT 
tag_option_name=name 
tag_option_value=id 
tag_search_count:=1 
tag_search_Exact:=1 
;frame=IFRAME=loginframe 
IE_Macro( pwb , method , method_value , method_usage_type , tag_type , tag_option_name, tag_option_value , tag_search_count, tag_search_Exact , frame)
method=value 
method_value=%네이버비밀번호% 
method_usage_type:=1 
tag_type=INPUT 
tag_option_name=name 
tag_option_value=pw 
tag_search_count:=1 
tag_search_Exact:=1 
;frame=IFRAME=loginframe 
IE_Macro( pwb , method , method_value , method_usage_type , tag_type , tag_option_name, tag_option_value , tag_search_count, tag_search_Exact , frame)

method=click() 
method_value= 
method_usage_type:=1 
tag_type=INPUT 
tag_option_name=title 
tag_option_value=로그인
tag_search_count:=1 
tag_search_Exact:=1
;frame=IFRAME=loginframe 
IE_Macro( pwb , method , method_value , method_usage_type , tag_type , tag_option_name, tag_option_value , tag_search_count, tag_search_Exact , frame)
if IE_Loading_Check(pwb) 
sleep,500

GuiControl,,현재상태,◆네이버 로그인 완료◆


pwb.Navigate(URL)
if IE_Loading_Check(pwb) 
sleep,1000

GuiControl,,현재상태,◆해당 카페로 이동◆
 ;:= b := a.document.documentElement.innerHTML
a := pwb.document.getElementById("cafe_main").contentWindow.document.documentElement.innerHTML
IfNotInString,a,btn _rosRestrict
{
 msgbox,글쓰기가 불가능한 카테고리입니다.
return
}


method=click() 
method_value= 
method_usage_type:=1 
tag_type=img
tag_option_name=src
tag_option_value=http://cafeimgs.naver.net/cafe4/ico-btn-write.gif
tag_search_count:=1
tag_search_Exact:=1
frame=IFRAME=cafe_main
IE_Macro( pwb , method , method_value , method_usage_type , tag_type , tag_option_name, tag_option_value , tag_search_count, tag_search_Exact , frame)
if IE_Loading_Check(pwb) 
sleep,500

GuiControl,,현재상태,◆해당 카페 카테고리 글쓰기 버튼 클릭◆

method=value
method_value= %제목%
method_usage_type:=1 
tag_type=INPUT
tag_option_name=name
tag_option_value=subject
tag_search_count:=1
tag_search_Exact:=1
frame=IFRAME=cafe_main
a := IE_Macro( pwb , method , method_value , method_usage_type , tag_type , tag_option_name, tag_option_value , tag_search_count, tag_search_Exact , frame)
if IE_Loading_Check(pwb) 
sleep,500

GuiControl,,현재상태,◆제목 입력◆

if(HTML = 1){
method=checked
method_value=true
method_usage_type:=1 
tag_type=INPUT
tag_option_name=id
tag_option_value=elHtmlMode
tag_search_count:=1
tag_search_Exact:=1
frame=IFRAME=cafe_main
a := IE_Macro( pwb , method , method_value , method_usage_type , tag_type , tag_option_name, tag_option_value , tag_search_count, tag_search_Exact , frame)
GuiControl,,현재상태,◆HTML로 입력 체크 완료◆
}
Data := 내용
pwb.document.querySelectorAll("iframe[id='cafe_main']")[0].contentWindow.document.querySelectorAll("iframe[src='/common/editor/default.html']")[0].contentWindow.document.querySelectorAll("body")[0].innerHTML := Data
if IE_Loading_Check(pwb) 
sleep,500

GuiControl,,현재상태,◆내용 입력◆

method=click() 
method_value= 
method_usage_type:=1 
tag_type=img
tag_option_name=id
tag_option_value=cafewritebtn
tag_search_count:=1 
tag_search_Exact:=1
frame=IFRAME=cafe_main
IE_Macro( pwb , method , method_value , method_usage_type , tag_type , tag_option_name, tag_option_value , tag_search_count, tag_search_Exact , frame)
if IE_Loading_Check(pwb) 
sleep,500

GuiControl,,현재상태,◆게시글 업로드 완료◆
if(웹띄우기 = 1){
 GuiControl,,현재상태,◆웹 띄우는걸 체크하였으므로 해당 게시글을 띄웁니다.◆
pwb.Visible := true
}
return


F11::
Reload
return

F12::
GuiClose:
ExitApp
return

Naver_Login(user_id, user_pw)
{
 global Winhttp
FileEncoding, UTF-8
id := user_id
pw := user_pw
;// ScriptControl
sc :=  ComObjCreate("ScriptControl")
sc.Language := "JavaScript" ;// 자바스크립트
FileRead, js_script, %A_ScriptDir%\rsa_lib.txt
sc.reset
sc.AddCode(js_script)
;// WinHttpRequest
Winhttp :=  ComObjCreate("WinHttp.WinHttpRequest.5.1")
Winhttp.Open("GET","http://static.nid.naver.com/enclogin/keys.nhn")
Winhttp.Send
SendKey := StrSplit(Winhttp.responsetext, "`,")
;// .= 연산자는 누적
vData =
vData .= "enctp=1"
vData .= "&encpw=" . sc.run("createRsaKey", Id, pw, SendKey[1], SendKey[2], SendKey[3], SendKey[4]) 
vData .= "&encnm=" . SendKey[2]
vData .= "&svctype=" . "0"
vData .= "&id="
vData .= "&pw="
vData .= "&x=" . "35"
HeaderString .= "&y=" . "14"
Winhttp.Open("POST","https://nid.naver.com/nidlogin.login")
Winhttp.SetRequestHeader("Referer","http://static.nid.naver.com/login.nhn?svc=wme&amp;url=http%3A%2F%2Fwww.naver.com&amp;t=20120425")
Winhttp.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
Winhttp.Send(vData)
Winhttp.WaitForResponse
txt_str := Winhttp.Responsetext
IfInString, txt_str, /sso/
 return true
else
 return false
}
return
