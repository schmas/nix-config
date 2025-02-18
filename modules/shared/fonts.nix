{ pkgs, ... }: {
  fonts.packages = with pkgs; [
  nerd-fonts.meslo-lg
  nerd-fonts.jetbrains-mono
  nerd-fonts.geist-mono
  powerline-fonts
  ];
}