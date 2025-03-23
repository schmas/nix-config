{
  pkgs,
  isTesting,
  ...
}:

with pkgs;
let
  dummy = builtins.trace "isTesting value is: ${toString isTesting}" null;

  # Darwin-specific packages
  darwinSpecificPackages = with pkgs; [
    dockutil
  ];

  # Brew packages
  brews = [
    "urlview"
    "openssl"
    "podman"
    "podman-compose"
  ];

  # Casks
  testingCasks = [
    "1password"
    "ghostty"
    "google-chrome"
    "visual-studio-code"
    "zed"
  ];

  fullCasks = [
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
# debug = builtins.trace "Shared packages: ${toString (map (p: p.name or p.pname) sharedPackages)}" true;
{
  packages = filteredPackages;
  inherit brews;
  casks = builtins.seq dummy (if isTesting then testingCasks else fullCasks);
}
