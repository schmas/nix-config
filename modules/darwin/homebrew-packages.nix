{ pkgs, ... }: {
  homebrew = {
    enable = true;
    brews = [ "urlview" "mise" "openssl" ];
    casks = [
      "1password"
      "bartender"
      "cleanshot"
      "doll"
      "ghostty"
      "google-chrome"
      "gpg-suite"
      "leader-key"
      "monitorcontrol"
      "pixelsnap"
      "rectangle-pro"
      "slack"
      "textmate"
      "visual-studio-code"
      "vivaldi"
      "zed"
    ];
    onActivation = {
      #cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
