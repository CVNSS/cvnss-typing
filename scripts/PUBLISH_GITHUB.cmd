@echo off
setlocal EnableExtensions
cd /d "%~dp0\.."

rem ============================================================
rem PUBLISH_GITHUB.cmd
rem Push this folder to GitHub in one shot.
rem
rem Usage:
rem   scripts\PUBLISH_GITHUB.cmd https://github.com/CVNSS/cvnss-typing.git
rem   -or-
rem   scripts\PUBLISH_GITHUB.cmd CVNSS cvnss-typing   (requires GitHub CLI: gh)
rem ============================================================

where git >nul 2>nul
if errorlevel 1 (
  echo [ERROR] git not found. Install Git for Windows first.
  pause
  exit /b 1
)

set "ARG1=%~1"
set "ARG2=%~2"

if "%ARG1%"=="" (
  echo Usage:
  echo   scripts\PUBLISH_GITHUB.cmd https://github.com/CVNSS/cvnss-typing.git
  echo   scripts\PUBLISH_GITHUB.cmd CVNSS cvnss-typing
  pause
  exit /b 1
)

if not exist ".git" (
  git init
)

git config core.autocrlf true >nul 2>nul

git add -A

git commit -m "Initial release: cvnss-typing" >nul 2>nul
if errorlevel 1 (
  rem commit may fail if nothing changed; ignore
)

git branch -M main

rem ------------------------------------------------------------
rem Mode A: use GitHub CLI to create + push (org repo)
rem ------------------------------------------------------------
if not "%ARG2%"=="" (
  where gh >nul 2>nul
  if errorlevel 1 (
    echo [ERROR] GitHub CLI (gh) not found.
    echo Install from https://cli.github.com/ then run:
    echo   gh auth login
    pause
    exit /b 1
  )

  rem Create repo (public) and push
  gh repo create "%ARG1%/%ARG2%" --public --source . --remote origin --push
  if errorlevel 1 (
    echo [ERROR] gh repo create/push failed.
    pause
    exit /b 1
  )

  echo [OK] Published to: https://github.com/%ARG1%/%ARG2%
  pause
  exit /b 0
)

rem ------------------------------------------------------------
rem Mode B: push to an existing remote URL
rem ------------------------------------------------------------
set "REMOTE=%ARG1%"
git remote remove origin >nul 2>nul
git remote add origin "%REMOTE%"

git push -u origin main
if errorlevel 1 (
  echo [ERROR] git push failed.
  echo Tip: make sure you created the repo on GitHub first, then re-run.
  pause
  exit /b 1
)

echo [OK] Published to: %REMOTE%
pause
