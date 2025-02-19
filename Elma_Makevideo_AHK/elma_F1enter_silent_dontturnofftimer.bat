@echo off
setlocal EnableDelayedExpansion
set reccount=0

REM Pointless to use anything else
set watchfolder=rec
set eolconf=eolconf.exe

REM Change d3d value to eol.exe if you don't use D3DWindower. It's recommended though (much faster rendering).
REM d3d=eol.exe
set d3d=D3DWindower.exe

REM Change skipeolconf value to yes if you don't want to use different shirts.
set skipeolconf=yes

echo.
echo [STARTED] at %time:~0,5%
echo.

if not "%skipeolconf%"=="yes" (
	if not exist %eolconf% (
		echo %eolconf% not found! [ABORTED]
		goto :end
		)
	)
	
if not exist %d3d% (
	echo %d3d% not found! [ABORTED]
	goto :end
	)

if exist snp*.pcx (
	echo Some snp*.pcx files already exist, 
	echo please remove them before running the script! [ABORTED]
	goto :end
	)

if exist %watchfolder%\ (
	if not exist "%watchfolder%\*.rec" (
	echo No rec files found in %watchfolder% folder! [ABORTED]
	goto :end
	)
) else (
	echo %watchfolder% folder doesn't exist! [SKIPPED]
	goto :end
	)

ren "%watchfolder%\*.rec" *.r__
for %%g in ("%watchfolder%\*.r__") do (
	ren "%watchfolder%\%%~ng.r__" %%~ng.rec
	if exist "_%%~ng\" (
	echo 	Folder _%%~ng already exists [SKIPPED]
	echo.
	) else (
		md "_%%~ng"
		echo 	Folder for _%%~ng [CREATED]
		if not "%skipeolconf%"=="yes" (
			echo 	Starting %eolconf%, set kuski's nick of %%~ng.rec...
			echo 	Press any key to continue...
			REM pause>nul
 			call %eolconf%
			echo 	%eolconf% set.
			echo.
			)
  		echo 		Starting %d3d%... 
		echo 		Render PCX sequence with F1+ENTER on %%~ng.rec in replay menu in Elma!
		echo 		PLEASE QUIT %d3d% AFTER FINISHED RENDERING!
		echo.
REM 		call %d3d%
call trew_silent_dontturnofftimer_bugfixed.ahk
REM		echo 		%d3d% closed.
		echo.
			if exist snp*.pcx (
			echo 			Moving PCX sequence to _%%~ng\ ...
			move snp*.pcx "_%%~ng\" >nul
			set /A reccount=reccount+1
			echo 			[COMPLETED]
			echo.
				if "!reccount!"=="1" (
				echo 			!reccount! PCX sequence ready for mp4 conversion
				echo.
				echo ==================================================================
				) else (
				echo 			!reccount! PCX sequences ready for mp4 conversion
				echo.
				echo ==================================================================
				)
			echo.
			) else	(
					echo 			PCX sequence of %%~ng.rec not found! [SKIPPED]
					echo.
					)		
			)
	ren "%watchfolder%\%%~ng.rec" %%~ng.re_
)

:end
	if exist "%watchfolder%\*.re_" ren "%watchfolder%\*.re_" *.rec
	if exist "%watchfolder%\*.r__" ren "%watchfolder%\*.r__" *.rec
	echo.
	echo [FINISHED] at %time:~0,5%
	echo.

endlocal & (
  set "greccount=%reccount%"
)
REM pause
exit /b