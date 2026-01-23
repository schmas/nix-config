# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Nix configuration using Flakes for multi-platform system management:
- **macOS (Darwin)**: `vesuvio` host via nix-darwin
- **Linux (NixOS)**: `helka` host
- **Home Manager**: User environment across both platforms
- **Homebrew**: macOS GUI apps and CLI tools not well-supported in Nix

## Common Commands

```bash
# Build (test changes without applying)
darwin-rebuild build --flake ~/.config/nix-config#vesuvio      # macOS
nixos-rebuild build --flake ~/.config/nix-config#helka         # Linux

# Apply changes (run manually after build succeeds)
darwin-rebuild switch --flake ~/.config/nix-config#vesuvio     # macOS
nixos-rebuild switch --flake ~/.config/nix-config#helka        # Linux

# Update flake inputs
nix flake update --flake ~/.config/nix-config

# Format Nix files
nix fmt

# Debug with trace
darwin-rebuild build --flake ~/.config/nix-config#vesuvio --show-trace

# Rollback
darwin-rebuild --rollback    # macOS
nixos-rebuild --rollback     # Linux
```

## Architecture

```
flake.nix                    # Entry point, defines hosts and inputs
├── hosts/
│   ├── common/
│   │   ├── darwin/          # Shared macOS config (dock, defaults, etc.)
│   │   ├── linux/           # Shared Linux config
│   │   ├── global/          # Cross-platform (nix settings, fonts, shells)
│   │   └── packages/
│   │       ├── packages.nix         # Cross-platform packages (categorized dict)
│   │       └── packages-darwin.nix  # macOS-specific + Homebrew casks/brews
│   ├── vesuvio/             # macOS host entry point
│   └── helka/               # Linux host entry point
├── home/schmas/             # Home Manager user configs
├── modules/                 # Custom reusable modules
├── overlays/                # Package modifications
└── pkgs/                    # Custom package definitions
```

## Key Patterns

**Package Management**: Packages are organized in `packages.nix` as a categorized dictionary (`core`, `tools`, `dev`, etc.). Darwin-specific packages and Homebrew casks are in `packages-darwin.nix`.

**Adding packages**:
- Cross-platform: Add to appropriate category in `hosts/common/packages/packages.nix`
- macOS Nix packages: `darwinSpecificPackages` in `packages-darwin.nix`
- Homebrew GUI apps: `fullCasks` list in `packages-darwin.nix`
- Homebrew CLI tools: `brews` list in `packages-darwin.nix`

**Host configuration**: Each host's `default.nix` imports from `hosts/common/` and defines host-specific settings (networking, users, homebrew).

**Formatting**: Use `nixfmt` (RFC 166 style) via `nix fmt`.

## Important Notes

- **State versions**: `system.stateVersion = 6` (Darwin), `home.stateVersion = "25.05"` (Home Manager) - never change these
- **User**: `schmas` with uid 501, shell set to fish
- **Overlays**: Auto-applied via `hosts/common/global/`; use `pkgs.stable.<pkg>` for nixpkgs-stable packages
- **Homebrew filtering**: Packages in `brews` are automatically filtered from Nix packages to avoid duplicates
