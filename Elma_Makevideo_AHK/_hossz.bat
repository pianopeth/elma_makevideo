 @echo off
   
    setlocal enabledelayedexpansion
 cd rec
    for %%a in (*.rec) do (
       set "fname=%%~na"
       if "!fname:~-15!" == "!fname!" (
         echo "!fname!" OK
       ) else (
         echo "!fname!" more than 15 chars!
     )
    )
cd..
pause
exit
