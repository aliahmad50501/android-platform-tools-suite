# Android SDK Platform-Tools & ADB Automation Suite

[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-0078D6.svg?logo=windows)](https://github.com)
[![SDK Version](https://img.shields.io/badge/Platform--Tools-v37.0.1-3DDC84.svg?logo=android)](https://developer.android.com/tools/releases/platform-tools)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![ADB & Fastboot](https://img.shields.io/badge/Tools-ADB%20%7C%20Fastboot-orange.svg)]()
[![Pupil Guide](https://img.shields.io/badge/Guide-Pupil%20Handbook-purple.svg)](STUDENT_GUIDE.md)

A complete, modern developer toolkit combining **official Google Android SDK Platform-Tools (Revision 37.0.1)** with an **interactive automation suite**, one-click Windows PATH setup, VS Code task integration, and cross-platform support for Windows, macOS, and Linux.

> 🎓 **Pupils & Educators**: Please refer to our step-by-step [**Pupil Handbook (STUDENT_GUIDE.md)**](STUDENT_GUIDE.md) for detailed tutorials on enabling USB debugging, executing commands in CMD, PowerShell, VS Code, and macOS Terminal.

---

## Executive Overview

Connecting a laptop to an Android device should be accessible to every pupil. This repository packages Google's official, battle-tested `adb` and `fastboot` binaries with an interactive terminal assistant, automated environment installers, and built-in Visual Studio Code task runners. 

Whether a pupil is learning Android development, managing device backups, sideloading applications, or exploring mobile operating systems, this project eliminates configuration hurdles while maintaining full open-source legal compliance.

---

## Key Highlights

* **100% Original Binaries**: Contains un-tampered, official `adb.exe`, `fastboot.exe`, and required runtime DLLs from Google AOSP (rev 37.0.1).
* **Unchanged Standard Commands**: All original commands, flags, and parameters remain identical to standard developer documentation.
* **Interactive Multi-Tool Assistant**:
  * **Windows**: [`adb-toolkit.bat`](adb-toolkit.bat) (Batch) and [`scripts/toolkit.ps1`](scripts/toolkit.ps1) (PowerShell).
  * **macOS & Linux**: [`adb-toolkit.sh`](adb-toolkit.sh) (Bash).
* **One-Click Environment Setup**:
  * **Windows**: [`scripts/setup-path.bat`](scripts/setup-path.bat) safely registers tools to the User PATH.
  * **macOS / Linux**: [`scripts/setup-mac-linux.sh`](scripts/setup-mac-linux.sh) configures tools via Homebrew or official binaries.
* **Integrated Development Environment (IDE)**: Pre-configured [`.vscode/tasks.json`](.vscode/tasks.json) allows every pupil to execute ADB commands directly from Visual Studio Code.

---

## Directory Architecture

```text
android-platform-tools-suite/
├── adb-toolkit.bat            # Windows Interactive console menu (Batch)
├── adb-toolkit.sh             # macOS & Linux Interactive menu (Bash)
├── STUDENT_GUIDE.md           # Step-by-step beginner guide for each pupil
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

## Supported Platforms & Execution Methods

| Operating System | Quick Launcher | Automated Setup | Integrated Editor |
| :--- | :--- | :--- | :--- |
| **Windows 10 / 11** | `adb-toolkit.bat` | `scripts/setup-path.bat` | VS Code (`tasks.json`) |
| **Windows (PowerShell)** | `scripts/toolkit.ps1` | `scripts/setup-path.ps1` | Windows Terminal |
| **macOS (Darwin)** | `adb-toolkit.sh` | `scripts/setup-mac-linux.sh` | VS Code / zsh |
| **Linux (Ubuntu/Fedora)** | `adb-toolkit.sh` | `scripts/setup-mac-linux.sh` | Terminal / bash |

---

## Quick Start Guide for Every Pupil

### 1. Windows Laptops
* **Method A (Interactive Menu)**: Double-click [`adb-toolkit.bat`](adb-toolkit.bat) in the root folder. Select from the numbered options to check devices, install APKs, or capture screenshots.
* **Method B (Add to Windows PATH)**: Double-click [`scripts/setup-path.bat`](scripts/setup-path.bat). Once complete, open any Command Prompt or PowerShell window and run:
  ```cmd
  adb version
  adb devices -l
  ```

### 2. macOS & Linux Laptops
1. Open Terminal in this repository directory.
2. Grant execution permissions and run the installer:
   ```bash
   chmod +x scripts/setup-mac-linux.sh adb-toolkit.sh
   ./scripts/setup-mac-linux.sh
   ```
3. Launch the interactive menu:
   ```bash
   ./adb-toolkit.sh
   ```

### 3. Visual Studio Code (VS Code)
1. Open this repository folder in **VS Code**.
2. Press <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> (or <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> on macOS).
3. Type `Tasks: Run Task` and select any predefined action (e.g., `ADB: Check Connected Devices`, `ADB: View Live Logcat`, or `ADB: Open Interactive Shell`).

---

## Standard Command Reference (Cheat Sheet)

All commands remain completely standard and unmodified:

### 1. Device Discovery & Daemon Management
| Command | Action |
| :--- | :--- |
| `adb devices -l` | Lists connected devices with model and USB port details |
| `adb kill-server` | Terminates the background ADB server process |
| `adb start-server` | Initializes the ADB daemon |
| `fastboot devices` | Detects hardware in bootloader mode |

### 2. Wireless Debugging (Android 11+)
```cmd
# Step 1: Pair device with 6-digit code
adb pair 192.168.1.50:37123

# Step 2: Connect to device
adb connect 192.168.1.50:5555
```

### 3. Application Deployment & Management
```cmd
# Install or update an APK
adb install -r "path\to\application.apk"

# List third-party installed packages
adb shell pm list packages -3

# Uninstall an application
adb uninstall com.example.package
```

### 4. File Operations & Screen Capture
```cmd
# Push a file from laptop to device
adb push local_file.pdf /sdcard/Download/

# Pull a file from device to laptop
adb pull /sdcard/Download/sample.txt .\

# Take a screenshot directly to laptop
adb exec-out screencap -p > screenshot.png
```

### 5. Device Reboot Controls
```cmd
# Normal system reboot
adb reboot

# Reboot into Recovery Mode (Stock / Custom Recovery)
adb reboot recovery

# Reboot into Fastboot / Bootloader
adb reboot bootloader
```

---

## Publishing to GitHub

To publish this project to your GitHub profile:

### 1. Initialize Git in this directory
```cmd
git init -b main
git add .
git commit -m "Initial commit: Android Platform-Tools v37.0.1 with Automation Suite"
```

### 2. Connect and Push to Your GitHub Repository
Create a new public repository on [GitHub](https://github.com/new) named `android-platform-tools-suite`, then execute:
```cmd
git remote add origin https://github.com/YOUR_USERNAME/android-platform-tools-suite.git
git push -u origin main
```

---

## Legal Attribution & License

* **Android SDK Platform-Tools** is created and maintained by Google LLC as part of the [Android Open Source Project (AOSP)](https://source.android.com/).
* Distributed under the terms of the **Apache License, Version 2.0**.
* Third-party notices and licenses are fully preserved in [NOTICE.txt](platform-tools/NOTICE.txt).
* Automation scripts, student curricula, and tooling are provided under the [Apache 2.0 License](LICENSE).
