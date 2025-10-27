# Implementation Plan: Fix Critical Issues and Simplify Nix Configuration

**Status**: planning  
**Type**: fix  
**Created**: 2025-10-27  
**Last Updated**: 2025-10-27  
**Priority**: High  
**Complexity**: Medium

## Tracking Instructions

- Update status when moving between phases
- Update last updated date when making changes
- Keep this document current throughout implementation
- Move to `.tasks/in-progress/` when beginning implementation
- Move to `.tasks/done/` when complete

---

## 1. Feature Summary

- **Feature Name**: Fix Critical Configuration Issues and Remove isTesting Flag
- **Problem Statement**: The configuration has several critical bugs preventing features from working correctly, including broken isTesting logic, incorrect helka configuration, and non-existent overlay references. Additionally, the isTesting flag adds unnecessary complexity.
- **Success Criteria**: 
  - All configurations build successfully without errors
  - Helka uses correct home-manager configuration
  - Overlays reference only existing inputs
  - isTesting flag completely removed
  - Debug traces removed from production code
  - Package duplication between Nix and Homebrew resolved
- **Type**: fix
- **Priority**: High
- **Complexity**: Medium

---

## 2. Technical Approach

### Core Changes

1. **Remove isTesting Flag Completely**
   - Remove from flake.nix outputs (vesuvio-test configuration)
   - Remove from packages-darwin.nix
   - Remove from helka/default.nix
   - Remove from vesuvio/default.nix
   - Simplify to single configuration approach

2. **Fix Helka Configuration**
   - Correct home-manager import path
   - Fix package imports
   - Add proper user configuration
   - Add missing system.stateVersion

3. **Fix Overlays**
   - Remove reference to non-existent nixpkgs-unstable
   - Keep overlay structure as placeholder for future use

4. **Clean Up Package Management**
   - Remove duplicate packages between Nix and Homebrew
   - Remove debug traces
   - Flatten container package structure for consistency
   - Remove package filtering logic

5. **Use User Variable Consistently**
   - Replace hardcoded "schmas" with user variable throughout

### Configuration Changes

- **Flake Configuration**: Remove vesuvio-test configuration, remove isTesting specialArgs
- **Package Management**: Simplify darwin packages, remove brew duplicates
- **Platform Considerations**: Fix cross-platform package sharing
- **User Management**: Consistent use of user variable

---

## 3. Files and Sections to Modify

### Critical Fixes

#### `flake.nix`
- **Lines 93-103**: Remove entire `vesuvio-test` darwin configuration
- **Line 89**: Remove `isTesting = false;` from vesuvio specialArgs
- **Line 111**: Remove `isTesting` from helka if present

#### `hosts/common/packages/packages-darwin.nix`
- **Line 3**: Remove `isTesting` from function parameters
- **Line 9**: Remove debug `dummy` variable with builtins.trace
- **Lines 17-22**: Remove brew duplicates (openssl, podman, podman-compose)
- **Line 117**: Remove entire isTesting logic and `builtins.seq dummy`
- **Lines 107-110**: Remove filteredPackages filtering logic
- **Line 115**: Change to `packages = allPackages;`

#### `hosts/common/packages/packages.nix`
- **Lines 107-113**: Flatten container structure from nested to flat list
- **Line 147**: Update all-packages to use `packages_dict.container` directly
- **Lines 115-122**: Remove openssl, podman, podman-compose from respective sections

#### `hosts/vesuvio/default.nix`
- **Line 6**: Remove `isTesting` from function parameters
- **Line 10**: Remove `isTesting` from darwinPackages import
- **Line 33**: Replace `[ "schmas" ]` with `[ user ]`
- **Line 34**: Replace `users.schmas` with `users.${user}`

#### `hosts/helka/default.nix`
- **Line 6**: Remove `isTesting` from function parameters (if present)
- **Line 10**: Fix to `sharedPackages = import ../common/packages/packages.nix { inherit pkgs; };`
- **Line 27**: Replace `[ "schmas" ]` with `[ user ]`
- **Line 28**: Replace `users.schmas` with `users.${user}`
- **Line 28**: Add proper NixOS user attributes (isNormalUser, extraGroups)
- **Line 45**: Fix import to `../../home/schmas/helka.nix`
- **Line 51**: Add `home.packages = sharedPackages.all-packages;`
- **After line 47**: Add `system.stateVersion = "25.05";`

#### `overlays/default.nix`
- **Lines 17-22**: Fix unstable-packages overlay to use `inputs.nixpkgs` instead of non-existent `inputs.nixpkgs-unstable`

### Documentation Updates

#### `README.md`
- **Lines 13-14, 48**: Remove references to `--test` flag and vesuvio-test configuration

---

## 4. Implementation Steps

### Step 1: Remove isTesting Flag from Flake

**File**: `flake.nix`

1. Remove vesuvio-test configuration (lines 93-103)
2. Remove `isTesting = false;` from vesuvio specialArgs (line 89)

**Expected Result**: Single vesuvio configuration without testing variant

---

### Step 2: Fix Overlays

**File**: `overlays/default.nix`

1. Change line 18 from `inputs.nixpkgs-unstable` to `inputs.nixpkgs`

**Expected Result**: Overlay references existing input, no evaluation errors

---

### Step 3: Simplify Package Management

**File**: `hosts/common/packages/packages.nix`

1. Flatten container structure (lines 107-113)
2. Remove duplicate packages from security section (openssl line 117)
3. Remove duplicate packages from container section (podman, podman-compose)
4. Update all-packages concatenation (line 147)

**Expected Result**: Consistent flat package structure, no duplication

---

### Step 4: Fix Darwin Packages

**File**: `hosts/common/packages/packages-darwin.nix`

1. Remove `isTesting` parameter (line 3)
2. Remove debug trace `dummy` variable (line 9)
3. Clean up brews list - remove openssl, podman, podman-compose (lines 19-22)
4. Remove testingCasks list entirely (lines 25-31)
5. Remove filteredPackages logic (lines 107-110)
6. Simplify to `packages = allPackages;` (line 115)
7. Simplify casks assignment to `casks = fullCasks;` (line 117)

**Expected Result**: Clean darwin packages without testing logic or duplicates

---

### Step 5: Fix Vesuvio Configuration

**File**: `hosts/vesuvio/default.nix`

1. Remove `isTesting` parameter (line 6)
2. Update darwinPackages import to remove isTesting (line 10)
3. Replace hardcoded user with variable (lines 33-34)

**Expected Result**: Vesuvio uses user variable consistently

---

### Step 6: Fix Helka Configuration

**File**: `hosts/helka/default.nix`

1. Remove `isTesting` parameter if present (line 6)
2. Fix sharedPackages import path (line 10)
3. Remove `users.knownUsers` (not needed for NixOS)
4. Update user configuration (lines 27-32):
   - Replace hardcoded username with variable
   - Add `isNormalUser = true;`
   - Add `extraGroups = [ "wheel" ];`
5. Fix home-manager import to use helka.nix (line 45)
6. Add home.packages to home-manager config (after line 45)
7. Add system.stateVersion (after imports)

**Expected Result**: Helka builds successfully with correct configuration

---

### Step 7: Update README

**File**: `README.md`

1. Remove test installation instructions (lines 13-14)
2. Remove test installation example (line 48)
3. Simplify to single installation path per platform

**Expected Result**: Documentation reflects single configuration approach

---

## 5. Testing Strategy

### Build Testing

```bash
# Test flake evaluation
nix flake check --all-systems

# Test Darwin configuration build (dry-run)
nix build .#darwinConfigurations.vesuvio.system --dry-run

# Test NixOS configuration build (dry-run)
nix build .#nixosConfigurations.helka.system --dry-run

# Format check
nix fmt
```

### Platform Testing

**macOS (vesuvio)**:
```bash
# Build configuration
darwin-rebuild build --flake .#vesuvio
```

**Linux (helka)**:
```bash
# Build configuration
nixos-rebuild build --flake .#helka
```

### Integration Testing

- [ ] Verify all packages install correctly on Darwin
- [ ] Verify all packages install correctly on NixOS
- [ ] Verify no duplicate packages installed
- [ ] Verify homebrew brews install only urlview
- [ ] Verify user configuration correct on both platforms
- [ ] Test rollback functionality

---

## 6. Quality Gates

### Pre-Implementation
- [ ] All affected files identified
- [ ] Backup of current working configuration created
- [ ] Git status clean or changes stashed

### During Implementation
- [ ] Each file change tested independently
- [ ] No syntax errors introduced
- [ ] Nix formatting maintained (4 spaces, RFC 166 style)

### Post-Implementation
- [ ] Configuration builds successfully (`darwin-rebuild build` / `nixos-rebuild build`)
- [ ] Nix formatting passes (`nix fmt`)
- [ ] Flake check passes (`nix flake check`)
- [ ] No evaluation errors or warnings
- [ ] Package lists verified (no duplicates)
- [ ] User variable used consistently
- [ ] Documentation updated
- [ ] Ready for manual application with switch command

---

## 7. Risk Assessment

### Technical Risks

1. **Breaking Current Configuration**
   - **Risk**: Changes might prevent configuration from building
   - **Mitigation**: Test each change with dry-run builds before applying
   - **Rollback**: Use git to revert changes, or `darwin-rebuild --rollback`

2. **Package Availability**
   - **Risk**: Removing brew versions might cause issues if Nix packages don't work
   - **Mitigation**: Verify Nix packages work before removing brew versions
   - **Rollback**: Add back to brews list if needed

3. **Helka Configuration**
   - **Risk**: Extensive changes to helka might break Linux system
   - **Mitigation**: Test build thoroughly before applying, have backup config
   - **Rollback**: Use `nixos-rebuild --rollback` or boot from previous generation

4. **User Variable Changes**
   - **Risk**: Incorrect user variable usage could break user setup
   - **Mitigation**: Verify user variable is passed correctly through all levels
   - **Rollback**: Git revert if issues arise

### Performance Impact

- **Build Time**: Minimal impact, may slightly improve due to simpler evaluation
- **Disk Space**: May reduce slightly by removing duplicate packages
- **Evaluation Time**: Should improve without isTesting logic

### Security Considerations

- No new packages introduced
- Removing duplicates reduces attack surface
- No changes to security-related configurations

---

## 8. Review Considerations

### Code Quality
- Consistent formatting throughout
- Proper use of Nix idioms
- Clear variable naming
- Minimal commented code

### Architecture
- Simplified configuration without test variants
- Consistent package management approach
- Proper separation of platform-specific code

### Maintainability
- Easier to understand without testing flag
- Clear package ownership (Nix vs Homebrew)
- Consistent user variable usage
- Better documentation

### Testing
- Both platforms must build successfully
- All packages must be available
- No regressions in functionality

---

## 9. Additional Cleanup (Optional, Lower Priority)

These items from the analysis are lower priority and can be addressed in future sessions:

### Clean Up Commented Code
- Remove commented homeConfigurations from flake.nix
- Remove commented masApps from vesuvio
- Remove commented cask packages

### Evaluate Unused Inputs
- Review if disko and hardware inputs are needed
- Remove commented flake input alternatives

### Documentation Improvements
- Add inline comments for non-obvious decisions
- Document package categorization strategy
- Explain module placeholder purpose

---

## 11. Success Criteria Checklist

- [ ] isTesting flag completely removed from all files
- [ ] vesuvio-test configuration removed from flake
- [ ] Helka configuration builds successfully
- [ ] Helka uses correct helka.nix home-manager config
- [ ] Helka has proper package imports
- [ ] Overlays reference only existing inputs (nixpkgs, not nixpkgs-unstable)
- [ ] Debug traces removed
- [ ] No duplicate packages between Nix and Homebrew
- [ ] Container packages use flat structure like other categories
- [ ] User variable used consistently (no hardcoded "schmas")
- [ ] system.stateVersion added to helka
- [ ] Both configurations (vesuvio and helka) build successfully
- [ ] Documentation updated
- [ ] All quality gates passed

---

## Notes

- Empty module placeholders are intentionally kept for future use
- Overlay structure maintained for future custom packages
- Focus is on fixing critical issues while maintaining overall structure
- This plan addresses all critical (🔴) and several medium priority (🟡) issues from the analysis
- Lower priority issues can be addressed in subsequent sessions

