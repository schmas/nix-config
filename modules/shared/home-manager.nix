{ user, config, pkgs, lib, ... }:

let
  commonAliases = {
    update-flake = "nix flake update --flake ~/.config/dotfiles_nix";
  };
in
{
  # Common packages
  home.packages = with pkgs; [ mise ];

  # Common program configurations
  programs = {
    git = {
      enable = false;
      userName = "Diego Schmidt";
      userEmail = "schmas+gh@pm.me";
    };

    bash = {
      enable = true;
      enableCompletion = true;

      shellAliases = commonAliases;

      initExtra = ''
        # Your custom bash code goes here

        if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
          . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fi

        ##############################
        # DOTFILES
        ##################################
        export DOTFILES_DIR="$HOME/.config/bash"
        export DOTFILES_BIN="$HOME/bin"
        export DOTFILES_FUNCTIONS="$DOTFILES_DIR/functions"

        # source all files in the config.d directory and its subdirectories
        while read -d $'\0' file; do
          source "$file"
        done < <(find $DOTFILES_DIR/conf.d -type f -name "*.bash" -print0)

        # load bashrc_local
        [ -f "$DOTFILES_DIR/bashrc_local" ] && source "$DOTFILES_DIR/bashrc_local" || true
      '';
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = commonAliases;

      initExtra = ''
        # Your custom bash code goes here
        if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
          . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fi

        ##############################
        # DOTFILES
        ##############################
        export DOTFILES_DIR="$HOME/.config/zsh"
        export DOTFILES_BIN="$HOME/bin"
        export DOTFILES_FUNCTIONS="$DOTFILES_DIR/functions"

        ##############################
        # Autoload personal functions
        ##############################
        fpath=("$DOTFILES_FUNCTIONS" "$fpath[@]")
        autoload -Uz $fpath[1]/*(.:t)

        # source all files in the config.d directory and its subdirectories
        while read -d $'\0' file; do
            source "$file"
        done < <(find $DOTFILES_DIR/conf.d -type f -name "*.zsh" -print0)

        # load bashrc_local
        [ -f "$DOTFILES_DIR/zshrc_local" ] && source "$DOTFILES_DIR/zshrc_local" || true
      '';
    };

    fish = {
      enable = true;

      shellAliases = commonAliases;

      interactiveShellInit = ''
        # Your custom bash code goes here
        if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
          . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fi

        ##############################
        # DOTFILES
        ##############################
        # meaningful-ooo/sponge: Purge only on exit
        set sponge_purge_only_on_exit true

        # load config_local.fish if available
        if test -f $__fish_config_dir/config_local.fish
            source $__fish_config_dir/config_local.fish
        end
      '';
    };

    starship = {
      enable = true;
      enableTransience = true;
      enableZshIntegration = false;
    };
  };

  home.stateVersion = "25.05";

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  # systemd.user.startServices = "sd-switch";

  # Chezmoi integration
  home.activation = {
    chezmoiIntegration = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo "Configuring dotfiles..."
      echo "Shell: $SHELL"

      export PATH="${
          lib.makeBinPath (with pkgs; [ git _1password-cli atuin fzf ])
        }:$PATH"

      if [ ! -d "$HOME/.local/share/chezmoi" ]; then
        run ${pkgs.chezmoi}/bin/chezmoi init --apply ${user}
      else
        run ${pkgs.chezmoi}/bin/chezmoi update
      fi
    '';
  };
}
