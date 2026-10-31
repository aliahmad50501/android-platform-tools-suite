@echo off
setlocal EnableDelayedExpansion
title Android SDK Platform-Tools - Add to PATH

echo ======================================================================
echo    Android SDK Platform-Tools - One-Click PATH Installer
echo ======================================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "TOOL_DIR=%SCRIPT_DIR%..\platform-tools"

if not exist "%TOOL_DIR%\adb.exe" (
    echo [ERROR] adb.exe not found in %TOOL_DIR%
    pause
    exit /b 1
)

pushd "%TOOL_DIR%"
set "RESOLVED_PATH=%CD%"
popd

echo Target directory: %RESOLVED_PATH%
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%setup-path.ps1"

echo.
echo ======================================================================
echo Done! Press any key to exit...
echo ======================================================================
pause >nul
