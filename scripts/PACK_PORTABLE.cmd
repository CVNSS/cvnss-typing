@echo off
setlocal EnableExtensions
cd /d "%~dp0\.."

rem ============================================================
rem PACK_PORTABLE.cmd
rem - Builds CVNSS-IME.exe
rem - Creates dist\CVNSS-IME-PORTABLE\ folder that runs WITHOUT installing AutoHotkey.
rem - Optionally bundles node.exe from your machine so target PC doesn't need Node installed.
rem ============================================================

call "%CD%\scripts\BUILD_EXE.cmd"
if errorlevel 1 exit /b 1

set "OUTDIR=%CD%\dist\CVNSS-IME-PORTABLE"
if exist "%OUTDIR%" rmdir /s /q "%OUTDIR%"
mkdir "%OUTDIR%"
mkdir "%OUTDIR%\tools"
mkdir "%OUTDIR%\node"

copy /y "%CD%\dist\CVNSS-IME.exe" "%OUTDIR%\CVNSS-IME.exe" >nul
copy /y "%CD%\assets\cvnss_star.ico" "%OUTDIR%\cvnss_star.ico" >nul

copy /y "%CD%\tools\convert_cli.js" "%OUTDIR%\tools\convert_cli.js" >nul
copy /y "%CD%\tools\suggest_cli.js" "%OUTDIR%\tools\suggest_cli.js" >nul
copy /y "%CD%\tools\cvnss4.0-converter.js" "%OUTDIR%\tools\cvnss4.0-converter.js" >nul

rem ---- Try to bundle node.exe (where node OR default install path) ----
set "NODEEXE="
for /f "delims=" %%N in ('where node 2^>nul') do (
  set "NODEEXE=%%N"
  goto :gotNode
)
:gotNode

if "%NODEEXE%"=="" if exist "%ProgramFiles%\nodejs\node.exe" set "NODEEXE=%ProgramFiles%\nodejs\node.exe"

if not "%NODEEXE%"=="" (
  echo [INFO] Bundling node.exe: "%NODEEXE%"
  copy /y "%NODEEXE%" "%OUTDIR%\node\node.exe" >nul
) else (
  echo [WARN] Node.js not found in PATH, portable pack will require Node installed on target PC.
)

(
echo @echo off
echo cd /d "%%~dp0"
echo start "" "%%~dp0CVNSS-IME.exe"
) > "%OUTDIR%\Start.cmd"

(
echo CVNSS4.0 (Typing) - PORTABLE
echo.
echo - Run: Start.cmd
echo - Toggle: Ctrl+Alt+V
echo - Notepad test: "Chuc mugk namo moix" + Space => "Chúc mừng năm mới"
echo.
echo Notes:
echo - This folder is portable. Target PC does NOT need AutoHotkey installed.
echo - If node\node.exe exists, target PC also does NOT need Node installed.
) > "%OUTDIR%\README-PORTABLE.txt"

echo [OK] Portable folder created:
echo   %OUTDIR%
pause
