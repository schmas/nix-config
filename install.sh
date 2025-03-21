#!/usr/bin/env bash

set -euo pipefail

# Detect OS
OS="$(uname)"
case "$OS" in
    "Darwin")
        SYSTEM="macos"
        HOST="vesuvio"
        ;;
    "Linux")
        SYSTEM="linux"
        HOST="helka"
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            DISTRO="$ID"
        else
            echo "Cannot determine Linux distribution"
            exit 1
        fi
        ;;
    *)
        echo "Unsupported operating system: $OS"
        exit 1
        ;;
esac

echo "Installing Nix configuration for $SYSTEM..."

# Install Nix
echo "Installing Nix..."
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# macOS specific setup
if [ "$SYSTEM" = "macos" ]; then
    # Install Command Line Tools
    echo "Installing Command Line Tools..."
    if ! xcode-select -p &>/dev/null; then
        xcode-select --install
        echo "Please wait for Command Line Tools to complete installation and press Enter"
        read -r
    fi

    # Install Rosetta
    echo "Installing Rosetta..."
    softwareupdate --install-rosetta --agree-to-license
fi

# Clone and setup nix-config
echo "Setting up nix-config..."
if [ -d "$HOME/.config/nix-config" ]; then
    echo "nix-config directory already exists. Updating..."
    cd "$HOME/.config/nix-config"
    git pull
else
    git clone https://github.com/schmas/nix-config.git "$HOME/.config/nix-config"
fi

# Build and switch to the new configuration
echo "Building and activating configuration..."
if [ "$SYSTEM" = "macos" ]; then
    nix run nix-darwin -- switch --flake "$HOME/.config/nix-config#$HOST"
else
    nix run nixpkgs#nixos-rebuild -- switch --flake "$HOME/.config/nix-config#$HOST"
fi

# Ask about dotfiles installation
read -p "Would you like to install dotfiles using chezmoi? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Installing dotfiles..."
    chezmoi init --apply schmas
fi

echo "Installation complete!"
