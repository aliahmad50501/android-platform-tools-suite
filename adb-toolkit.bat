@echo off
setlocal EnableDelayedExpansion
title ADB ^& Fastboot Multi-Tool Suite v1.0
color 0B

:: Ensure platform-tools is in PATH for this session
set "TOOLKIT_ROOT=%~dp0"
set "ADB_PATH=%TOOLKIT_ROOT%platform-tools"
set "PATH=%ADB_PATH%;%PATH%"

if not exist "%ADB_PATH%\adb.exe" (
    echo [ERROR] adb.exe was not found in "%ADB_PATH%".
    echo Please ensure the platform-tools folder is intact.
    pause
    exit /b 1
)

:MAIN_MENU
cls
echo ===============================================================================
echo                ADB ^& FASTBOOT TOOLKIT - COMMAND SUITE
echo             Original SDK Tools (v37.0.1) + Automation Suite
echo ===============================================================================
echo.
echo   [ DEVICE CONNECTION ]
echo     1. List Connected Devices (USB ^& Wi-Fi)
echo     2. Wireless ADB Manager (Connect / Pair / Disconnect)
echo     3. Restart ADB Server (Fix offline / unauthorized / stuck devices)
echo.
echo   [ APP MANAGEMENT ]
echo     4. Install APK to Device (Drag-and-drop support)
echo     5. Uninstall Application / Package
echo     6. List Installed 3rd-Party Applications
echo.
echo   [ REBOOT ^& MODES ]
echo     7. Reboot Device (System / Normal)
echo     8. Reboot to Recovery Mode
echo     9. Reboot to Bootloader / Fastboot Mode
echo.
echo   [ TOOLS ^& CAPTURE ]
echo    10. Capture Screenshot (Saved directly to PC .\captures)
echo    11. Record Screen Video (Saved to PC .\captures)
echo    12. Push File to Device (/sdcard/Download/)
echo    13. Pull File from Device
echo.
echo   [ DIAGNOSTICS ^& SYSTEM ]
echo    14. Device Info ^& Battery Status
echo    15. Open Interactive Device Shell (cmd)
echo    16. View Live Logcat
echo    17. Fastboot Menu (Diagnostics ^& Bootloader commands)
echo.
echo   [ SETUP ^& SHORTCUTS ]
echo    18. Add ADB ^& Fastboot to Windows PATH permanently
echo.
echo     0. Exit
echo ===============================================================================
set /p "CHOICE=Enter your choice [0-18]: "

if "%CHOICE%"=="1" goto CMD_DEVICES
if "%CHOICE%"=="2" goto CMD_WIRELESS
if "%CHOICE%"=="3" goto CMD_RESTART_ADB
if "%CHOICE%"=="4" goto CMD_INSTALL_APK
if "%CHOICE%"=="5" goto CMD_UNINSTALL_APK
if "%CHOICE%"=="6" goto CMD_LIST_PACKAGES
if "%CHOICE%"=="7" goto CMD_REBOOT_SYSTEM
if "%CHOICE%"=="8" goto CMD_REBOOT_RECOVERY
if "%CHOICE%"=="9" goto CMD_REBOOT_BOOTLOADER
if "%CHOICE%"=="10" goto CMD_SCREENSHOT
if "%CHOICE%"=="11" goto CMD_SCREENRECORD
if "%CHOICE%"=="12" goto CMD_PUSH_FILE
if "%CHOICE%"=="13" goto CMD_PULL_FILE
if "%CHOICE%"=="14" goto CMD_DEVICE_INFO
if "%CHOICE%"=="15" goto CMD_SHELL
if "%CHOICE%"=="16" goto CMD_LOGCAT
if "%CHOICE%"=="17" goto CMD_FASTBOOT
if "%CHOICE%"=="18" goto CMD_ADD_PATH
if "%CHOICE%"=="0" goto CMD_EXIT

echo [!] Invalid selection. Please try again.
timeout /t 2 >nul
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_DEVICES
cls
echo [ Listing Connected Devices ]
echo.
echo --- ADB Devices ---
"%ADB_PATH%\adb.exe" devices -l
echo.
echo --- Fastboot Devices ---
"%ADB_PATH%\fastboot.exe" devices
echo.
pause
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_WIRELESS
cls
echo [ Wireless ADB Manager ]
echo.
echo   1. Connect to Device (IP:Port)
echo   2. Pair Device (Android 11+ Pairing Code)
echo   3. Disconnect All Wireless Devices
echo   4. Enable Wireless ADB on USB-Connected Phone (Set port 5555)
echo   0. Back
echo.
set /p "WCHOICE=Select an option [0-4]: "
if "%WCHOICE%"=="1" (
    echo.
    set /p "DEV_IP=Enter Device IP and Port (e.g. 192.168.1.50:5555): "
    if defined DEV_IP "%ADB_PATH%\adb.exe" connect !DEV_IP!
    pause
    goto CMD_WIRELESS
)
if "%WCHOICE%"=="2" (
    echo.
    set /p "PAIR_IP=Enter Pairing IP and Port (e.g. 192.168.1.50:37123): "
    set /p "PAIR_CODE=Enter 6-digit Pairing Code: "
    if defined PAIR_IP "%ADB_PATH%\adb.exe" pair !PAIR_IP! !PAIR_CODE!
    pause
    goto CMD_WIRELESS
)
if "%WCHOICE%"=="3" (
    echo.
    "%ADB_PATH%\adb.exe" disconnect
    pause
    goto CMD_WIRELESS
)
if "%WCHOICE%"=="4" (
    echo.
    echo Setting device TCP port to 5555 (Make sure device is plugged in via USB)...
    "%ADB_PATH%\adb.exe" tcpip 5555
    echo Now disconnect USB and find your device IP in Wi-Fi settings.
    pause
    goto CMD_WIRELESS
)
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_RESTART_ADB
cls
echo [ Restarting ADB Server ]
echo.
echo Stopping ADB server...
"%ADB_PATH%\adb.exe" kill-server
timeout /t 1 >nul
echo Starting ADB server...
"%ADB_PATH%\adb.exe" start-server
echo.
echo Checking devices...
"%ADB_PATH%\adb.exe" devices
echo.
pause
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_INSTALL_APK
cls
echo [ Install APK to Device ]
echo.
echo Drag and drop the .apk file into this window, then press Enter:
set /p "APK_FILE=APK Path: "
if not defined APK_FILE goto MAIN_MENU

:: Strip surrounding quotes
set "APK_FILE=%APK_FILE:"=%"

if not exist "%APK_FILE%" (
    echo [ERROR] File does not exist: %APK_FILE%
    pause
    goto MAIN_MENU
)

echo Installing %APK_FILE%...
"%ADB_PATH%\adb.exe" install -r "%APK_FILE%"
echo.
pause
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_UNINSTALL_APK
cls
echo [ Uninstall Application ]
echo.
set /p "PKG_NAME=Enter Package Name (e.g. com.example.app): "
if not defined PKG_NAME goto MAIN_MENU

echo Uninstalling %PKG_NAME%...
"%ADB_PATH%\adb.exe" uninstall "%PKG_NAME%"
echo.
pause
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_LIST_PACKAGES
cls
echo [ 3rd-Party Installed Applications ]
echo.
"%ADB_PATH%\adb.exe" shell pm list packages -3
echo.
pause
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_REBOOT_SYSTEM
cls
echo [ Rebooting Device to System... ]
"%ADB_PATH%\adb.exe" reboot
echo Done.
timeout /t 2 >nul
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_REBOOT_RECOVERY
cls
echo [ Rebooting Device to Recovery Mode... ]
"%ADB_PATH%\adb.exe" reboot recovery
echo Done.
timeout /t 2 >nul
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_REBOOT_BOOTLOADER
cls
echo [ Rebooting Device to Bootloader / Fastboot... ]
"%ADB_PATH%\adb.exe" reboot bootloader
echo Done.
timeout /t 2 >nul
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_SCREENSHOT
cls
echo [ Capture Screenshot ]
echo.
if not exist "%TOOLKIT_ROOT%captures" mkdir "%TOOLKIT_ROOT%captures"

for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value 2^>nul') do set "DATETIME=%%I"
if not defined DATETIME set "DATETIME=%RANDOM%"
set "TIMESTAMP=%DATETIME:~0,8%_%DATETIME:~8,6%"
set "OUT_FILE=%TOOLKIT_ROOT%captures\screenshot_%TIMESTAMP%.png"

echo Capturing screen from device...
"%ADB_PATH%\adb.exe" shell screencap -p /sdcard/temp_screen.png
"%ADB_PATH%\adb.exe" pull /sdcard/temp_screen.png "%OUT_FILE%" >nul
"%ADB_PATH%\adb.exe" shell rm /sdcard/temp_screen.png

if exist "%OUT_FILE%" (
    echo [SUCCESS] Screenshot saved:
    echo   %OUT_FILE%
) else (
    echo [ERROR] Failed to capture screenshot. Make sure device is connected and authorized.
)
echo.
pause
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_SCREENRECORD
cls
echo [ Screen Video Recording ]
echo.
if not exist "%TOOLKIT_ROOT%captures" mkdir "%TOOLKIT_ROOT%captures"

for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value 2^>nul') do set "DATETIME=%%I"
if not defined DATETIME set "DATETIME=%RANDOM%"
set "TIMESTAMP=%DATETIME:~0,8%_%DATETIME:~8,6%"
set "OUT_FILE=%TOOLKIT_ROOT%captures\record_%TIMESTAMP%.mp4"

echo Recording screen... Press Ctrl+C on this window when done to stop.
echo (Max Android default limit: 3 minutes)
"%ADB_PATH%\adb.exe" shell screenrecord /sdcard/temp_record.mp4
echo.
echo Transferring video to PC...
"%ADB_PATH%\adb.exe" pull /sdcard/temp_record.mp4 "%OUT_FILE%" >nul
"%ADB_PATH%\adb.exe" shell rm /sdcard/temp_record.mp4

if exist "%OUT_FILE%" (
    echo [SUCCESS] Video saved:
    echo   %OUT_FILE%
) else (
    echo [ERROR] Recording was cancelled or failed.
)
echo.
pause
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_PUSH_FILE
cls
echo [ Push File to Device (/sdcard/Download/) ]
echo.
echo Drag and drop the file to push:
set /p "PUSH_SRC=File Path: "
if not defined PUSH_SRC goto MAIN_MENU

set "PUSH_SRC=%PUSH_SRC:"=%"
if not exist "%PUSH_SRC%" (
    echo [ERROR] File not found: %PUSH_SRC%
    pause
    goto MAIN_MENU
)

echo Pushing file...
"%ADB_PATH%\adb.exe" push "%PUSH_SRC%" /sdcard/Download/
echo.
pause
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_PULL_FILE
cls
echo [ Pull File from Device ]
echo.
set /p "PULL_SRC=Device file path (e.g. /sdcard/Download/sample.jpg): "
if not defined PULL_SRC goto MAIN_MENU

if not exist "%TOOLKIT_ROOT%captures" mkdir "%TOOLKIT_ROOT%captures"
echo Pulling file into .\captures ...
"%ADB_PATH%\adb.exe" pull "%PULL_SRC%" "%TOOLKIT_ROOT%captures\"
echo.
pause
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_DEVICE_INFO
cls
echo [ Device Information ^& Battery ]
echo.
echo --- Device Model ^& Android Version ---
"%ADB_PATH%\adb.exe" shell "getprop ro.product.model; getprop ro.product.brand; getprop ro.build.version.release; getprop ro.build.version.sdk"
echo.
echo --- Screen Resolution ---
"%ADB_PATH%\adb.exe" shell wm size
echo.
echo --- Battery Status ---
"%ADB_PATH%\adb.exe" shell dumpsys battery
echo.
pause
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_SHELL
cls
echo [ Starting Interactive ADB Shell ]
echo Type 'exit' to return to Toolkit menu.
echo.
"%ADB_PATH%\adb.exe" shell
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_LOGCAT
cls
echo [ View Live Logcat ]
echo Press Ctrl+C to stop viewing logs.
echo.
"%ADB_PATH%\adb.exe" logcat -v time
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_FASTBOOT
cls
echo [ Fastboot Menu ]
echo.
echo   1. Check Fastboot Devices
echo   2. Get All Device Variables (getvar all)
echo   3. Unlock Bootloader (fastboot flashing unlock)
echo   4. Lock Bootloader (fastboot flashing lock)
echo   5. Reboot to System (fastboot reboot)
echo   6. Reboot to Bootloader (fastboot reboot-bootloader)
echo   0. Back
echo.
set /p "FB_CHOICE=Select option [0-6]: "
if "%FB_CHOICE%"=="1" "%ADB_PATH%\fastboot.exe" devices & pause & goto CMD_FASTBOOT
if "%FB_CHOICE%"=="2" "%ADB_PATH%\fastboot.exe" getvar all & pause & goto CMD_FASTBOOT
if "%FB_CHOICE%"=="3" "%ADB_PATH%\fastboot.exe" flashing unlock & pause & goto CMD_FASTBOOT
if "%FB_CHOICE%"=="4" "%ADB_PATH%\fastboot.exe" flashing lock & pause & goto CMD_FASTBOOT
if "%FB_CHOICE%"=="5" "%ADB_PATH%\fastboot.exe" reboot & pause & goto CMD_FASTBOOT
if "%FB_CHOICE%"=="6" "%ADB_PATH%\fastboot.exe" reboot-bootloader & pause & goto CMD_FASTBOOT
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_ADD_PATH
cls
call "%TOOLKIT_ROOT%scripts\setup-path.bat"
goto MAIN_MENU

:: -----------------------------------------------------------------------------
:CMD_EXIT
exit /b 0
