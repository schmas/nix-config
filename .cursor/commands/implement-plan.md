# Implementation Plan Command

Build the feature referenced in the specific plan file following established engineering practices.

## Workflow

### Pre-Implementation

- Move the plan file to `.tasks/in-progress` to track active work
- Review the plan for completeness and dependencies
- Identify any missing requirements or clarifications needed
- Check for existing similar implementations to maintain consistency

### During Implementation

- Keep todo items in the plan file updated as changes are made
- Implement changes incrementally with logical checkpoints
- Test configuration changes with `darwin-rebuild build` or `nixos-rebuild build` (do NOT use switch - user will apply manually)
- Use `nix fmt` to format Nix files after changes
- Verify changes work correctly before proceeding
- Pause at logical boundaries to consider git commits and ask how to proceed

### Post-Implementation

- Verify all plan requirements are met
- Test configuration with appropriate rebuild command
- Update documentation if needed
- Move completed plan to `.tasks/done`

## Configuration Quality Standards

### Testing Strategy

- **Test with build command** - always use `darwin-rebuild build` or `nixos-rebuild build` (NEVER use switch - user applies manually)
- **Use production configuration** - test with actual configuration (vesuvio for macOS, helka for Linux)
- **Test incrementally** - verify each change builds successfully before proceeding
- **Check for errors** - review build output for warnings and errors
- **Verify package availability** - ensure packages exist in nixpkgs before adding
- **Test on both platforms** - verify changes work on macOS and Linux where applicable

### Code Style

- **Use 4 spaces for indentation** - consistent with project standards
- **Follow Nix RFC 166 formatting** - use `nixfmt-rfc-style` for formatting
- **Use meaningful variable names** - descriptive names like `darwinPackages`, not `dp`
- **Prefer let...in blocks** - for local bindings and clarity
- **Use explicit attribute paths** - with `inherit` where appropriate
- **Maintain consistency** - follow existing code patterns and conventions
- **Keep it modular** - separate concerns into different files
- **Limit inline comments** - add comments only for complex or non-obvious sections
- **Use structured attribute sets** - organize configurations logically

### Nix Configuration Best Practices

- **Prefer Nix over Homebrew** - only use Homebrew when necessary
- **Categorize packages** - organize by purpose (core, tools, dev, etc.)
- **Use common configurations** - share code between hosts via `hosts/common/`
- **Handle platform differences** - use conditional logic for macOS vs Linux
- **Filter duplicates** - prevent packages in both Nix and Homebrew
- **Document special cases** - add comments for non-obvious configurations
- **Respect immutability** - don't modify the Nix store directly
- **Check compatibility** - verify package availability on target platform

## Implementation Best Practices

### Incremental Development

- Build and test components individually before integration
- Make small, focused commits that can be easily reviewed
- Use feature flags or configuration to enable/disable new functionality
- Maintain backward compatibility where possible

### Error Handling

- Include proper validation for user inputs and file paths
- Implement appropriate error messages and logging
- Consider retry logic for transient failures
- Handle edge cases and boundary conditions

### Performance Considerations

- Test build times and optimize where possible
- Consider using binary caches for faster builds
- Be mindful of evaluation performance with large configurations
- Use lazy evaluation effectively in Nix expressions
- Monitor disk space usage with nix store
- Consider garbage collection strategy for old generations

### Security & Data Protection

- Validate package sources and checksums
- Be cautious with unfree packages
- Review security implications of new tools
- Handle secrets appropriately (never commit to repository)
- Consider using age or sops-nix for secrets management

## Quality Gates

Before considering implementation complete:

- [ ] All plan requirements implemented and tested
- [ ] Configuration builds successfully (`darwin-rebuild build` or `nixos-rebuild build`)
- [ ] Build output reviewed with no warnings or errors
- [ ] Nix formatting passes (`nix fmt`)
- [ ] Package availability verified in nixpkgs
- [ ] Documentation updated if needed (README, comments)
- [ ] Configuration follows project conventions
- [ ] Performance impact assessed (build times, system resources)
- [ ] Security considerations addressed
- [ ] Compatibility verified on target platforms (macOS/Linux)
- [ ] Ready for user to manually apply with switch command
