# Generate Commit Message Command

This command analyzes your git changes and generates a properly formatted commit message following the established commit guidelines. It reviews staged and unstaged changes to create an appropriate commit message without executing the commit.

## Usage

```
@generate-commit-message
```

## What This Command Does

1. **Reviews Git Changes**: Checks both staged and unstaged changes in your working directory
2. **Analyzes Change Scope**: Determines which files and modules are affected
3. **Classifies Change Type**: Identifies whether changes are features, fixes, refactors, docs, style, or chore
4. **Determines Scope**: Identifies the appropriate scope based on affected modules/components
5. **Generates Message**: Creates a properly formatted commit message following guidelines
6. **Outputs Only**: Displays the commit message without executing any git commands

## Commit Message Analysis Process

### Phase 1: Git Status Review

The command reviews your current changes:

```bash
# Check status
git status

# Review unstaged changes
git diff

# Review staged changes
git diff --staged
```

### Phase 2: Change Classification

Based on the git diff, the command classifies changes into:

- **feat**: New functionality, new packages, new configurations, new features
- **fix**: Bug fixes, corrections, configuration fixes
- **refactor**: Code improvements without behavior changes
- **docs**: Documentation updates, README changes, comment updates
- **style**: Formatting, whitespace, code style (no logic changes)
- **chore**: Dependency updates, flake updates, build updates

### Phase 3: Scope Determination

Identifies the appropriate scope based on affected areas:

#### System-based Scopes

- `darwin`: macOS/nix-darwin specific configurations
- `nixos`: Linux/NixOS specific configurations
- `home`: Home Manager configurations
- `vesuvio`: vesuvio host-specific changes
- `helka`: helka host-specific changes

#### Module-based Scopes

- `packages`: Package list changes
- `fonts`: Font configuration
- `shells`: Shell configuration (fish, nushell, etc.)
- `homebrew`: Homebrew package management
- `dock`: macOS dock configuration
- `flake`: Flake configuration changes

#### Feature-based Scopes

- `dev`: Development tools and environments
- `security`: Security tools (1password, gpg, etc.)
- `vcs`: Version control system tools (git, gh, lazygit)
- `containers`: Container tools (podman, docker)
- `editors`: Editor configurations (vim, neovim, etc.)
- `monitoring`: System monitoring tools (btop, neofetch)

#### Infrastructure Scopes

- `docs`: Documentation
- `nix`: Nix configuration and settings
- `overlays`: Nixpkgs overlays
- `modules`: Custom Nix modules
- `core`: Core functionality affecting multiple areas

### Phase 4: Message Generation

Generates a commit message following this format:

```
type(scope): brief description
```

**Guidelines Applied:**

- Uses imperative mood ("add" not "adds")
- Keeps message under 50 characters when possible
- No period at end of subject line
- Specific and clear description
- References issue numbers if found in branch name

### Phase 5: Multi-line Messages (if needed)

For complex changes affecting multiple areas, generates multi-line format:

```
type(scope): brief description

- Detail 1: specific change area
- Detail 2: another change area
- Detail 3: additional context
```

## Output Format

The command outputs ONLY the commit message in one of these formats:

### Single-line (preferred for focused changes):

```
feat(packages): add neovim and tree-sitter
```

### Multi-line (for complex changes):

```
refactor(darwin): reorganize package configuration

- Extract darwin-specific packages into separate file
- Add package filtering to prevent duplicates
- Improve package categorization structure
```

### With branch context (when issue number in branch):

```
feat(homebrew): add development tools

- Add homebrew cask packages for development
- Update package filtering logic
- Configure dock applications
```

## Usage Examples

### Example 1: Feature Addition

```
# Changes: Added new packages to packages.nix
# Output: feat(packages): add ast-grep and nixd LSP
```

### Example 2: Bug Fix

```
# Changes: Fixed fish shell configuration issue
# Output: fix(shells): correct fish shell initialization
```

### Example 3: Flake Update

```
# Changes: Updated flake.lock with newer nixpkgs
# Output: chore(flake): update nixpkgs to latest unstable
```

### Example 4: Multiple File Changes

```
# Changes: Updated configuration across darwin and home manager
# Output:
# refactor(config): standardize user environment setup
#
# - Update darwin system configuration
# - Align home manager settings
# - Add consistent shell aliases
```

### Example 5: Documentation Changes

```
# Changes: Updated README.md with new installation steps
# Output: docs(readme): add manual installation instructions
```

## Branch Context Detection

If your branch name includes an issue number (e.g., `feature/123-add-neovim-config`), the command will:

1. Extract the issue number (123)
2. Include it in the commit message when appropriate
3. Format: `type(scope): description for issue #123`

## Best Practices

### Message Quality

- Be specific about what changed, not why (save "why" for PR descriptions)
- Focus on the primary change if multiple files affected
- Use active voice: "add feature" not "feature added"
- Avoid technical jargon in the brief description

### Scope Selection

- Use the most specific applicable scope
- When changes span multiple scopes, choose the primary one
- For cross-cutting changes, use `core` scope
- For build/tooling changes, use `build` or `chore`

### Change Size

- If output suggests very complex multi-line message, consider splitting commit
- Atomic commits are preferred (one logical change per commit)
- Large changes should be broken into smaller, focused commits

## Command Output Only

**Important**: This command only OUTPUTS the commit message. It does not:

- Stage files (`git add`)
- Create commits (`git commit`)
- Push changes (`git push`)

After reviewing the generated message, you can:

1. Use it directly:

```bash
git add . && git commit -m "feat(packages): add neovim and tree-sitter" && git push
```

2. Modify it if needed:

```bash
git add . && git commit -m "feat(packages): add neovim with LSP support" && git push
```

3. Use for multi-line commit:

```bash
echo "feat(packages): add development tools

- Add neovim and tree-sitter
- Add nixd LSP for Nix development
- Update editor configuration" > .git/COMMIT_EDITMSG && git commit -F .git/COMMIT_EDITMSG && git push
```

## Integration with Workflow

This command fits into the commit workflow:

1. **Make Changes**: Implement your feature/fix
2. **Review Changes**: Run `git status` and `git diff` manually if desired
3. **Generate Message**: Use `@generate-commit-message` to get suggested commit message
4. **Review Output**: Verify the message accurately describes your changes
5. **Commit**: Use the generated message with your preferred git commit method
6. **Push**: Push your changes to remote

## When to Use This Command

Use this command when:

- ✅ You have uncommitted changes ready to commit
- ✅ You want a properly formatted commit message
- ✅ You're unsure about the best type or scope to use
- ✅ You want consistency with team commit standards
- ✅ You're working on a branch with multiple types of changes

Don't use this command for:

- ❌ Checking what changed (use `git status` and `git diff` directly)
- ❌ Actually committing changes (use `git commit` after getting the message)
- ❌ Reviewing code quality (use code review tools)

## Quality Checks

The command considers these quality aspects:

1. **Accuracy**: Message reflects actual changes in the diff
2. **Specificity**: Clear what was changed, not vague descriptions
3. **Format Compliance**: Follows type(scope): description format
4. **Length**: Brief description under 50 characters when possible
5. **Grammar**: Imperative mood, no trailing periods
6. **Context**: Includes ticket numbers when found in branch name

This command helps maintain consistent, high-quality commit messages across the codebase while following established conventions and best practices.
