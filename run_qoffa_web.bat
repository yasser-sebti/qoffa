@echo off
setlocal EnableExtensions
title Qoffa (قفة) Web Dev Console
color 0A
mode con: cols=96 lines=32
cls
pushd "%~dp0"

set "FLUTTER="

if defined FLUTTER_ROOT (
  if exist "%FLUTTER_ROOT%\bin\flutter.bat" set "FLUTTER=%FLUTTER_ROOT%\bin\flutter.bat"
)

if not defined FLUTTER (
  if exist "%USERPROFILE%\develop\flutter\bin\flutter.bat" set "FLUTTER=%USERPROFILE%\develop\flutter\bin\flutter.bat"
)

if not defined FLUTTER (
  if exist "C:\Users\sebti\develop\flutter\bin\flutter.bat" set "FLUTTER=C:\Users\sebti\develop\flutter\bin\flutter.bat"
)

if not defined FLUTTER (
  for /f "delims=" %%F in ('where flutter.bat 2^>nul') do (
    set "FLUTTER=%%F"
    goto :flutter_found
  )
)

:flutter_found

if not exist "%FLUTTER%" (
  echo [ERROR] Flutter SDK not found.
  pause
  popd
  exit /b 1
)

echo.
echo  ================================================================
echo    QOFFA (قفة) — WEB DEV CONSOLE
echo    Launching on Chrome with local storage and full responsiveness
echo  ================================================================
echo.

call "%FLUTTER%" run -d chrome --web-renderer canvaskit
popd

exit /b 0
