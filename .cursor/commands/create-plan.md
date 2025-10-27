# Create Plan Command

This command creates comprehensive implementation plans for any type of development work, covering requirements clarification, technical planning, testing strategy, and quality gates. It ensures thorough preparation before implementation begins.

## Usage

```
@create-plan
```

## What This Command Does

1. **Requirements Clarification**: Guides you through clarifying feature requirements, scope, and success criteria
2. **Feature Classification**: Determines the type of change (fix, feature, refactor, chore, documentation)
3. **Impact Analysis**: Identifies core app changes and files/sections that will be modified
4. **Testing Strategy**: Defines comprehensive unit test approach and test files
5. **Implementation Planning**: Creates structured implementation steps with dependencies
6. **Risk Assessment**: Identifies potential risks and mitigation strategies
7. **Quality Gates**: Establishes checkpoints and validation criteria

## Planning Process

### Phase 1: Requirements Clarification

The command will ask you to clarify:

- **Feature Clarity**: What exactly is being requested?
- **Problem Statement**: What problem does this solve?
- **Success Criteria**: How do we know it's complete?
- **Scope Definition**: What's included/excluded?

### Phase 2: Feature Classification

Classifies your work into one of these types:

- **fix**: Bug fixes and corrections
- **feature**: New functionality and capabilities
- **refactor**: Code improvements without changing behavior
- **chore**: Maintenance tasks and tooling updates
- **documentation**: Documentation updates and improvements

### Phase 3: Impact Analysis

Creates a comprehensive analysis of:

- Core application changes required
- Specific files and sections to be modified
- Dependencies and integration points
- Configuration changes (if applicable)

### Phase 4: Testing Strategy

Defines testing approach including:

- Unit test files to create/modify
- Test scenarios and edge cases
- Integration test requirements
- Performance test considerations

### Phase 5: Implementation Planning

Creates structured implementation steps:

- Git branch creation (if on develop branch)
- Sequential development phases
- File modification order
- Testing checkpoints
- Quality gates and validation

## Plan Storage and Tracking

**Destination**: All plans are saved to `.tasks/planning/[sequence-id]-[feature-name]-plan.md`

**Sequence ID Generation**:

- Read `.tasks/.sequence` to get the last sequence ID (4 hex chars)
- Increment the hex value by 1 and update `.tasks/.sequence` with the new value
- Prefix the filename with the new sequence ID followed by a dash (e.g., `0001-feature-name-plan.md`)

**Plan Header Template**: Each plan includes tracking information in the header:

```markdown
# Implementation Plan: [Feature Name]

**Status**: [planning/in-progress/done/canceled]
**Type**: [fix/feature/refactor/chore/documentation]
**Created**: [Date]
**Last Updated**: [Date]
**Assigned**: [Developer]
**Review Date**: [Date]

## Tracking Instructions

- Update status when moving between phases
- Update last updated date when making changes
- Add review date when plan is ready for team review
- Keep this document current throughout implementation
```

## Example Output

The command generates a structured plan including:

```markdown
# Implementation Plan: [Feature Name]

## 1. Feature Summary

- **Feature Name**: [Clear, descriptive name]
- **Problem Statement**: [What problem this solves]
- **Success Criteria**: [How we know it's complete]
- **Type**: [fix/feature/refactor/chore/documentation]
- **Priority**: [High/Medium/Low]
- **Complexity**: [Simple/Medium/Complex]

## 2. Technical Approach

- **Configuration Changes**: [What needs to be modified]
- **Package Changes**: [New packages or removals]
- **Dependencies**: [What other modules are affected]
- **Platform Considerations**: [macOS-only, Linux-only, or cross-platform]
- **Flake Input Changes**: [New inputs or updates needed]

## 3. Files and Sections to Modify

### Configuration Files

- `flake.nix` - [Flake configuration changes, if any]
- `hosts/[hostname]/default.nix` - [Host-specific changes]
- `hosts/common/[module]/[file].nix` - [Shared configuration changes]
- `home/schmas/[hostname].nix` - [Home Manager changes]

### Package Files

- `hosts/common/packages/packages.nix` - [Cross-platform package changes]
- `hosts/common/packages/packages-darwin.nix` - [macOS-specific package changes]

### Module Files

- `modules/[type]/[module].nix` - [Custom module changes, if any]
- `overlays/default.nix` - [Package overlay changes, if any]

## 4. Testing Strategy

### Build Testing

- Test configuration builds without errors
- Verify package availability in nixpkgs
- Check for evaluation warnings

### Platform Testing

- Test on macOS (vesuvio) if darwin-specific
- Test on Linux (helka) if nixos-specific  
- Test on both platforms if cross-platform

### Integration Testing

- Verify configuration applies successfully
- Test package functionality after installation
- Verify no conflicts with existing packages
- Test rollback if needed

## 5. Implementation Steps

### Phase 0: Create Git Branch (if on develop)

1. Ensure you're on the latest `develop` branch: `git checkout develop && git pull origin develop`
2. Create a new feature/fix branch: `git checkout -b [type]/[feature-name]`
3. Verify branch creation: `git branch --show-current`

**Note**: This phase is only included if you're currently on the `develop` branch. The agent will ask before creating the branch.

---

1. **Step 1**: [Specific implementation step]
2. **Step 2**: [Next implementation step]
3. **Step 3**: [Final implementation step]

## 6. Quality Gates

- [ ] Configuration review requirements
- [ ] Build verification completed
- [ ] Performance impact assessed
- [ ] Documentation updates
- [ ] Configuration builds successfully (`darwin-rebuild build` or `nixos-rebuild build`)
- [ ] Nix formatting passes (`nix fmt`)
- [ ] Build output reviewed with no errors or warnings
- [ ] Package functionality verified
- [ ] Rollback tested (if applicable)
- [ ] Ready for user to manually apply with switch command

## 7. Risk Assessment

- **Technical Risks**: [Build failures, package conflicts, evaluation errors]
- **Mitigation Strategies**: [How to address risks]
- **Rollback Plan**: [Use `darwin-rebuild --rollback` or `nixos-rebuild --rollback`]
- **Performance Impact**: [Build time, disk space, evaluation time]
- **Security Considerations**: [Package sources, unfree packages, secrets handling]

## 8. Review Considerations

- [Build time implications]
- [Security considerations for new packages]
- [Compatibility across macOS and Linux]
- [Impact on existing configurations]
```

## Quality Gates

Before proceeding with implementation, the plan ensures:

- ✅ All clarification questions are answered
- ✅ Feature type is correctly classified
- ✅ Git branch strategy defined (if on develop branch)
- ✅ All affected files are identified
- ✅ Comprehensive test strategy is defined
- ✅ Implementation plan is complete and actionable
- ✅ Quality gates and checkpoints are established
- ✅ Risks are identified with mitigation strategies
- ✅ Review considerations are documented
- ✅ Manual commit/push instructions provided (no auto-commit/push)

## Best Practices

### Planning

- Be specific about functionality, not general goals
- Define clear acceptance criteria and success metrics
- Include comprehensive test cases with expected results
- Be specific about file paths and sections to modify
- Identify all dependencies and integration points
- Establish quality gates at each implementation phase
- Consider performance, security, and compatibility implications
- Plan for rollback scenarios
- Include team review requirements for complex changes

### Git Workflow

- **Always ask before creating a branch**: The agent will check if you're on `develop` and ask permission before creating a feature/fix branch
- **Branch naming convention**: Use `[type]/[feature-name]` format (e.g., `fix/CCS-4759-mpp-draft-pending-transition` or `feature/CCS-1234-new-payment-flow`)
- **No auto-commit/push**: Plans will include a final review phase with clear instructions to commit and push manually
- **Clean separation**: All work happens on feature branches, keeping `develop` stable

### Configuration Quality

- Follow Nix best practices: use 4-space indentation, RFC 166 formatting, meaningful variable names
- Keep configurations modular: separate concerns into different files
- Use common configurations: share code between hosts via `hosts/common/`
- Prefer Nix over Homebrew: only use Homebrew when Nix packages are unavailable or problematic
- Document special cases: add comments for non-obvious configurations

## Integration with Implementation Workflow

This command works seamlessly with the `@implement-plan` command:

1. **Create Plan**: Use `/create-plan` to generate comprehensive planning documentation
   - Agent checks if you're on `develop` branch
   - Asks permission before including branch creation steps
   - Includes manual commit/push instructions (no auto-commit/push)
2. **Review & Approve**: Team reviews the plan in `.tasks/planning/`
3. **Create Branch**: If not already created, create feature/fix branch from develop
4. **Move to Active**: Plan is moved to `.tasks/in-progress/` when implementation begins
5. **Implement**: Use `/implement-plan` to follow the structured implementation process
6. **Manual Commit**: User commits and pushes changes manually when ready
7. **Complete**: Move finished plan to `.tasks/done/`

### Git Workflow Integration

**Branch Creation Flow**:

```
Current Branch Check
    ↓
If on 'develop' → Ask user: "Create feature branch?"
    ↓
User confirms → Include "Phase 0: Create Git Branch" in plan
    ↓
User declines → Skip branch creation phase
    ↓
Plan includes manual commit/push instructions at end
```

**Key Principles**:

- ✅ Always ask before creating branches
- ✅ Never auto-commit or auto-push
- ✅ Include clear manual commit/push instructions
- ✅ Provide suggested branch names following naming conventions
- ✅ Include rollback instructions for branch management

This command helps ensure that all development work is thoroughly planned with clear requirements, comprehensive testing approaches, quality gates, and proper git workflow integration before implementation begins, enabling effective team review and approval processes.
