@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM  Voice Inventory - one-click Android launcher
REM  Just plug the phone in via USB (tap "Allow USB debugging")
REM  and double-click this file. It will:
REM    - start the backend if it isn't already running
REM    - wait for the phone
REM    - bridge phone localhost:3000 -> this laptop
REM    - install + launch the app
REM  KEEP THE PHONE PLUGGED IN while using the app.
REM ============================================================
set ADB=C:\Users\PCS\AppData\Local\Android\Sdk\platform-tools\adb.exe
set PROJ=%~dp0
set APK=%PROJ%android\app\build\outputs\apk\debug\app-debug.apk
set APPID=com.dukaanbot.inventory

echo ============================================
echo   Voice Inventory - Android launcher
echo ============================================
echo.

REM --- 1. Start backend if nothing is listening on :3000 ---
netstat -ano | findstr ":3000" | findstr "LISTENING" >nul
if errorlevel 1 (
  echo [1/4] Backend not running - starting it in a new window...
  start "Voice Inventory Backend" cmd /k "cd /d "%PROJ%" && npm start"
  echo       Waiting a few seconds for it to come up...
  timeout /t 6 /nobreak >nul
) else (
  echo [1/4] Backend already running on port 3000. OK.
)
echo.

REM --- 2. Wait for the phone to be detected ---
echo [2/4] Looking for your phone...
echo       ^(Plug in USB and tap "Allow USB debugging" on the phone^)
set FOUND=0
for /l %%i in (1,1,30) do (
  if !FOUND!==0 (
    for /f "skip=1 tokens=1,2" %%a in ('"%ADB%" devices') do (
      if "%%b"=="device" set FOUND=1
    )
    if !FOUND!==0 timeout /t 1 /nobreak >nul
  )
)
if !FOUND!==0 (
  echo.
  echo   ^>^> Phone not detected. Try:
  echo      - a different USB cable / port ^(must support data, not charge-only^)
  echo      - unlock the phone and accept the "Allow USB debugging" popup
  echo      - set USB mode to "File transfer / MTP"
  echo.
  pause
  exit /b 1
)
echo       Phone detected. OK.
echo.

REM --- 3. Bridge + install ---
echo [3/4] Setting up USB bridge and installing app...
"%ADB%" reverse tcp:3000 tcp:3000
"%ADB%" install -r "%APK%"
echo.

REM --- 4. Launch ---
echo [4/4] Launching the app...
"%ADB%" shell monkey -p %APPID% -c android.intent.category.LAUNCHER 1 >nul 2>&1

echo.
echo ============================================
echo  Done. App should be open on your phone.
echo  IMPORTANT: keep the phone plugged in via USB
echo  while using the app. If you unplug or the page
echo  shows CONNECTION_REFUSED, just run this file again.
echo ============================================
pause
