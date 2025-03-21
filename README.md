# dotfiles

This is my new (under) development dotfiles using Nix

## Quick Install

One-line installation (supports both macOS and Linux):

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://raw.githubusercontent.com/schmas/nix-config/main/install.sh | bash
```

The installer will:
1. Install Nix
2. Set up OS-specific requirements (Command Line Tools and Rosetta for macOS)
3. Clone and configure nix-config
4. Optionally install dotfiles using chezmoi (you'll be prompted)

## Manual Installation

If you prefer to run the steps manually:

### Install Nix

```bash
# Install Nix (works on both macOS and Linux)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# macOS only: install Command Line Tools and Rosetta
if [[ "$(uname)" == "Darwin" ]]; then
    xcode-select --install
    softwareupdate --install-rosetta --agree-to-license
fi
```

### Configure environment

For macOS (vesuvio):
```bash
git clone https://github.com/schmas/nix-config.git ~/.config/nix-config &&
nix run nix-darwin -- switch --flake ~/.config/nix-config#vesuvio

# or for testing, it will install only a few cask packages
nix run nix-darwin -- switch --flake ~/.config/nix-config#vesuvio-test
```

For Linux (helka):
```bash
git clone https://github.com/schmas/nix-config.git ~/.config/nix-config &&
nix run nixpkgs#nixos-rebuild -- switch --flake ~/.config/nix-config#helka
```

### Optional: Install dotfiles
```bash
chezmoi init --apply schmas
```

## Updating packages

For macOS:
```bash
nix flake update --flake ~/.config/nix-config && darwin-rebuild switch --flake ~/.config/nix-config#vesuvio
```

For Linux:
```bash
nix flake update --flake ~/.config/nix-config && nixos-rebuild switch --flake ~/.config/nix-config#helka
```

## To Do

- [ ] Add `nvim` setup, clone `nvim-config` repo
- [x] Add overlays for `nixpkgs` packages
- [x] Use packages as arrays
- [x] Remove chezmoi from home.activation
- [x] Setup MacOS Dock Apps
- [ ] Mac Backup apps settings
