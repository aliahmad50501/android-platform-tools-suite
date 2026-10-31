# Complete Student & Beginner Guide: ADB & Fastboot Multi-Tool

Welcome! This guide is written for pupils, students, and beginners who want to learn how to connect their Android devices to their laptops (Windows or Mac), run commands, install apps, and use developer tools like **VS Code**, **Command Prompt (CMD)**, and **Terminal**.

---

## Table of Contents
1. [What are ADB and Fastboot?](#1-what-are-adb-and-fastboot)
2. [Phone Setup: Enabling Developer Options & USB Debugging](#2-phone-setup-enabling-developer-options--usb-debugging)
3. [How to Use on Windows](#3-how-to-use-on-windows)
   - [Method 1: Interactive Menu (No Typing Needed)](#method-1-interactive-menu-no-typing-needed)
   - [Method 2: Command Prompt (CMD)](#method-2-command-prompt-cmd)
   - [Method 3: PowerShell](#method-3-powershell)
4. [How to Use in Visual Studio Code (VS Code)](#4-how-to-use-in-visual-studio-code-vs-code)
5. [How to Use on macOS & Linux](#5-how-to-use-on-macos--linux)
6. [Top Common Commands with Examples](#6-top-common-commands-with-examples)
7. [Troubleshooting & Frequently Asked Questions](#7-troubleshooting--frequently-asked-questions)

---

## 1. What are ADB and Fastboot?

* **ADB (Android Debug Bridge)**: A command-line tool that lets your computer communicate directly with an Android phone or tablet. You can transfer files, install apps, take screenshots, view system logs, and run shell commands.
* **Fastboot**: A diagnostic tool used when the phone is booted into its bootloader. It is used for advanced tasks like checking hardware variables, unlocking the bootloader, or recovering a bricked device.

---

## 2. Phone Setup: Enabling Developer Options & USB Debugging

Before your laptop can communicate with your phone, you **must enable USB Debugging**:

```text
[ Phone Settings ]
       │
       ▼
[ About Phone ] ────► Tap "Build Number" 7 times (You are now a developer!)
       │
       ▼
[ System / Developer Options ]
       │
       ▼
Turn ON [ USB Debugging ] ────► Connect USB cable to Laptop
                                     │
                                     ▼
                     Popup on Phone: "Allow USB Debugging?"
                     [✔] Always allow from this computer
                     [ OK ]
```

1. Open **Settings** on your Android phone.
2. Scroll to the bottom and select **About Phone**.
3. Tap **Build Number** 7 times rapidly until a toast message says: *"You are now a developer!"*.
4. Go back to **Settings** > **System** > **Developer Options** (on Xiaomi/Redmi: *Additional Settings* > *Developer Options*).
5. Toggle **USB Debugging** to **ON**.
6. Connect the phone to your laptop using a USB data cable.
7. Unlock your phone. When the prompt appears: **"Allow USB Debugging from this computer?"**, check **"Always allow from this computer"** and tap **OK**.

---

## 3. How to Use on Windows

### Method 1: Interactive Menu (No Typing Needed)
1. Double-click [`adb-toolkit.bat`](adb-toolkit.bat) in the project folder.
2. A numbered menu will open. Type `1` and press **Enter** to see your connected phone.
3. Use the other menu options to install APKs, capture screenshots, reboot, or open a shell.

---

### Method 2: Command Prompt (CMD)

#### Option A: Quick Double-Click to Add to PATH (Permanent)
1. Open the `scripts/` folder and double-click [`setup-path.bat`](scripts/setup-path.bat).
2. Once complete, you can open **Command Prompt** anywhere and type:
   ```cmd
   adb devices
   ```

#### Option B: Using CMD without modifying PATH
1. In Windows Explorer, open this repository folder.
2. In the folder path address bar at the top, type `cmd` and press **Enter**.
3. Type:
   ```cmd
   .\platform-tools\adb.exe devices -l
   ```

---

### Method 3: PowerShell
1. In the repository folder, right-click an empty area and select **Open in Terminal** or **Open PowerShell window here**.
2. Run:
   ```powershell
   .\platform-tools\adb.exe devices
   ```
3. Or launch the PowerShell interactive assistant:
   ```powershell
   .\scripts\toolkit.ps1
   ```

---

## 4. How to Use in Visual Studio Code (VS Code)

This repository includes built-in **VS Code Tasks** to make development effortless.

### Step 1: Open the Folder
1. Launch **VS Code**.
2. Go to **File** > **Open Folder...** and select this repository folder (`android-sdk-platform-tools-adb-37-0-1`).

### Step 2: Use Built-in Tasks (One-Click)
Press <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> (or <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> on Mac), type `Tasks: Run Task`, and press **Enter**. You will see:
* `ADB: Launch Interactive Multi-Tool`
* `ADB: Check Connected Devices`
* `ADB: Restart ADB Server`
* `ADB: Open Interactive Shell`
* `ADB: View Live Logcat`

### Step 3: Use the Integrated Terminal
1. Press <kbd>Ctrl</kbd> + <kbd>`</kbd> (tilde) or click **Terminal** > **New Terminal**.
2. Type:
   ```powershell
   .\platform-tools\adb.exe devices
   ```

---

## 5. How to Use on macOS & Linux

Because macOS and Linux use Unix binaries instead of Windows `.exe` files, this repository includes an automatic setup script for Mac/Linux students:

### Step 1: Run the One-Time Setup Script
Open **Terminal** on your Mac or Linux laptop, navigate to the folder, and run:
```bash
chmod +x scripts/setup-mac-linux.sh adb-toolkit.sh
./scripts/setup-mac-linux.sh
```
* On macOS: If you have [Homebrew](https://brew.sh), it automatically installs `android-platform-tools`. If not, it downloads the official Google Mac binaries directly.
* On Linux: It automatically configures `adb` and `fastboot` for Ubuntu/Debian/Fedora/Arch.

### Step 2: Run the Mac Interactive Menu
```bash
./adb-toolkit.sh
```

---

## 6. Top Common Commands with Examples

| Task | Command | Example |
| :--- | :--- | :--- |
| **Verify Phone is Connected** | `adb devices` | Displays serial number and `device` status |
| **Install an Application** | `adb install -r <file.apk>` | `adb install -r my_game.apk` |
| **Uninstall an App** | `adb uninstall <package_name>` | `adb uninstall com.whatsapp` |
| **List Installed Apps** | `adb shell pm list packages -3` | Lists all 3rd-party user apps |
| **Take a Screenshot** | `adb exec-out screencap -p > screen.png` | Saves `screen.png` directly to PC |
| **Record Screen** | `adb shell screenrecord /sdcard/demo.mp4` | Press <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop |
| **Send File to Phone** | `adb push <local_file> <phone_path>` | `adb push test.pdf /sdcard/Download/` |
| **Copy File from Phone** | `adb pull <phone_path> <local_folder>` | `adb pull /sdcard/Download/test.pdf .` |
| **Connect via Wi-Fi** | `adb connect <IP>:5555` | `adb connect 192.168.1.45:5555` |
| **Reboot into Recovery** | `adb reboot recovery` | Opens TWRP/Stock recovery |
| **Reboot to Fastboot** | `adb reboot bootloader` | Enters Fastboot mode |

---

## 7. Troubleshooting & Frequently Asked Questions

### 1. `adb devices` shows `unauthorized`
* **Fix**: Unlock your phone screen. A popup dialog will appear asking to **"Allow USB Debugging?"**. Check the box *"Always allow from this computer"* and tap **OK**.

### 2. `adb devices` list is empty
* Ensure you are using a **data cable**, not a charge-only cable.
* Check that **USB Debugging** is toggled ON in Developer Options.
* If on Windows, check Device Manager for yellow exclamation marks (you may need the OEM USB driver for your phone brand, e.g., Samsung Smart Switch or Google USB Driver).

### 3. `'adb' is not recognized as an internal or external command`
* **Fix**: Run [`scripts/setup-path.bat`](scripts/setup-path.bat) to add the tools to your Windows PATH, or navigate directly into the folder and type `.\platform-tools\adb.exe`.

### 4. How to Disconnect Wireless ADB
* Run `adb disconnect` to terminate all active Wi-Fi debugging connections.
