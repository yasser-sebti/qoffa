@echo off
setlocal EnableExtensions
title Qoffa (قفة) Dev Console
color 0A
mode con: cols=96 lines=32
cls
pushd "%~dp0"

set "CURRENT_DIR=%CD%"
set "CURRENT_DIR_FORWARD=%CURRENT_DIR:\=/%"
set "CLEAN_BUILD="
if exist "build\windows\x64\CMakeCache.txt" (
  findstr /I /C:"For build in directory: %CURRENT_DIR_FORWARD%/build/windows/x64" "build\windows\x64\CMakeCache.txt" >nul
  if errorlevel 1 set "CLEAN_BUILD=1"
)

if defined CLEAN_BUILD (
  echo.
  echo  [INFO] Path mismatch detected in CMake cache - drive or directory changed.
  echo         Cleaning stale build directory to prevent build failures...
  rmdir /s /q "build"
)

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
  echo.
  echo Checked:
  echo   %%FLUTTER_ROOT%%\bin\flutter.bat
  echo   %%USERPROFILE%%\develop\flutter\bin\flutter.bat
  echo   C:\Users\sebti\develop\flutter\bin\flutter.bat
  echo   flutter.bat on PATH
  pause
  popd
  exit /b 1
)

echo.
echo  ================================================================
echo    QOFFA (قفة) — DEV CONSOLE
echo    Algerian Grocery Companion · Production Dev Environment
echo  ================================================================
echo.
echo  Project:
echo    %CD%
echo.
echo  Flutter:
echo    %FLUTTER%
echo.
echo  Shortcuts work here in this CMD window, not inside the app.
echo  If the app window is focused, click back on this console first.
echo.
echo  Dev shortcuts:
echo    r   hot reload       use after normal Dart/UI edits
echo    R   hot restart      use when reload does not update enough
echo    h   show Flutter help
echo    q   quit dev run
echo.
echo  Starting Qoffa in Flutter debug mode (Windows desktop)...
echo  Keep this window open. This is the cockpit.
echo  ----------------------------------------------------------------
echo.

echo  Preparing Flutter dependencies...
call "%FLUTTER%" pub get >nul
if errorlevel 1 (
  echo.
  echo [ERROR] Flutter pub get failed.
  pause
  popd
  exit /b 1
)

call "%FLUTTER%" run -d windows --debug --no-pub
if errorlevel 1 (
  echo.
  echo [ERROR] Flutter dev run failed on Windows.
  echo.
  echo Common fixes:
  echo   - Run: flutter pub get
  echo   - Close any stuck qoffa.exe from Task Manager
  echo   - Or run with Chrome: flutter run -d chrome
  echo.
  pause
  popd
  exit /b 1
)

echo.
echo  Qoffa dev run ended.
echo.
pause
popd

exit /b 0
