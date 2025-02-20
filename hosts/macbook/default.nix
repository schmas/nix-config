{ pkgs, inputs, ... }:

{
  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  system.stateVersion = 6;
}
