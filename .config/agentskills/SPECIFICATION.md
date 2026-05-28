# AgentSkills Specification

Personal reference for creating skills following [AgentSkills.io](https://agentskills.io) standard.

**Official Spec:** https://agentskills.io/specification
**Examples:** https://github.com/anthropics/skills
**Validator:** https://github.com/agentskills/agentskills/tree/main/skills-ref

## Quick Reference

### Directory Structure

```
skill-name/
├── SKILL.md              # Required: Core instructions
└── references/           # Optional: Detailed docs
    ├── format.md
    └── examples.md
```

### SKILL.md Format

**Required YAML frontmatter:**

```yaml
---
name: skill-name
description: What this skill does and when to use it. Include activation keywords.
---
```

**Optional fields:**

```yaml
---
name: skill-name
description: What this skill does and when to use it.
license: Apache-2.0
compatibility: Requires git, docker, and internet access
metadata:
  author: your-name
  version: "1.0"
allowed-tools: Bash(git:*) Read Write
---
```

### Field Constraints

| Field | Required | Constraints |
|-------|----------|-------------|
| `name` | Yes | 1-64 chars, lowercase + hyphens only, no leading/trailing hyphens |
| `description` | Yes | 1-1024 chars, describe what + when to use |
| `license` | No | License name or reference |
| `compatibility` | No | Max 500 chars, environment requirements |
| `metadata` | No | Key-value mapping |
| `allowed-tools` | No | Space-delimited pre-approved tools (experimental) |

### Naming Rules

**Valid names:**
- `pdf-processing` ✅
- `data-analysis` ✅
- `code-review` ✅

**Invalid names:**
- `PDF-Processing` ❌ (uppercase)
- `-pdf` ❌ (leading hyphen)
- `pdf--processing` ❌ (consecutive hyphens)
- `pdf_processing` ❌ (underscores)

## Body Content Guidelines

### Keep SKILL.md Under 500 Lines

Move detailed content to `references/` directory.

### Required Sections

- **When to Use This Skill** - Clear activation triggers
- **Core Workflows** - Step-by-step instructions
- **Examples** - Real usage examples

### Optional Sections

- Troubleshooting
- Reference documentation links
- Design philosophy

## Progressive Disclosure Pattern

Skills load in stages:

1. **Metadata (~100 tokens)** - Name + description (loaded at startup for all skills)
2. **Instructions (~5000 tokens)** - Full SKILL.md (loaded when skill activates)
3. **References (on demand)** - Reference files (loaded only when needed)

**Example:**

```markdown
## Core Workflow

[Essential steps here]

## Detailed Specification

See [references/format.md](references/format.md) for complete spec.
```

## Reference Files

Create `references/` directory for detailed docs:

```
references/
├── format.md          # Format specifications
├── workflows.md       # Detailed examples
├── troubleshooting.md # Common issues
└── api-reference.md   # API details
```

**Best practices:**
- Keep files focused (one topic per file)
- Use relative paths: `[format](references/format.md)`
- Avoid deep nesting (stay one level deep)
- Each file should be independently useful

## Description Best Practices

### Good Description

```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when user mentions PDFs, forms, or document extraction.
```

**Why it's good:**
- Lists specific capabilities
- Includes activation keywords
- Clear and concise

### Poor Description

```yaml
description: Helps with PDFs.
```

**Why it's poor:**
- Too vague
- No activation keywords
- Doesn't explain what it can do

## Validation

### Manual Checklist

- [ ] Directory name matches frontmatter `name` field
- [ ] Valid YAML frontmatter
- [ ] `name` is lowercase + hyphens (1-64 chars)
- [ ] `description` includes what + when (1-1024 chars)
- [ ] SKILL.md under 500 lines
- [ ] Core workflows included
- [ ] Examples provided
- [ ] References in separate files

### Automated Validation

```bash
# Clone validator
git clone https://github.com/agentskills/agentskills
cd agentskills/skills-ref

# Validate your skill
./validate /path/to/your-skill
```

## Common Patterns

### Activation Triggers in Description

Include keywords that should activate the skill:

```yaml
description: Manage sprints in project. Use when user asks about sprints, wants to start/close a sprint, or needs sprint progress.
```

Keywords: "sprints", "start sprint", "close sprint", "sprint progress"

### Step-by-Step Workflows

Number workflows and provide clear steps:

```markdown
### 1. Check Current State

```bash
# Check for existing config
ls .config/
```

### 2. Create Configuration

```bash
cat > config.yaml << 'EOF'
setting: value
EOF
```
```

### Reference Links

Use relative paths from skill root:

```markdown
See [the format reference](references/format.md) for details.
```

## File Size Guidelines

| File | Max Size | Reason |
|------|----------|--------|
| SKILL.md | ~500 lines | Core instructions, loaded on activation |
| references/*.md | ~300 lines | Focused docs, loaded on demand |

**If SKILL.md exceeds 500 lines:**
1. Identify sections that are detailed specifications
2. Move those sections to `references/`
3. Replace with brief summary + link to reference

## Example Structure

```
my-skill/
├── SKILL.md (250 lines)
│   ├── Frontmatter (10 lines)
│   ├── When to Use (20 lines)
│   ├── Core Workflows (150 lines)
│   ├── Troubleshooting (50 lines)
│   └── References (20 lines)
└── references/
    ├── format.md (200 lines)
    ├── workflows.md (300 lines)
    └── api-reference.md (400 lines)
```

## Tool Allowlisting (Experimental)

Pre-approve tools in frontmatter:

```yaml
allowed-tools: Bash(git:*) Bash(npm:*) Read Write
```

**Format:**
- Tool name: `Bash`, `Read`, `Write`
- Optional filter: `(git:*)` allows git commands only
- Space-delimited list

**Note:** Support varies by agent implementation.

## Resources

- **Official Specification:** https://agentskills.io/specification
- **What are skills:** https://agentskills.io/what-are-skills
- **Integration guide:** https://agentskills.io/integrate-skills
- **Example skills:** https://github.com/anthropics/skills
- **Validator library:** https://github.com/agentskills/agentskills/tree/main/skills-ref
- **GitHub repo:** https://github.com/agentskills/agentskills

## Version History

- **2026-02-16:** Created personal reference from agentskills.io spec
