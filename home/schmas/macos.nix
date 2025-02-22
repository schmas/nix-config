{ pkgs, ... }:
let home-base-dir = "Users"; in
{
  imports = [
    ./global
  ];

  _module.args = {
    home-base-dir = "Users";
  };

  # # Purple
  # wallpaper = pkgs.wallpapers.aenami-lost-in-between;

  # monitors = [
  #   {
  #     name = "eDP-1";
  #     width = 1920;
  #     height = 1080;
  #     workspace = "1";
  #     primary = true;
  #   }
  # ];
}
