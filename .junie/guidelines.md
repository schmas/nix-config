# Development Guidelines for Nix Configuration

This document provides guidelines and instructions for developing and maintaining this Nix-based configuration project.

## Build/Configuration Instructions

### Prerequisites

- A Unix-like operating system (macOS or Linux)
- Internet connection for downloading packages
- Basic understanding of Nix and the Nix language

### Installation

The project provides an automated installation script that handles most of the setup:

```bash
# For full installation
curl --proto '=https' --tlsv1.2 -sSf -L https://raw.githubusercontent.com/schmas/nix-config/main/install.sh | bash

# For test installation (macOS only, installs minimal set of packages)
curl --proto '=https' --tlsv1.2 -sSf -L https://raw.githubusercontent.com/schmas/nix-config/main/install.sh | bash -s -- --test
```

#### Manual Installation

If you prefer to perform the installation steps manually:

1. **Install Nix**:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **OS-specific setup**:
   - macOS: Install Command Line Tools and Rosetta
     ```bash
     xcode-select --install
     softwareupdate --install-rosetta --agree-to-license
     ```

3. **Clone and configure the repository**:
   ```bash
   git clone https://github.com/schmas/nix-config.git ~/.config/nix-config
   ```

4. **Build and activate the configuration**:
   - For macOS (vesuvio):
     ```bash
     nix run nix-darwin -- switch --flake ~/.config/nix-config#vesuvio
     # or for testing with minimal packages:
     nix run nix-darwin -- switch --flake ~/.config/nix-config#vesuvio-test
     ```
   - For Linux (helka):
     ```bash
     nix run nixpkgs#nixos-rebuild -- switch --flake ~/.config/nix-config#helka
     ```

### Updating the Configuration

After making changes to the configuration:

- For macOS:
  ```bash
  darwin-rebuild switch --flake ~/.config/nix-config#vesuvio
  ```

- For Linux:
  ```bash
  nixos-rebuild switch --flake ~/.config/nix-config#helka
  ```

### Updating Packages

To update all packages to their latest versions:

- For macOS:
  ```bash
  nix flake update --flake ~/.config/nix-config && darwin-rebuild switch --flake ~/.config/nix-config#vesuvio
  ```

- For Linux:
  ```bash
  nix flake update --flake ~/.config/nix-config && nixos-rebuild switch --flake ~/.config/nix-config#helka
  ```

## Testing Information

### Setting Up the Development Environment

The project includes a `shell.nix` file that sets up a development environment with all necessary tools:

```bash
nix-shell
```

This will provide a shell with Nix, home-manager, git, and encryption-related tools (sops, ssh-to-age, gnupg, age).

### Basic Testing

A basic test script is provided to verify that the Nix environment is properly set up:

```bash
./.junie/test-nix-env.sh
```

This script checks:
1. If Nix is installed
2. If flakes are enabled
3. If the flake.nix file exists
4. If the flake can be evaluated successfully

### Creating New Tests

When creating new tests:

1. Place test scripts in the `.junie` directory
2. Make them executable: `chmod +x .junie/your-test-script.sh`
3. Follow the pattern of existing tests:
   - Use `set -euo pipefail` for safer bash scripting
   - Include clear error messages
   - Exit with non-zero status on failure

### Testing Configuration Changes

To test configuration changes without applying them permanently:

```bash
# For macOS
darwin-rebuild build --flake ~/.config/nix-config#vesuvio

# For Linux
nixos-rebuild build --flake ~/.config/nix-config#helka
```

For macOS, you can use the test configuration to verify changes with minimal impact:

```bash
darwin-rebuild switch --flake ~/.config/nix-config#vesuvio-test
```

## Development Guidelines

### Project Structure

- `flake.nix`: The main entry point defining inputs and outputs
- `hosts/`: Host-specific configurations
  - `vesuvio/`: macOS configuration
  - `helka/`: Linux configuration
  - `common/`: Shared configurations
- `home/`: Home-manager configurations
- `modules/`: Reusable Nix modules
- `overlays/`: Nixpkgs overlays
- `pkgs/`: Custom packages

### Code Style

The project uses the following code style guidelines:

- Use 2 spaces for indentation (defined in `.editorconfig`)
- Use Unix-style line endings (LF)
- Include a final newline in all files
- Trim trailing whitespace
- Use UTF-8 encoding

### Pre-commit Hooks

The project uses pre-commit hooks to ensure code quality:

- `gitleaks`: Scans for sensitive information in the codebase

Install pre-commit hooks:

```bash
pre-commit install
```

### Best Practices

1. **Modularize configurations**: Keep configurations modular and reusable
2. **Use overlays for package customizations**: Modify packages using overlays instead of directly
3. **Keep secrets separate**: Use sops-nix or similar for managing secrets
4. **Test changes incrementally**: Make small, testable changes rather than large overhauls
5. **Document changes**: Add comments to complex configurations and update README.md when necessary
6. **Use the test configuration**: Test significant changes on the test configuration before applying to the main configuration

### Debugging Tips

1. **Check build logs**:
   ```bash
   nix log /nix/store/hash-derivation-name
   ```

2. **Enter a build environment**:
   ```bash
   nix-shell -p package-name
   ```

3. **Show dependency tree**:
   ```bash
   nix-store --query --tree /nix/store/hash-derivation-name
   ```

4. **Garbage collection**:
   ```bash
   nix-collect-garbage -d
   ```
