#!/usr/bin/env bash
# ==============================================================================
# Setup Android Platform-Tools on macOS and Linux
# ==============================================================================
set -e

echo "======================================================================"
echo "    Android Platform-Tools Auto-Installer for macOS & Linux"
echo "======================================================================"

OS_NAME="$(uname -s)"
echo "[*] Detected Operating System: $OS_NAME"

# Check if adb is already available
if command -v adb &> /dev/null; then
    echo "[OK] 'adb' is already installed on your system:"
    adb version
    exit 0
fi

# Detect shell configuration file
SHELL_RC=""
if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_RC="$HOME/.bash_profile"
fi

if [ "$OS_NAME" = "Darwin" ]; then
    echo "[*] Setting up for macOS..."
    if command -v brew &> /dev/null; then
        echo "[*] Homebrew detected. Installing android-platform-tools via brew..."
        brew install --cask android-platform-tools
        echo "[SUCCESS] Installed via Homebrew!"
        adb version
        exit 0
    else
        echo "[*] Homebrew not found. Downloading official Google platform-tools for macOS..."
        TARGET_DIR="$HOME/platform-tools"
        ZIP_URL="https://dl.google.com/android/repository/platform-tools-latest-darwin.zip"
        
        curl -L -o /tmp/platform-tools-darwin.zip "$ZIP_URL"
        unzip -q /tmp/platform-tools-darwin.zip -d "$HOME"
        rm /tmp/platform-tools-darwin.zip
        
        echo "[*] Exporting PATH to $SHELL_RC ..."
        if [ -n "$SHELL_RC" ]; then
            if ! grep -q "platform-tools" "$SHELL_RC"; then
                echo 'export PATH="$HOME/platform-tools:$PATH"' >> "$SHELL_RC"
            fi
        fi
        
        export PATH="$HOME/platform-tools:$PATH"
        echo "[SUCCESS] Platform-tools installed at $TARGET_DIR"
        "$HOME/platform-tools/adb" version
    fi
elif [ "$OS_NAME" = "Linux" ]; then
    echo "[*] Setting up for Linux..."
    if command -v apt-get &> /dev/null; then
        echo "[*] Debian/Ubuntu detected. Installing adb & fastboot..."
        sudo apt-get update && sudo apt-get install -y adb fastboot
    elif command -v dnf &> /dev/null; then
        echo "[*] Fedora/RHEL detected. Installing android-tools..."
        sudo dnf install -y android-tools
    elif command -v pacman &> /dev/null; then
        echo "[*] Arch Linux detected. Installing android-tools..."
        sudo pacman -Sy --noconfirm android-tools
    else
        echo "[*] Downloading official Google platform-tools for Linux..."
        TARGET_DIR="$HOME/platform-tools"
        ZIP_URL="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"
        
        curl -L -o /tmp/platform-tools-linux.zip "$ZIP_URL"
        unzip -q /tmp/platform-tools-linux.zip -d "$HOME"
        rm /tmp/platform-tools-linux.zip
        
        if [ -n "$SHELL_RC" ]; then
            if ! grep -q "platform-tools" "$SHELL_RC"; then
                echo 'export PATH="$HOME/platform-tools:$PATH"' >> "$SHELL_RC"
            fi
        fi
        export PATH="$HOME/platform-tools:$PATH"
    fi
fi

echo ""
echo "======================================================================"
echo "[SUCCESS] Installation Complete!"
echo "Please restart your terminal or run: source $SHELL_RC"
echo "======================================================================"
