{ pkgs, inputs, lib, ... }:
{
  imports = [ ./global ];

  _module.args = {
    home-base-dir = "home";
  };
}
