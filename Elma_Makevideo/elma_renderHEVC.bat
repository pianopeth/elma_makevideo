@echo off
setlocal EnableDelayedExpansion
set creat=0

REM CUSTOM VARIABLES
REM 
REM ffmpegpath= ffmpeg.exe, use full path if needed (e.g. "C:\ffmpeg-3.2\bin\ffmpeg.exe") (protip: full path not needed if already set in PATH system variable)
REM extraseconds= seconds to add at the end of video (recommended: 2). A logfile is created in each folder to prevent adding extra frames next time (if needs to re-run script for the same folder for some reason)
REM frate= frame rate (recommended: 60)
REM
REM ------------------------------------------------------------------------------------------------------------------------------------

	SET ffmpegpath="ffmpeg.exe"
	SET extraseconds=2
	SET frate=60

REM ------------------------------------------------------------------------------------------------------------------------------------
	
echo HEVC lossless mode selected
echo.
echo ------------------
echo [STARTED] at %time:~0,5%
echo.

:checkingfolders
	set fnum=0
	for /D %%a in ("*") do (
		set "fold=%%a"
		if exist !fold!\ (
			set /A fnum=fnum+1
			if not exist !fold!.mp4 (
			echo Found folder !fold!\
			call :encoding
			) 	else (
				echo Found folder !fold!\, 
				echo 	...but !fold!.mp4 already exists [SKIPPED]
				echo.
			)
		)
	)

if %fnum%==0 goto :missing
goto :end

:encoding
	if not exist "%fold%"\snp00000.pcx (
	echo 	...but snp00000.pcx not found [SKIPPED]
	echo.
	) 	else (
		cd "%fold%"
		set cnt=0
		set fcnt=0		
		for /f %%y in ('dir "snp?????.pcx" /b/a-d/on') do (
			set fcnt=000000!cnt!
			set fcnt=!fcnt:~-5!
			if not exist snp!fcnt!.pcx (
				echo 	Error: snp!fcnt!.pcx is missing from the sequence [SKIPPED]
				echo.
				cd..
				exit /B
				)
			set /a cnt+=1
			)

		if not %extraseconds%==0 (
			if not exist _extraseconds.log call :ADD
			)
		cd..
		REM Encoding
		echo 	Creating %fold%.mp4 from pcx files...
		echo 	[HEVC lossless mode, %frate% fps]
		%ffmpegpath% -nostats -loglevel error -framerate %frate% -i "%fold%\snp%%05d.pcx" -c:v hevc_nvenc -preset lossless -pix_fmt nv12 "%fold%".mp4
				if exist "%fold%.mp4" (
				echo 	%fold%.mp4 [CREATED] at %time:~0,5%
				set /A creat=creat+1
				echo.
				)	else (
					echo 	%fold%\ [ERROR: no mp4 created!]
					echo.
					)
		)
	exit /B

:missing
	echo [ERROR] NO FOLDERS FOUND!
	echo.
	goto :end

:ADD
	set /A addframes="extraseconds*frate"
	for /f %%i in ('dir snp*.pcx /b/a-d/on') do set LAST=%%i
	set lastframe=%LAST:~3,5%
	IF "%lastframe%"=="" goto :abort
	FOR /F "tokens=* delims=0" %%A IN ("%lastframe%") DO SET fff=%%A
	set /A startframe=fff+1
	set /A finalframe=startframe+addframes
	echo 	Adding %extraseconds% extra seconds (%addframes% frames) after last frame [%LAST%]...
		for /L %%i in (%startframe%, 1, %finalframe%) do (
		set "i2=000000%%i"
		copy snp%lastframe%.pcx snp!i2:~-5!.pcx>nul
		)
	
	echo 	New last frame is [snp!i2:~-5!.pcx]
	echo FOLDER [%fold%]>_extraseconds.log
	echo Added %extraseconds% extra seconds (%addframes% frames) after last frame [%LAST%]>>_extraseconds.log
	echo New last frame is [snp!i2:~-5!.pcx]>>_extraseconds.log
	exit /B
	
:abort
	echo WTF, impsy get this error message!!
	exit /B

:end
	echo %creat% VIDEOS CREATED
	echo.
	echo [FINISHED] at %time:~0,5%
	echo -------------------
	echo.
	echo Note: PCX sequences aren't deleted after mp4 conversion, you have to delete them manually.
	echo.
	pause
	exit /B

