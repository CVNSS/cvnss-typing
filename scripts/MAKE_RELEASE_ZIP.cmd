@echo off
setlocal EnableExtensions
cd /d "%~dp0\.."

rem ============================================================
rem MAKE_RELEASE_ZIP.cmd
rem Create a release zip (source) that you can attach to GitHub Releases.
rem ============================================================

set "NAME=cvnss-typing-source"
set "OUT=%CD%\dist\%NAME%.zip"

if not exist "dist" mkdir "dist"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "Compress-Archive -Force -Path assets,docs,ime,scripts,tools,README.md,LICENSE,.gitignore -DestinationPath '%OUT%'"

if errorlevel 1 (
  echo [ERROR] Compress-Archive failed.
  pause
  exit /b 1
)

echo [OK] %OUT%
pause
