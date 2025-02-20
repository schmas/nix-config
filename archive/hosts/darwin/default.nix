{ pkgs, self, ... }:

{
  imports = [ ../../modules/shared ../../modules/darwin ];

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  system.stateVersion = 6;
}
