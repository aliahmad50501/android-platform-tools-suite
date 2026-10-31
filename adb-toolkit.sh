#!/usr/bin/env bash
# ==============================================================================
# ADB & Fastboot Multi-Tool Suite for macOS & Linux
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CAPTURES_DIR="$SCRIPT_DIR/captures"
mkdir -p "$CAPTURES_DIR"

# Locate adb command
if command -v adb &> /dev/null; then
    ADB_CMD="adb"
    FASTBOOT_CMD="fastboot"
elif [ -f "$HOME/platform-tools/adb" ]; then
    ADB_CMD="$HOME/platform-tools/adb"
    FASTBOOT_CMD="$HOME/platform-tools/fastboot"
else
    echo "[!] 'adb' not found. Would you like to run the installer now? (y/n)"
    read -r install_now
    if [[ "$install_now" =~ ^[Yy]$ ]]; then
        bash "$SCRIPT_DIR/scripts/setup-mac-linux.sh"
        ADB_CMD="$HOME/platform-tools/adb"
        FASTBOOT_CMD="$HOME/platform-tools/fastboot"
    else
        echo "Please run ./scripts/setup-mac-linux.sh first."
        exit 1
    fi
fi

while true; do
    clear
    echo "==============================================================================="
    echo "         ADB & FASTBOOT MULTI-TOOL (macOS & Linux Edition)"
    echo "==============================================================================="
    echo ""
    echo "  [ DEVICE CONNECTION ]"
    echo "    1. List Connected Devices (USB & Wi-Fi)"
    echo "    2. Wireless ADB Manager"
    echo "    3. Restart ADB Server"
    echo ""
    echo "  [ APP MANAGEMENT ]"
    echo "    4. Install APK to Device"
    echo "    5. Uninstall Package"
    echo "    6. List 3rd-Party Packages"
    echo ""
    echo "  [ REBOOT & MODES ]"
    echo "    7. Reboot Device (Normal)"
    echo "    8. Reboot to Recovery"
    echo "    9. Reboot to Bootloader / Fastboot"
    echo ""
    echo "  [ TOOLS & CAPTURE ]"
    echo "   10. Capture Screenshot (Saved to ./captures/)"
    echo "   11. Record Screen Video (Saved to ./captures/)"
    echo "   12. Push File to /sdcard/Download/"
    echo "   13. Pull File to ./captures/"
    echo ""
    echo "  [ DIAGNOSTICS & SYSTEM ]"
    echo "   14. Device Info & Battery"
    echo "   15. Open Interactive Shell"
    echo "   16. Live Logcat Stream"
    echo ""
    echo "    0. Exit"
    echo "==============================================================================="
    read -rp "Enter your choice [0-16]: " choice

    case "$choice" in
        1)
            echo "--- ADB Devices ---"
            $ADB_CMD devices -l
            echo "--- Fastboot Devices ---"
            $FASTBOOT_CMD devices 2>/dev/null || true
            read -rp "Press Enter to continue..."
            ;;
        2)
            echo "1. Connect (IP:Port)"
            echo "2. Pair with Code (Android 11+)"
            echo "3. Disconnect All"
            echo "4. Set Port 5555 over USB"
            read -rp "Option: " wchoice
            if [ "$wchoice" = "1" ]; then
                read -rp "Device IP:Port: " dev_ip
                $ADB_CMD connect "$dev_ip"
            elif [ "$wchoice" = "2" ]; then
                read -rp "Pairing IP:Port: " pair_ip
                read -rp "Pairing Code: " pair_code
                $ADB_CMD pair "$pair_ip" "$pair_code"
            elif [ "$wchoice" = "3" ]; then
                $ADB_CMD disconnect
            elif [ "$wchoice" = "4" ]; then
                $ADB_CMD tcpip 5555
            fi
            read -rp "Press Enter to continue..."
            ;;
        3)
            echo "Restarting ADB Server..."
            $ADB_CMD kill-server
            sleep 1
            $ADB_CMD start-server
            $ADB_CMD devices
            read -rp "Press Enter to continue..."
            ;;
        4)
            read -rp "Enter or Drag-and-drop APK Path: " apk_path
            apk_path="${apk_path%\'}"
            apk_path="${apk_path#\'}"
            if [ -f "$apk_path" ]; then
                $ADB_CMD install -r "$apk_path"
            else
                echo "File not found!"
            fi
            read -rp "Press Enter to continue..."
            ;;
        5)
            read -rp "Package Name: " pkg_name
            $ADB_CMD uninstall "$pkg_name"
            read -rp "Press Enter to continue..."
            ;;
        6)
            $ADB_CMD shell pm list packages -3
            read -rp "Press Enter to continue..."
            ;;
        7) $ADB_CMD reboot ;;
        8) $ADB_CMD reboot recovery ;;
        9) $ADB_CMD reboot bootloader ;;
        10)
            TS="$(date +%Y%m%d_%H%M%S)"
            TARGET="$CAPTURES_DIR/screenshot_$TS.png"
            echo "Capturing screen..."
            $ADB_CMD shell screencap -p /sdcard/temp_screen.png
            $ADB_CMD pull /sdcard/temp_screen.png "$TARGET" >/dev/null
            $ADB_CMD shell rm /sdcard/temp_screen.png
            echo "[SUCCESS] Screenshot saved to: $TARGET"
            read -rp "Press Enter to continue..."
            ;;
        11)
            TS="$(date +%Y%m%d_%H%M%S)"
            TARGET="$CAPTURES_DIR/record_$TS.mp4"
            echo "Recording screen... Press Ctrl+C to stop."
            $ADB_CMD shell screenrecord /sdcard/temp_record.mp4
            $ADB_CMD pull /sdcard/temp_record.mp4 "$TARGET" >/dev/null
            $ADB_CMD shell rm /sdcard/temp_record.mp4
            echo "[SUCCESS] Video saved to: $TARGET"
            read -rp "Press Enter to continue..."
            ;;
        12)
            read -rp "File to push: " push_file
            $ADB_CMD push "$push_file" /sdcard/Download/
            read -rp "Press Enter to continue..."
            ;;
        13)
            read -rp "Device file path to pull: " pull_file
            $ADB_CMD pull "$pull_file" "$CAPTURES_DIR/"
            read -rp "Press Enter to continue..."
            ;;
        14)
            echo "Model:" && $ADB_CMD shell getprop ro.product.model
            echo "Android Version:" && $ADB_CMD shell getprop ro.build.version.release
            echo "Battery Info:"
            $ADB_CMD shell dumpsys battery
            read -rp "Press Enter to continue..."
            ;;
        15)
            $ADB_CMD shell
            ;;
        16)
            $ADB_CMD logcat -v time
            ;;
        0)
            exit 0
            ;;
        *)
            echo "Invalid choice!"
            sleep 1
            ;;
    esac
done
