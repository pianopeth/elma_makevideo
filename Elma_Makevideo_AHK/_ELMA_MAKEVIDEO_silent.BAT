@echo off
 
setlocal enabledelayedexpansion

if exist snp*.pcx (
	echo Some snp*.pcx files already exist, 
	echo please remove them before running the script! [ABORTED]
	goto :end
	)

cd rec
if exist !last.rec del !last.rec
    for %%a in (*.rec) do (
       set "fname=%%~na"
       if "!fname:~-15!" == "!fname!" (
         echo.
       ) else goto opsz
     )
    )
cd..

set greccount=0
cls

echo.
echo.
echo              Elasto Mania videomaking workflow script   
echo.
echo.
echo ------------------------------------------------------------------
echo STEP 1.: Rendering PCX files from .rec files in Elma with F1+Enter
echo ------------------------------------------------------------------
echo.
echo You'll need:
echo.
echo		- A working copy of EOL (Elma 1.3)
echo		- eolconf.exe (part of eol)
echo		- D3DWindower (not part of eol, you can download it from https://bit.ly/3dFiP6J)
echo		- BMP folder with shirts
echo			you can download shirts from https://elmaonline.net/downloads/shirts
echo			(if you don't want to use kuskis' shirts in the videos, find the line 'set skipeolconf=no'
echo			in elma_F1enter_silent.bat and change it to 'set skipeolconf=yes')
echo.

call elma_F1enter_silent.bat
if "%greccount%"=="0" goto :end

echo.
echo ------------------------------------------------------------------
echo STEP 2.: Rendering mp4 file from PCX files with ffmpeg
echo ------------------------------------------------------------------
echo.
echo You'll need:
echo.
echo	- ffmpeg.exe (not part of eol, you can download it from https://ffmpeg.zeranoe.com/builds/)
echo.
echo		Choose codec:
echo		[1] HEVC lossless (GPU)*
echo		[2] H264 lossless (GPU)*
echo		[3] x264 lossy (CPU only, default if no choice in 15 seconds)
echo.
echo	*NVIDIA GPU and NVENC support required, visit
echo	https://developer.nvidia.com/video-encode-decode-gpu-support-matrix
echo	to check if your GPU is capable of HEVC/H264 hardware encoding
echo.

REM skipping choice
GOTO hevc
REM skipping choice

CHOICE /C:123 /T:15 /D:3
IF ERRORLEVEL 3 GOTO lossy
IF ERRORLEVEL 2 GOTO h264
IF ERRORLEVEL 1 GOTO hevc
GOTO end
:hevc
call elma_renderHEVC.bat
GOTO end
	
:h264
call elma_renderH264.bat
GOTO end

:lossy
call elma_renderLossy.bat		
GOTO end

:opsz
echo "!fname!" can't be more than 15 chars in filename
:end
pause
exit /b
