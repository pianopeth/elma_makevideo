@echo off
cls
if exist rec\!last.rec del rec\!last.rec
if exist "rec\*.re_" ren "rec\*.re_" *.rec
if exist "rec\*.r__" ren "rec\*.r__" *.rec
setlocal EnableDelayedExpansion
set greccount=0

echo.
echo.
echo              Elasto Mania videomaking workflow script by iCS
echo                      based on bene's python script  
echo                         Last update: 2025-09-27
echo.
echo ------------------------------------------------------------------
echo STEP 1.: Rendering PCX files from .rec files in Elma with F1+Enter
echo ------------------------------------------------------------------
echo.

call elma_F1enter.bat
if "%greccount%"=="0" goto :end

echo.
echo ------------------------------------------------------------------
echo STEP 2.: Rendering mp4 file from PCX files with ffmpeg
echo ------------------------------------------------------------------
echo.
echo		Choose codec:
echo		[1] HEVC lossless (NVIDIA GPU)
echo		[2] H264 lossless (NVIDIA GPU)
echo		[3] x264 lossy (CPU only, default if no choice in 15 seconds)
echo		[4] HEVC losless (AMD GPU)
echo.
echo            Note: x264 lossy is also near perfect quality,
echo            creates smaller files, but usually slower than GPU rendering.
echo.

CHOICE /C:1234 /T:15 /D:3
IF ERRORLEVEL 4 GOTO hevcamd
IF ERRORLEVEL 3 GOTO lossy
IF ERRORLEVEL 2 GOTO h264
IF ERRORLEVEL 1 GOTO hevc
GOTO end
:hevcamd
call elma_renderHEVCAMD.bat
GOTO end

:hevc
call elma_renderHEVC.bat
GOTO end
	
:h264
call elma_renderH264.bat
GOTO end

:lossy
call elma_renderLossy.bat		

:end
pause
exit /b
