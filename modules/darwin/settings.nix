{ config, user, ... }: {
  imports = [ ./dock ];

  config = {
    security = { pam = { enableSudoTouchIdAuth = true; }; };

    system = {
      defaults = {
        NSGlobalDomain = {
          NSTableViewDefaultSizeMode = 2;
          AppleShowScrollBars = "Always";
          NSUseAnimatedFocusRing = false;
          NSWindowResizeTime = 0.001;
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
          PMPrintingExpandedStateForPrint = true;
          PMPrintingExpandedStateForPrint2 = true;
          NSDocumentSaveNewDocumentsToCloud = false;
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
          ApplePressAndHoldEnabled = false;
          KeyRepeat = 2;
          InitialKeyRepeat = 15;

          "com.apple.keyboard.fnState" = true;
          "com.apple.swipescrolldirection" = true;
        };

        dock = {
          autohide = false;
          show-recents = false;
          launchanim = false;
          expose-animation-duration = 0.1;
          mineffect = "scale";
          minimize-to-application = true;
          mouse-over-hilite-stack = true;
          mru-spaces = false;
          showhidden = true;
          tilesize = 64;
        };

        finder = {
          AppleShowAllExtensions = true;
          _FXShowPosixPathInTitle = true;
          FXEnableExtensionChangeWarning = false;
          QuitMenuItem = true;
          FXPreferredViewStyle = "Nlsv";
          ShowPathbar = true;
          ShowStatusBar = true;
          FXRemoveOldTrashItems = true;
          FXDefaultSearchScope = "SCcf";

          # Keep folders on top
          _FXSortFoldersFirst = true; # Keep folders on top when sorting by name
          _FXSortFoldersFirstOnDesktop =
            true; # Keep folders on top on Desktop too

          # New window behavior
          NewWindowTarget = "Home"; # "PfHm" represents the Home folder
          # NewWindowTargetPath = "file://${config.users.primaryUser.home}";  # Sets the specific path
        };

        trackpad = {
          Clicking = true;
          TrackpadRightClick = true;
        };

        ActivityMonitor = {
          OpenMainWindow = true;
          IconType = 5;
          ShowCategory = 100;
          SortColumn = "CPUUsage";
          SortDirection = 0;
        };
      };
    };

    # Fully declarative dock using the latest from Nix Store
    local.dock.enable = true;
    local.dock.entries = [
      { path = "/Applications/Reminders.app/"; }
      { path = "/Applications/Notes.app/"; }
      {
        path = "/System/Applications/Messages.app/";
      }
      # { path = "/System/Applications/Facetime.app/"; }
      # { path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
      # { path = "/System/Applications/Music.app/"; }
      # { path = "/System/Applications/News.app/"; }
      # { path = "/System/Applications/Photos.app/"; }
      # { path = "/System/Applications/Photo Booth.app/"; }
      # { path = "/System/Applications/TV.app/"; }
      # { path = "/System/Applications/Home.app/"; }
      {
        path = "${config.users.users.${user}.home}/.local/share/";
        section = "others";
        options = "--sort name --view grid --display folder";
      }
      {
        path = "${config.users.users.${user}.home}/.local/share/downloads";
        section = "others";
        options = "--sort name --view grid --display stack";
      }
    ];
  };

}
