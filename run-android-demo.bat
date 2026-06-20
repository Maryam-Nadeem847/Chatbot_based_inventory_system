@echo off
REM ============================================================
REM  Voice Inventory - Android demo launcher
REM  Run this AFTER:
REM    1) "npm start" is running in another terminal (backend on :3000)
REM    2) your phone is plugged in via USB with debugging authorized
REM ============================================================
setlocal
set ADB=C:\Users\PCS\AppData\Local\Android\Sdk\platform-tools\adb.exe
set APK=%~dp0android\app\build\outputs\apk\debug\app-debug.apk
set APPID=com.dukaanbot.inventory

echo.
echo [1/4] Checking for a connected device...
"%ADB%" devices
echo.

echo [2/4] Bridging phone's localhost:3000 to this laptop (USB)...
"%ADB%" reverse tcp:3000 tcp:3000
if errorlevel 1 (
  echo   ^> Could not set up adb reverse. Is the phone connected and authorized?
  pause
  exit /b 1
)

echo [3/4] Installing the debug APK...
"%ADB%" install -r "%APK%"

echo [4/4] Launching the app...
"%ADB%" shell monkey -p %APPID% -c android.intent.category.LAUNCHER 1 >nul 2>&1

echo.
echo Done. The app should now be open on your phone.
echo If you replug the cable, just run this script again (re-applies the bridge).
echo.
pause
