<#
.SYNOPSIS
    Adds the platform-tools directory to the Windows User PATH environment variable.
.DESCRIPTION
    Safely appends the absolute path of the platform-tools folder to the current user's PATH
    environment variable without truncating long PATH entries.
#>

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$platformToolsDir = Join-Path $repoRoot "platform-tools"

if (-not (Test-Path -Path $platformToolsDir)) {
    Write-Host "[ERROR] platform-tools folder not found at: $platformToolsDir" -ForegroundColor Red
    exit 1
}

$resolvedPath = (Resolve-Path $platformToolsDir).Path
Write-Host "Target platform-tools directory: $resolvedPath" -ForegroundColor Cyan

# Retrieve current user PATH
$currentUserPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
if ($null -eq $currentUserPath) { $currentUserPath = "" }

$pathList = $currentUserPath -split ';' | Where-Object { $_ -ne "" }

if ($pathList -contains $resolvedPath) {
    Write-Host "[OK] '$resolvedPath' is already present in your User PATH." -ForegroundColor Green
} else {
    Write-Host "Adding '$resolvedPath' to User PATH..." -ForegroundColor Yellow
    $newPath = if ($currentUserPath -eq "") { $resolvedPath } else { "$currentUserPath;$resolvedPath" }
    [Environment]::SetEnvironmentVariable("Path", $newPath, [EnvironmentVariableTarget]::User)
    Write-Host "[SUCCESS] Added to User PATH successfully!" -ForegroundColor Green
}

# Update current session PATH so test works immediately
$env:Path = "$resolvedPath;$env:Path"

Write-Host "`nTesting adb..." -ForegroundColor Cyan
try {
    & "$resolvedPath\adb.exe" version
    Write-Host "`n[SUCCESS] ADB is ready to use from any command prompt or terminal!" -ForegroundColor Green
    Write-Host "Note: You may need to restart existing terminal windows for PATH changes to apply." -ForegroundColor Gray
} catch {
    Write-Host "[WARNING] Could not execute adb.exe directly: $_" -ForegroundColor Red
}
