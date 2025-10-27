# Analyze Code Command

This command performs comprehensive code analysis to understand behavior, identify issues, compare implementations, or document technical findings. Analysis results can inform new requests, support planning decisions, or serve as standalone technical documentation.

## Usage

```
@analyze-code
```

## What This Command Does

1. **Code Investigation**: Deep dive into specific code patterns, methods, classes, or components
2. **Comparison Analysis**: Compare different implementations, methods, or approaches
3. **Problem Identification**: Identify issues, inconsistencies, or potential bugs
4. **Behavior Documentation**: Document how specific features or components work
5. **Impact Assessment**: Analyze the impact of changes across the codebase
6. **Technical Discovery**: Understand complex interactions and dependencies

## Analysis Process

### Phase 1: Define Analysis Scope

Clarify what needs to be analyzed:

- **Analysis Type**:

  - Method comparison (e.g., different ways same functionality is implemented)
  - Code flow analysis (e.g., how data flows through components)
  - Problem investigation (e.g., why something isn't working as expected)
  - Pattern analysis (e.g., how a pattern is used across the codebase)
  - Impact analysis (e.g., what would be affected by a change)
  - Technical discovery (e.g., understanding how a feature works)

- **Target Components**: Specific classes, methods, modules, or features to analyze

- **Context**: What problem are we trying to understand or solve?

- **Outcome**: What should the analysis help us accomplish?

### Phase 2: Code Investigation

Gather relevant information:

- Read and examine relevant source files
- Identify key methods, classes, and patterns
- Trace data flow and control flow
- Document important behaviors and characteristics
- Note any issues, inconsistencies, or concerns

### Phase 3: Analysis and Documentation

Create comprehensive analysis including:

- Clear problem statement or analysis goal
- Detailed findings with code examples
- Comparison tables (if comparing implementations)
- Root cause identification (if investigating issues)
- Impact assessment (if relevant)
- Recommendations and action items

## Analysis Storage

**Destination**: All analyses are saved to `.tasks/analysis/[sequence-id]-[analysis-name].md`

**Sequence ID Generation**:

- Read `.tasks/.sequence` to get the last sequence ID (4 hex chars)
- Increment the hex value by 1 and update `.tasks/.sequence` with the new value
- Prefix the filename with the new sequence ID followed by a dash (e.g., `0001-ANALYSIS-NAME.md`)

**Naming Convention**: Use descriptive names that reflect the analysis content:

- `[seq-id]-METHOD-COMPARISON-[feature].md` - Comparing different method implementations
- `[seq-id]-ISSUE-INVESTIGATION-[problem].md` - Investigating specific issues
- `[seq-id]-FLOW-ANALYSIS-[feature].md` - Documenting data/control flow
- `[seq-id]-IMPACT-ASSESSMENT-[change].md` - Analyzing impact of changes
- `[seq-id]-PATTERN-USAGE-[pattern].md` - Documenting pattern usage

## Analysis Template

The command generates structured analysis following this pattern:

````markdown
# [Analysis Title]

## Problem Statement / Analysis Goal

**Clear description of what we're analyzing and why**

## Root Cause / Findings Summary

**Key findings and discoveries**

---

## Section 1: [First Area of Analysis]

**Location:** `[File path]` lines [X-Y]

### Behavior

```nix
# Relevant code snippets with explanations
```
````

### Characteristics

- ✅ Positive aspects or correct behavior
- ❌ Issues, problems, or incorrect behavior
- ⚠️ Warnings or potential concerns

### Used In

1. **[Location 1]** (line X) - Context
2. **[Location 2]** (line Y) - Context

---

## Section 2: [Second Area of Analysis]

[Repeat structure for additional sections]

---

## Comparative Analysis (if comparing implementations)

### Method 1 vs Method 2

| Aspect   | Method 1 | Method 2 |
| -------- | -------- | -------- |
| Behavior | ...      | ...      |
| Pros     | ...      | ...      |
| Cons     | ...      | ...      |
| Use Case | ...      | ...      |

---

## Why [Problem Occurs / Behavior Exists]

### Scenario

```
1. Step 1
   - Details
   - Impact

2. Step 2
   - Details
   - Impact

Problem:
- Root cause explanation
- Result: WRONG/CORRECT BEHAVIOR
```

---

## Impact Analysis (if relevant)

### Affected Components

- Component 1: How it's affected
- Component 2: How it's affected

### Risk Assessment

- **High Risk**: [Issues that could break functionality]
- **Medium Risk**: [Issues that could cause unexpected behavior]
- **Low Risk**: [Minor issues or improvements]

---

## Recommendations / Action Items

1. ✅ **[Priority]** - [Action item with rationale]
2. ⚠️ **[Priority]** - [Action item with rationale]
3. 📋 **[Priority]** - [Action item with rationale]

**Priority Levels:**

- ✅ Critical - Must address
- ⚠️ Important - Should address
- 📋 Nice to have - Consider addressing

---

## Summary

**Key Takeaways:**

- Main finding 1
- Main finding 2
- Main finding 3

**Next Steps:**

- Recommended action 1
- Recommended action 2

```

## Best Practices

### Investigation

- **Be thorough**: Read all relevant code, don't make assumptions
- **Use grep/search**: Find all usages of methods, classes, or patterns
- **Follow the data**: Trace how data flows through the system
- **Check tests**: Review test files for expected behavior documentation
- **Look for patterns**: Identify consistent patterns or inconsistencies

### Documentation

- **Be specific**: Include file paths, line numbers, and exact code snippets
- **Use code examples**: Show actual code, not pseudocode
- **Add context**: Explain why something matters, not just what it is
- **Visual markers**: Use ✅ ❌ ⚠️ to highlight findings
- **Be objective**: Present facts and evidence, not opinions

### Analysis Quality

- **Clear structure**: Organize findings logically
- **Complete coverage**: Don't leave gaps in the analysis
- **Actionable insights**: Provide clear recommendations
- **Link to broader context**: Connect findings to project goals
- **Reference standards**: Cite relevant patterns, principles, or best practices

## Integration with Workflow

Analysis results can lead to different actions:

1. **Create New Request**: Analysis identifies work needed → Use `@new-request`
2. **Inform Planning**: Analysis provides technical details → Reference in `@create-plan`
3. **Standalone Documentation**: Analysis documents complex behavior → Keep in `.tasks/analysis/`
4. **Support Decisions**: Analysis helps team make technical decisions

## When to Use This Command

Use code analysis when you need to:

- ✅ Understand why something behaves unexpectedly
- ✅ Compare different implementation approaches
- ✅ Document complex technical patterns
- ✅ Investigate potential issues or bugs
- ✅ Assess impact of proposed changes
- ✅ Build knowledge about unfamiliar code
- ✅ Support technical decision-making

Don't use for:

- ❌ Simple code reading (just read the file)
- ❌ Trivial findings that don't need documentation
- ❌ Obvious bugs that should be fixed immediately

## Example Use Cases

1. **Configuration Comparison**: "Analyze how package filtering works in `packages-darwin.nix` vs `packages.nix`"
2. **Issue Investigation**: "Why does the configuration fail to build when adding a specific package?"
3. **Flow Analysis**: "How do overlays get applied across different host configurations?"
4. **Pattern Analysis**: "How are conditional configurations used for macOS vs Linux?"
5. **Impact Assessment**: "What would be affected if we change the package categorization structure?"

This command helps create comprehensive technical analysis that supports better understanding, planning, and decision-making throughout the configuration development process.
