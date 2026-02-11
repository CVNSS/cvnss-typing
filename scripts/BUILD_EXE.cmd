@echo off
setlocal EnableExtensions
cd /d "%~dp0\.."

rem ============================================================
rem BUILD_EXE.cmd (AutoHotkey v2)
rem - Fix: pass /base AutoHotkeySC.bin explicitly (no GUI config needed)
rem - This produces a standalone .exe (target PC does NOT need AutoHotkey installed)
rem ============================================================

set "AHK2EXE="
if exist "%ProgramFiles%\AutoHotkey\v2\Compiler\Ahk2Exe.exe" set "AHK2EXE=%ProgramFiles%\AutoHotkey\v2\Compiler\Ahk2Exe.exe"
if "%AHK2EXE%"=="" if exist "%ProgramFiles%\AutoHotkey\Compiler\Ahk2Exe.exe" set "AHK2EXE=%ProgramFiles%\AutoHotkey\Compiler\Ahk2Exe.exe"
if "%AHK2EXE%"=="" if exist "%ProgramFiles(x86)%\AutoHotkey\Compiler\Ahk2Exe.exe" set "AHK2EXE=%ProgramFiles(x86)%\AutoHotkey\Compiler\Ahk2Exe.exe"

if "%AHK2EXE%"=="" (
  echo [ERROR] Ahk2Exe.exe not found.
  echo Install AutoHotkey v2 (Full) which includes Compiler\Ahk2Exe.exe
  pause
  exit /b 1
)

rem ---- Find AutoHotkeySC.bin (Base stub for compiler) ----
set "BASE="
if exist "%ProgramFiles%\AutoHotkey\v2\Compiler\AutoHotkeySC.bin" set "BASE=%ProgramFiles%\AutoHotkey\v2\Compiler\AutoHotkeySC.bin"
if "%BASE%"=="" if exist "%ProgramFiles%\AutoHotkey\Compiler\AutoHotkeySC.bin" set "BASE=%ProgramFiles%\AutoHotkey\Compiler\AutoHotkeySC.bin"
if "%BASE%"=="" if exist "%ProgramFiles(x86)%\AutoHotkey\Compiler\AutoHotkeySC.bin" set "BASE=%ProgramFiles(x86)%\AutoHotkey\Compiler\AutoHotkeySC.bin"

if "%BASE%"=="" (
  echo [ERROR] AutoHotkeySC.bin not found.
  echo Open folder: "%ProgramFiles%\AutoHotkey\v2\Compiler\"
  echo If missing, reinstall AutoHotkey v2 Full (not minimal/zip without Compiler).
  pause
  exit /b 1
)

if not exist "dist" mkdir "dist"

set "INFILE=%CD%\ime\CVNSS-IME.ahk"
set "OUTFILE=%CD%\dist\CVNSS-IME.exe"
set "ICON=%CD%\assets\cvnss_star.ico"

echo [INFO] Ahk2Exe = "%AHK2EXE%"
echo [INFO] Base   = "%BASE%"

"%AHK2EXE%" /in "%INFILE%" /out "%OUTFILE%" /icon "%ICON%" /base "%BASE%"

if errorlevel 1 (
  echo [ERROR] Build failed.
  echo Try opening Ahk2Exe GUI once:
  echo   "%AHK2EXE%" /gui
  pause
  exit /b 1
)

echo [OK] Built: dist\CVNSS-IME.exe
echo NOTE: EXE still needs Node.js (or the portable pack below).
pause
