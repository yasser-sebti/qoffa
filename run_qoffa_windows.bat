@echo off
title Qoffa (قفة) - Building Release...
color 0A
mode con: cols=96 lines=32
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
echo    QOFFA (قفة) — BUILD ^& LAUNCH
echo    Building standalone Windows Release Executable
echo  ================================================================
echo.
echo  Closing existing instance (if any)...
taskkill /F /IM qoffa.exe /T >nul 2>&1

echo  Preparing Flutter dependencies...
call "%FLUTTER%" pub get >nul
if errorlevel 1 (
  echo.
  echo [ERROR] Flutter pub get failed.
  pause
  popd
  exit /b 1
)

echo  Building Windows release binary...
echo.
call "%FLUTTER%" build windows --release --no-pub
if errorlevel 1 (
  echo.
  echo [ERROR] Build failed.
  pause
  popd
  exit /b 1
)

echo.
echo  Launching Qoffa...
echo.

start "" "%~dp0build\windows\x64\runner\Release\qoffa.exe"
popd

exit /b 0
