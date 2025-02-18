# dotfiles

This is my new (under) development dotfiles using Nix

## Install Nix

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# if macos install Command Line Tools
xcode-select --install
```

## Configure environment

```bash
git clone https://github.com/schmas/dotfiles_nix.git ~/.config/dotfiles_nix
nix run nix-darwin -- switch --flake ~/.config/dotfiles_nix#macos
```

## Updating packages

```bash
nix flake update --flake ~/.config/dotfiles_nix && darwin-rebuild switch --flake ~/.config/dotfiles_nix#macos
```

## To Do

- [ ] Add `nvim` setup, clone `nvim-config` repo
- [ ] Add overlays for `nixpkgs` packages
- [ ] Use packages as arrays
- [ ] Remove chezmoi from home.activation
- [ ] Setup MacOS Dock Apps
