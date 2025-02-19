ElmaFolder = d:\Games\ElmaOFFline_videomaking_2160p\
WinElmaName = Elasto Mania
ElmaFile = eol.exe
WinDXWindowerName = D3DWindower v1.88
DXWindowerFile = D3DWindower.exe
IfWinNotExist, %WinElmaName% 
{
    IfWinNotExist, %WinDXWindowerName% 
        Run, %DXWindowerFile%, %ElmaFolder% ; Start D3DWindower
    else
        WinActivate
    WinWaitActive, %WinDXWindowerName%

MouseClick, L, 133, 88
MouseClick, L, 133, 88

Sleep, 1000

tt = Elasto Mania ahk_class Elasto Mania
WinWait, %tt%
IfWinNotActive, %tt%,, WinActivate, %tt%

Sleep, 1000

Send, {Space}
Sleep, 1000
Send, {Enter}
Sleep, 1000
Send, {Down}
Sleep, 1000
Send, {Enter}
Sleep, 2000
Send, {Down}
Sleep, 1000

;RENDER
Send, {F1 down}
Sleep, 1000
Send, {Enter down}
Sleep, 1000
Send {Enter up}
Sleep, 1000
Send {F1 up}
Sleep, 1000





;check for snp*.pcx files
;close eol if no new screenshot in last 10s


Result := 1
While Result
{
loop, %ElmaFolder%\snp*.pcx
    Number := A_Index
sleep, 5000
loop, %ElmaFolder%\snp*.pcx
    Number2 := A_Index
Result := Number2 - Number
}
	;RControl::           ;quit elma
	{
	Process, Close, eol.exe
	Process, Close, D3DWindower.exe
	ExitApp
	}
    return
ExitApp
} else {
    WinActivate
    WinWaitActive, %WinElmaName%
    Loop 5 {
        Send {Esc down} 
        Sleep, 10
        Send {Esc up}
        Sleep, 10
    }
    Send {Enter down}
    Sleep, 10
    Send {Enter up}
    Sleep, 300
    Send {Space down}
    Sleep, 10
    Send {Space up}
    IfWinExist, %WinDXWindowerName%
        WinKill
    return
}