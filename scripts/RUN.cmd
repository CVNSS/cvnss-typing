@echo off
setlocal EnableExtensions
cd /d "%~dp0\.."

rem ============================================================
rem RUN.cmd (AutoHotkey v2)
rem ============================================================

set "AHK="

if exist "%ProgramFiles%\AutoHotkey\v2\AutoHotkey64.exe" set "AHK=%ProgramFiles%\AutoHotkey\v2\AutoHotkey64.exe"
if "%AHK%"=="" if exist "%ProgramFiles%\AutoHotkey\v2\AutoHotkey32.exe" set "AHK=%ProgramFiles%\AutoHotkey\v2\AutoHotkey32.exe"
if "%AHK%"=="" if exist "%ProgramFiles%\AutoHotkey\AutoHotkey64.exe" set "AHK=%ProgramFiles%\AutoHotkey\AutoHotkey64.exe"
if "%AHK%"=="" if exist "%ProgramFiles%\AutoHotkey\AutoHotkey.exe" set "AHK=%ProgramFiles%\AutoHotkey\AutoHotkey.exe"

if "%AHK%"=="" (
  echo [ERROR] AutoHotkey v2 not found.
  echo Install AutoHotkey v2 then re-run scripts\RUN.cmd
  pause
  exit /b 1
)

where node >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Node.js not found in PATH.
  echo Install Node.js then re-run.
  pause
  exit /b 1
)

"%AHK%" "ime\CVNSS-IME.ahk"
