{
  pkgs,
  ...
}:

with pkgs;
let
  # Darwin-specific packages
  darwinSpecificPackages = with pkgs; [
    dockutil
    reattach-to-user-namespace
  ];

  # Brew packages
  brews = [
    "urlview"
    "openssl"
    "podman"
    "podman-compose"
  ];

  # Casks
  casks = [
    # Security & Privacy
    "1password"
    "gpg-suite-no-mail"
    "proton-pass"
    "protonvpn"
    "tunnelblick"

    # Productivity & Utilities
    "alfred"
    # "alt-tab"
    "bartender"
    "cleanmymac"
    "cleanshot"
    "doll"
    "hammerspoon"
    "imageoptim"
    "keepingyouawake"
    "leader-key"
    "logi-options+"
    "monitorcontrol"
    "neohtop"
    "notion"
    "notion-calendar"
    "obsidian"
    "pixelsnap"
    "rectangle-pro"
    "transnomino" # batch renamer
    "clop" # Image, video, PDF and clipboard optimiser

    # Development Tools
    "ghostty"
    "jetbrains-toolbox"
    "podman-desktop"
    "postman"
    "visual-studio-code"
    "cursor"
    "zed"

    # Browsers & Communication
    "discord"
    "google-chrome"
    "slack"
    "vivaldi"
    "zoom"

    # Cloud Storage & Sync
    "google-drive"
    "proton-drive"
    "proton-mail"

    # Media & Entertainment
    "spotify"
    "steam"
    "whisky"
    "heroic"

    # Design & Creative
    # "figma"
    # "godot"

    # Virtual Machines & Remote Access
    # "rustdesk"
    "utm"

    # Microsoft
    # "microsoft-auto-update"
  ];

  sharedPackages = import ./packages.nix { inherit pkgs; };

  # Combine shared packages with Darwin-specific packages
  allPackages = sharedPackages.all-packages ++ darwinSpecificPackages;

  # Filter out packages that are in Homebrew from all packages
  filteredPackages = builtins.filter (
    pkg: !(builtins.elem (pkg.pname or pkg.name) brews)
  ) allPackages;

in
{
  packages = filteredPackages;
  inherit brews casks;
}
