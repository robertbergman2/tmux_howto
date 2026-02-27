#!/usr/bin/env bash
# install-tmux.sh — Install tmux and dependencies on macOS or Linux
set -euo pipefail

OS="$(uname -s)"

install_macos() {
    if ! command -v brew &>/dev/null; then
        echo "Error: Homebrew is required. Install from https://brew.sh"
        exit 1
    fi
    echo "Installing tmux via Homebrew..."
    brew install tmux
}

install_linux() {
    if command -v apt-get &>/dev/null; then
        echo "Installing tmux via apt..."
        sudo apt-get update && sudo apt-get install -y tmux
    elif command -v dnf &>/dev/null; then
        echo "Installing tmux via dnf..."
        sudo dnf install -y tmux
    elif command -v pacman &>/dev/null; then
        echo "Installing tmux via pacman..."
        sudo pacman -Sy --noconfirm tmux
    else
        echo "Error: No supported package manager found (apt, dnf, pacman)."
        exit 1
    fi
}

if command -v tmux &>/dev/null; then
    echo "tmux is already installed: $(tmux -V)"
    read -rp "Reinstall? [y/N] " ans
    [[ "$ans" =~ ^[Yy]$ ]] || exit 0
fi

case "$OS" in
    Darwin) install_macos ;;
    Linux)  install_linux ;;
    *)      echo "Unsupported OS: $OS"; exit 1 ;;
esac

echo "Installed: $(tmux -V)"
