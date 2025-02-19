; Double-Tap RControl to Open/Close Elma

ElmaFolder = d:\Games\ElmaOFFline_videomaking_2160p\
WinElmaName = Elasto Mania
ElmaFile = eol.exe
WinDXWindowerName = D3DWindower v1.88
DXWindowerFile = D3DWindower.exe

IfWinNotExist, %WinElmaName% 
{
    IfWinNotExist, %WinDXWindowerName% 
        Run, %DXWindowerFile%, %ElmaFolder%
    else
        WinActivate
    WinWaitActive, %WinDXWindowerName%
    MouseClick, left, 30, 80, 2
    Process Wait, %ElmaFile%, 10
    WinWaitActive, %WinElmaName%

    Send {Space down} ; Bypass splashscreen
    Sleep, 10
    Send {Space up}

    Sleep, 2500 ; Usually works around 1000 - 1500ms

    Send {Enter down} ; Select first player
    Sleep, 500
    Send {Enter up}

    Sleep, 500

    Send {Enter down} ; Select first player
    Sleep, 50
    Send {Enter up}

    Sleep, 500

    Send {Down down} ; Select Replay menu
    Sleep, 50
    Send {Down up}

    Sleep, 500

    Send {Enter down}
    Sleep, 500
    Send {Enter up}

Sleep, 500

   Send {Down down} ; Select Replay menu
    Sleep, 50
    Send {Down up}

Sleep, 500

    Send {Enter down} 
    Sleep, 500
    Send {Enter up}
    
Sleep, 1000

   Send {Down down} ; Select Replay menu
    Sleep, 50
    Send {Down up}

Sleep, 1000

    Send {Enter down} 
    Sleep, 500
    Send {Enter up}

Sleep, 1000

Send {T down}
Sleep, 500
Send {T up}

Sleep, 1000

Send {Esc down}
Sleep, 500
Send {Esc up}

Sleep, 1000

Send {F1 down}
Sleep, 100
Send {Enter down}
Sleep, 50
Send {Enter up}
Send {F1 up}


;check for snp*.pcx files, quit if no new

sleep 1000
Result := 1

While Result
{

loop, %ElmaFolder%\snp*.pcx

    Number := A_Index

sleep 3000

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
