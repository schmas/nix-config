{
  pkgs,
  ...
}:
let
  packages_dict = with pkgs; {
    core = [
      atuin
      carapace
      nushell
      sheldon
      starship
      tmux
      coreutils
      moreutils
      findutils
      gnused
      unixtools.watch
      gnutar
    ];

    tools = [
      bat
      eza
      fd
      fzf
      ripgrep
      pkgs.stable.thefuck
      tree-sitter
      unar
      zoxide
    ];

    viewers = [
      chafa
      ffmpegthumbnailer
      poppler
      viu
    ];

    processing = [
      gawk
      jq
      yq-go
    ];

    editors = [
      vim
      neovim
    ];

    dotfiles = [
      chezmoi
      mkalias
    ];

    utils = [
      ast-grep
      mas
      nixfmt-rfc-style
      reattach-to-user-namespace
      shfmt
      urlscan
      watch
      xz
      envsubst
    ];

    vcs = [
      git
      git-lfs
      gitleaks
      gh
      lazygit
      pre-commit
      diff-so-fancy
      difftastic
    ];

    monitoring = [
      btop
      neofetch
    ];

    network = [
      curl
      wget
      inetutils
      dig
    ];

    dev = [
      mise
      usage
      (python3.withPackages(ps: with ps; [
        pip
        setuptools
        wheel
      ]))
      nixd
    ];

    container = {
      podman = [
        podman
        podman-tui
        podman-compose
      ];
    };

    security = [
      age
      openssl
      gnupg
      sshpass
      pinentry-curses
      pinentry_mac
      _1password-cli
    ];

    packaging = [
      pkg-config
      luarocks
    ];
  };

in
{
  inherit packages_dict;

  all-packages =
    packages_dict.core
    ++ packages_dict.tools
    ++ packages_dict.viewers
    ++ packages_dict.processing
    ++ packages_dict.editors
    ++ packages_dict.dotfiles
    ++ packages_dict.utils
    ++ packages_dict.vcs
    ++ packages_dict.monitoring
    ++ packages_dict.network
    ++ packages_dict.dev
    ++ packages_dict.container.podman
    ++ packages_dict.security
    ++ packages_dict.packaging;
}
