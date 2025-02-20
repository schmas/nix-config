{ pkgs, ... }:
with pkgs;
[
  # Shell and core utilities
  # bash # added by home-manager
  # fish # added by home-manager
  # zsh # added by home-manager
  nushell
  starship # Cross-shell prompt
  tmux # Terminal multiplexer
  carapace # CLI completions for ZSH
  sheldon # Shell plugin manager
  atuin # Shell history sync

  # File management and navigation
  bat # Cat clone with syntax highlighting
  eza # Modern replacement for ls
  fd # Simple, fast alternative to find
  fzf # Fuzzy finder
  ripgrep # Fast grep alternative
  tree-sitter # Parser generator tool and parsing library
  unar # Universal archive unpacker
  zoxide # Smarter cd command

  # Text processing and diff tools
  gawk
  diff-so-fancy # Human-readable git diffs
  difftastic # Structural diff tool
  jq # JSON processor
  yq-go # YAML/XML processor

  # Version control
  git
  git-lfs # Git extension for versioning large files
  gitleaks # SAST tool for detecting secrets in git repositories
  gh # GitHub CLI
  lazygit # Terminal UI for git commands
  pre-commit # Git hooks management

  # System monitoring and performance
  htop
  btop
  neofetch # System info script

  # Network tools
  curl
  wget
  inetutils # Collection of common network utilities
  dig # DNS lookup utility

  # Development tools
  mise # asdf replacement
  podman # Container runtime
  podman-tui # Terminal UI for podman
  podman-compose # Compose tool for podman

  # Security and encryption
  age # Simple, modern file encryption tool
  openssl
  gnupg
  sshpass # Non-interactive ssh password provider
  pinentry-curses
  pinentry_mac # Pinentry for macOS
  _1password-cli

  # Text editors
  vim
  neovim

  # File viewers and processors
  chafa # Terminal graphics for the 21st century
  ffmpegthumbnailer # Create thumbnails from videos
  poppler # PDF rendering library and tools
  viu # Terminal image viewer with Unicode support

  # Dotfiles management
  chezmoi # Manage dotfiles across multiple machines
  mkalias # Create macOS aliases

  # Core Unix tools and alternatives
  coreutils
  moreutils # Collection of Unix tools
  findutils
  gnused
  unixtools.watch
  gnutar

  # Shell enhancements
  thefuck # Magnificent app which corrects your previous console command

  # Package management and building
  pkg-config # Helper tool used when compiling applications and libraries
  luarocks # Package manager for Lua modules

  # Other utilities
  ast-grep # CLI tool for code structural search, lint and rewriting
  mas # Mac App Store command line interface
  nixfmt-rfc-style
  reattach-to-user-namespace # Utility for fixing pasteboard in tmux on macOS
  shfmt # Shell parser, formatter, and interpreter
  urlscan # Extract URLs from text
  watch # Execute a program periodically, showing output fullscreen
  xz # General-purpose data compression tool
  envsubst # Substitute environment variables in shell format strings
]
