{ user, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ mise ];

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };
}
