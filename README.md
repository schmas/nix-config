# dotfiles

This is my new (under) development dotfiles using Nix

## Install Nix

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# if macos install Command Line Tools
xcode-select --install
softwareupdate --install-rosetta --agree-to-license
```

## Configure environment

```bash
git clone https://github.com/schmas/nix-config.git ~/.config/nix-config &&
nix run nix-darwin -- switch --flake ~/.config/nix-config#vesuvio

# or for testing, it will install only a few cask packages
git clone https://github.com/schmas/nix-config.git ~/.config/nix-config &&
nix run nix-darwin -- switch --flake ~/.config/nix-config#vesuvio-test

# Now install the dotfiles
chezmoi init --apply schmas
```

## Updating packages

```bash
nix flake update --flake ~/.config/nix-config && darwin-rebuild switch --flake ~/.config/nix-config#vesuvio
```

## To Do

- [ ] Add `nvim` setup, clone `nvim-config` repo
- [ ] Add overlays for `nixpkgs` packages
- [ ] Use packages as arrays
- [x] Remove chezmoi from home.activation
- [x] Setup MacOS Dock Apps
- [ ] Mac Backup apps settings
