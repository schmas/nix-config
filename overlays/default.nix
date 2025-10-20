# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # Disable GTK+3 builds on Darwin by making it unsupported
    gtk3 = prev.gtk3.overrideAttrs (oldAttrs: {
      meta = oldAttrs.meta // {
        platforms = final.lib.platforms.linux;
      };
    });
    
    # Disable putty on Darwin (it depends on GTK+3)
    putty = prev.putty.overrideAttrs (oldAttrs: {
      meta = oldAttrs.meta // {
        platforms = final.lib.platforms.linux;
      };
    });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
