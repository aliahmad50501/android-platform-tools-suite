<#
.SYNOPSIS
    Interactive PowerShell ADB & Fastboot Multi-Tool Suite.
.DESCRIPTION
    Provides an interactive menu for managing Android devices via ADB and Fastboot.
#>

$ErrorActionPreference = "Continue"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$adbPath = Join-Path $repoRoot "platform-tools\adb.exe"
$fastbootPath = Join-Path $repoRoot "platform-tools\fastboot.exe"
$capturesDir = Join-Path $repoRoot "captures"

if (-not (Test-Path $capturesDir)) {
    New-Item -ItemType Directory -Path $capturesDir -Force | Out-Null
}

function Show-Header {
    Clear-Host
    Write-Host "===============================================================================" -ForegroundColor Cyan
    Write-Host "                  ADB & FASTBOOT MULTI-TOOL (POWERSHELL)                      " -ForegroundColor White
    Write-Host "             Original SDK Tools (v37.0.1) + Automation Suite                  " -ForegroundColor DarkCyan
    Write-Host "===============================================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Run-Adb {
    param([string[]]$Arguments)
    & $adbPath @Arguments
}

function Run-Fastboot {
    param([string[]]$Arguments)
    & $fastbootPath @Arguments
}

do {
    Show-Header
    Write-Host " [ DEVICE & CONNECTION ]" -ForegroundColor Yellow
    Write-Host "   1. List Connected Devices (ADB & Fastboot)"
    Write-Host "   2. Wireless ADB Manager (Connect / Pair / Disconnect)"
    Write-Host "   3. Restart ADB Server"
    Write-Host ""
    Write-Host " [ APP & FILE MANAGEMENT ]" -ForegroundColor Yellow
    Write-Host "   4. Install APK"
    Write-Host "   5. Uninstall Application / Package"
    Write-Host "   6. List 3rd-Party Packages"
    Write-Host "   7. Push File to Device (/sdcard/Download/)"
    Write-Host "   8. Pull File from Device"
    Write-Host ""
    Write-Host " [ MEDIA & SCREEN ]" -ForegroundColor Yellow
    Write-Host "   9. Capture Screenshot to PC (.\captures)"
    Write-Host "  10. Record Screen Video to PC (.\captures)"
    Write-Host ""
    Write-Host " [ REBOOT & MODES ]" -ForegroundColor Yellow
    Write-Host "  11. Reboot System"
    Write-Host "  12. Reboot to Recovery"
    Write-Host "  13. Reboot to Bootloader / Fastboot"
    Write-Host ""
    Write-Host " [ DIAGNOSTICS & SYSTEM ]" -ForegroundColor Yellow
    Write-Host "  14. Device Info & Battery Status"
    Write-Host "  15. Open Interactive Device Shell"
    Write-Host "  16. Live Logcat Stream"
    Write-Host "  17. Add Platform-Tools to Windows PATH"
    Write-Host ""
    Write-Host "   0. Exit" -ForegroundColor Red
    Write-Host "===============================================================================" -ForegroundColor Cyan
    
    $choice = Read-Host "Select an option [0-17]"

    switch ($choice) {
        "1" {
            Clear-Host
            Write-Host "=== ADB Devices ===" -ForegroundColor Green
            Run-Adb @("devices", "-l")
            Write-Host "`n=== Fastboot Devices ===" -ForegroundColor Green
            Run-Fastboot @("devices")
            Pause
        }
        "2" {
            Clear-Host
            Write-Host "=== Wireless ADB Manager ===" -ForegroundColor Green
            Write-Host "1. Connect (IP:Port)"
            Write-Host "2. Pair with Code (Android 11+)"
            Write-Host "3. Disconnect All"
            Write-Host "4. Enable TCP Mode (port 5555 via USB)"
            Write-Host "0. Back"
            $w = Read-Host "Choice"
            if ($w -eq "1") {
                $ip = Read-Host "Enter IP:Port (e.g., 192.168.1.50:5555)"
                if ($ip) { Run-Adb @("connect", $ip) }
                Pause
            } elseif ($w -eq "2") {
                $ip = Read-Host "Enter Pairing IP:Port (e.g., 192.168.1.50:37123)"
                $code = Read-Host "Enter 6-Digit Pairing Code"
                if ($ip -and $code) { Run-Adb @("pair", $ip, $code) }
                Pause
            } elseif ($w -eq "3") {
                Run-Adb @("disconnect")
                Pause
            } elseif ($w -eq "4") {
                Run-Adb @("tcpip", "5555")
                Pause
            }
        }
        "3" {
            Write-Host "Restarting ADB Server..." -ForegroundColor Yellow
            Run-Adb @("kill-server")
            Start-Sleep -Seconds 1
            Run-Adb @("start-server")
            Run-Adb @("devices")
            Pause
        }
        "4" {
            $apk = Read-Host "Enter APK Path (or drag and drop)"
            $apk = $apk.Trim('"')
            if (Test-Path $apk) {
                Write-Host "Installing $apk..." -ForegroundColor Green
                Run-Adb @("install", "-r", $apk)
            } else {
                Write-Host "File not found: $apk" -ForegroundColor Red
            }
            Pause
        }
        "5" {
            $pkg = Read-Host "Enter Package Name to uninstall"
            if ($pkg) {
                Run-Adb @("uninstall", $pkg)
            }
            Pause
        }
        "6" {
            Clear-Host
            Write-Host "=== Installed 3rd-Party Packages ===" -ForegroundColor Green
            Run-Adb @("shell", "pm", "list", "packages", "-3")
            Pause
        }
        "7" {
            $src = (Read-Host "File to push").Trim('"')
            if (Test-Path $src) {
                Run-Adb @("push", $src, "/sdcard/Download/")
            } else {
                Write-Host "File not found!" -ForegroundColor Red
            }
            Pause
        }
        "8" {
            $src = Read-Host "Device file path to pull (e.g. /sdcard/Download/file.txt)"
            if ($src) {
                Run-Adb @("pull", $src, $capturesDir)
            }
            Pause
        }
        "9" {
            $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
            $target = Join-Path $capturesDir "screenshot_$timestamp.png"
            Write-Host "Capturing screenshot..." -ForegroundColor Green
            Run-Adb @("shell", "screencap", "-p", "/sdcard/temp_screen.png")
            Run-Adb @("pull", "/sdcard/temp_screen.png", $target) | Out-Null
            Run-Adb @("shell", "rm", "/sdcard/temp_screen.png")
            if (Test-Path $target) {
                Write-Host "[SUCCESS] Screenshot saved to: $target" -ForegroundColor Green
            } else {
                Write-Host "[ERROR] Could not save screenshot." -ForegroundColor Red
            }
            Pause
        }
        "10" {
            $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
            $target = Join-Path $capturesDir "record_$timestamp.mp4"
            Write-Host "Recording screen... Press Ctrl+C to stop recording." -ForegroundColor Yellow
            Run-Adb @("shell", "screenrecord", "/sdcard/temp_record.mp4")
            Run-Adb @("pull", "/sdcard/temp_record.mp4", $target) | Out-Null
            Run-Adb @("shell", "rm", "/sdcard/temp_record.mp4")
            if (Test-Path $target) {
                Write-Host "[SUCCESS] Video saved to: $target" -ForegroundColor Green
            }
            Pause
        }
        "11" { Run-Adb @("reboot") }
        "12" { Run-Adb @("reboot", "recovery") }
        "13" { Run-Adb @("reboot", "bootloader") }
        "14" {
            Clear-Host
            Write-Host "=== Device Properties ===" -ForegroundColor Green
            Run-Adb @("shell", "getprop", "ro.product.model")
            Run-Adb @("shell", "getprop", "ro.product.brand")
            Run-Adb @("shell", "getprop", "ro.build.version.release")
            Write-Host "`n=== Battery Status ===" -ForegroundColor Green
            Run-Adb @("shell", "dumpsys", "battery")
            Pause
        }
        "15" {
            Write-Host "Entering interactive ADB Shell (type 'exit' to quit)..." -ForegroundColor Yellow
            Run-Adb @("shell")
        }
        "16" {
            Write-Host "Starting logcat (Press Ctrl+C to stop)..." -ForegroundColor Yellow
            Run-Adb @("logcat", "-v", "time")
        }
        "17" {
            & (Join-Path $scriptDir "setup-path.ps1")
            Pause
        }
    }
} while ($choice -ne "0")
