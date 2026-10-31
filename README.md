# Android SDK Platform-Tools & ADB Automation Suite

[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-0078D6.svg)](https://github.com)
[![SDK Version](https://img.shields.io/badge/Platform--Tools-v37.0.1-3DDC84.svg?logo=android)](https://developer.android.com/tools/releases/platform-tools)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![ADB & Fastboot](https://img.shields.io/badge/Tools-ADB%20%7C%20Fastboot-orange.svg)]()
[![Pupil & Student Guide](https://img.shields.io/badge/Guide-Student%20%26%20Pupils-purple.svg)](STUDENT_GUIDE.md)

A complete, modern developer toolkit combining **official Google Android SDK Platform-Tools (Revision 37.0.1)** with an **interactive automation suite**, one-click Windows PATH setup, VS Code task integration, and cross-platform support for Windows, macOS, and Linux.

> 🎓 **Students & Beginners**: Read our step-by-step [**Pupil & Student Guide (STUDENT_GUIDE.md)**](STUDENT_GUIDE.md) for how to enable USB debugging, run in CMD, PowerShell, VS Code, and Mac Terminal.

---

## Highlights

* **100% Original Binaries**: Contains un-tampered, official `adb.exe`, `fastboot.exe`, and required runtime DLLs from Google AOSP (rev 37.0.1).
* **Unchanged Commands**: All standard command-line flags and terminal behaviors are fully intact.
* **Interactive Multi-Tool CLI**:
  * Windows: [`adb-toolkit.bat`](adb-toolkit.bat) (Batch) and [`scripts/toolkit.ps1`](scripts/toolkit.ps1) (PowerShell).
  * macOS & Linux: [`adb-toolkit.sh`](adb-toolkit.sh) (Bash).
* **One-Click Environment Setup**:
  * Windows: [`scripts/setup-path.bat`](scripts/setup-path.bat).
  * macOS / Linux: [`scripts/setup-mac-linux.sh`](scripts/setup-mac-linux.sh).
* **VS Code Integration**: Built-in `.vscode/tasks.json` allowing one-click execution of ADB commands directly from the VS Code command palette.

---

## Directory Structure

```text
android-sdk-platform-tools-adb-37-0-1/
├── adb-toolkit.bat            # Windows Interactive console menu (Batch)
├── adb-toolkit.sh             # macOS & Linux Interactive menu (Bash)
├── STUDENT_GUIDE.md           # Step-by-step beginner guide for pupils & students
├── README.md                  # Project documentation & cheatsheet
├── LICENSE                    # Apache 2.0 License
├── NOTICE.txt                 # Original AOSP notices and third-party licenses
├── .gitignore                 # Git ignore rules for media and OS files
├── .vscode/
│   └── tasks.json             # VS Code One-Click Run Tasks
├── platform-tools/            # Official Google platform-tools binaries (Windows)
│   ├── adb.exe
│   ├── fastboot.exe
│   ├── sqlite3.exe
│   ├── etc1tool.exe
│   ├── hprof-conv.exe
│   ├── make_f2fs.exe
│   ├── mke2fs.exe
│   ├── AdbWinApi.dll
│   ├── AdbWinUsbApi.dll
│   ├── libwinpthread-1.dll
│   └── source.properties
└── scripts/                   # Automation scripts
    ├── setup-path.bat         # Windows one-click PATH installer
    ├── setup-path.ps1         # Safe Windows PowerShell PATH updater
    ├── setup-mac-linux.sh     # macOS & Linux automated installer
    └── toolkit.ps1            # PowerShell interactive assistant
```

---

## Quick Start Guide

### Option 1: Use the Interactive Menu
Double-click [`adb-toolkit.bat`](adb-toolkit.bat) in the root folder. You will get an interactive menu:
1. Connect via USB or Wireless ADB
2. Drag-and-drop APK installation
3. Capture screenshots / record screen directly to `.\captures\`
4. Reboot into Recovery or Bootloader/Fastboot
5. Device information and live battery diagnostics

### Option 2: Add to Windows PATH (Recommended)
Double-click [`scripts/setup-path.bat`](scripts/setup-path.bat) or run:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup-path.ps1
```
Once added, open a new Command Prompt or PowerShell window and type:
```cmd
adb version
fastboot --version
```

---

## Standard Command Reference (Cheat Sheet)

All commands remain completely standard and unmodified:

### 1. Device Discovery & Server Control
| Command | Description |
| :--- | :--- |
| `adb devices -l` | List connected devices with detailed product info |
| `adb kill-server` | Terminate the background ADB server process |
| `adb start-server` | Start or reinitialize the ADB server |
| `fastboot devices` | Detect devices connected in Fastboot/Bootloader mode |

### 2. Wireless ADB (Android 11+)
```cmd
# 1. Enable pairing on phone (Settings > Developer options > Wireless debugging)
adb pair 192.168.1.50:37123

# 2. Connect to the device IP and Port
adb connect 192.168.1.50:5555
```

### 3. App Management
```cmd
# Install an application (-r replaces existing app)
adb install -r "path\to\application.apk"

# List third-party installed packages
adb shell pm list packages -3

# Uninstall an application
adb uninstall com.example.package
```

### 4. File Transfers & Screen Capture
```cmd
# Push a file to the phone's Download folder
adb push sample.txt /sdcard/Download/

# Pull a file from phone to PC
adb pull /sdcard/Download/sample.txt .\

# Take a screenshot
adb exec-out screencap -p > screenshot.png
```

### 5. Reboot Modes
```cmd
# Normal system reboot
adb reboot

# Reboot into Recovery (TWRP / OrangeFox / Stock)
adb reboot recovery

# Reboot into Fastboot / Bootloader
adb reboot bootloader
```

---

## Publishing to Your GitHub

Follow these steps to upload this project to your GitHub account:

### 1. Initialize Git in this directory
```cmd
git init -b main
git add .
git commit -m "Initial commit: Android SDK Platform-Tools v37.0.1 with Automation Suite"
```

### 2. Link your remote repository
Create a new repository on [GitHub](https://github.com/new) (e.g. `android-platform-tools-suite`) and run:
```cmd
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git push -u origin main
```

---

## Legal & Attribution

* **Android SDK Platform-Tools** is developed by Google LLC as part of the [Android Open Source Project (AOSP)](https://source.android.com/).
* Licensed under the **Apache License, Version 2.0**.
* Third-party notices and licenses are preserved in [NOTICE.txt](file:///e:/Downloads/android-sdk-platform-tools-adb-37-0-1/platform-tools/NOTICE.txt).
* Automation scripts, documentation, and tooling provided under the [Apache 2.0 License](LICENSE).
