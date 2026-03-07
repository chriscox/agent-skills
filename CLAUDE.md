# CLAUDE.md

Instructions for AI agents working on this repository.

## What This Repo Is

A collection of reusable skills for AI coding agents (Claude Code, Codex, Gemini CLI, OpenClaw).
Each skill is a self-contained folder under `skills/` with a `SKILL.md` and optional
supporting files.

## Repo Structure

This repo is a **Claude Code plugin marketplace** and a **standalone skill collection**.

```
agent-skills/
├── .claude-plugin/
│   └── marketplace.json               # Marketplace catalog (chriscox-skills)
├── skills/                             # Canonical skill content (single source of truth)
│   └── <skill-name>/
│       ├── SKILL.md                   # Required: frontmatter + instructions
│       ├── <skill-name>.yml           # Optional: config template for per-repo overrides
│       ├── issue-templates/           # Optional: GitHub issue form templates
│       └── templates/                 # Optional: doc scaffolding templates
├── plugins/                            # Claude Code marketplace wrappers
│   └── <skill-name>/
│       ├── .claude-plugin/plugin.json # Per-plugin manifest
│       └── skills/<skill-name> →      # Symlink to ../../skills/<skill-name>
├── skills.json                        # Machine-readable skill index (keep in sync)
└── install.sh                         # Multi-platform installer (Codex, Gemini CLI, OpenClaw)
```

### Marketplace vs Standalone

- **As a marketplace** (Claude Code): users add with `/plugin marketplace add chriscox/agent-skills`,
  then install individual plugins with `/plugin install <name>@chriscox-skills`.
  Plugins use symlinks to the canonical `skills/` directory; Claude Code follows symlinks during copy.
- **As standalone skills** (Codex, Gemini CLI, OpenClaw): install via `install.sh`,
  native installer (`gemini skills install`), or manual copy. Uses `skills/` directly.

## Conventions

### Adding a New Skill

1. Create `skills/<skill-name>/SKILL.md` with proper frontmatter (`name` + `description`)
2. If the skill has per-repo config, add `<skill-name>.yml` at the skill root
3. If the skill provides GitHub issue templates, add them to `issue-templates/`
4. If the skill provides doc templates, add them to `templates/`
5. Create the marketplace plugin wrapper:
   - `plugins/<skill-name>/.claude-plugin/plugin.json` — manifest with `"skills": "./skills/"`
   - `plugins/<skill-name>/skills/<skill-name>` — symlink to `../../../skills/<skill-name>`
6. Add the plugin to `.claude-plugin/marketplace.json` with name, source, and description
7. Update `skills.json` with the new skill entry
6. Update the `README.md`:
   - Add to the skills table of contents
   - Add a full section with: problem, what it does, prerequisites, config, example
   - Update the skills count badge
7. Test with `./install.sh list`, `./install.sh skill <name>`, and `./install.sh templates <name>`

### Skill Quality Standards

- **Description must be comprehensive** — it's the only thing the agent reads to decide
  whether to load the skill. Include when to use it AND when not to.
- **Auto-discover before requiring config** — skills should work out of the box by
  discovering repo structure. Config files are for overrides, not requirements.
- **Be generic** — no project-specific content in templates or examples.
  Use generic placeholders.
- **Respect existing conventions** — skills should adapt to the user's repo, not impose
  their own structure.
- **Match existing style** — when updating docs, read them first. Don't reformat.

### install.sh

The installer uses folder-based conventions:
- `<skill-name>.yml` at skill root → installs as `.<skill-name>.yml` at repo root
- `issue-templates/*.yml` → installs to `.github/ISSUE_TEMPLATE/`
- `templates/**` → installs recursively to `docs/` (preserves subdirectories)

When modifying install.sh:
- Test all three subcommands: `list`, `skill`, `templates`
- Test `--force` and skip behavior
- Test with multiple skills installed
- Ensure `--help` exits 0, errors exit 1

### SKILL.md Frontmatter

```yaml
---
name: skill-name                       # Must match folder name
description: >
  Clear description of what the skill does. Include:
  - When to use it (numbered list of trigger conditions)
  - When NOT to use it (explicit exclusions)
---
```

### Commit Messages

Use clear, descriptive commit messages. For multi-concern commits, use a summary line
followed by a bulleted breakdown.

### Publishing to ClawHub

After merging changes, publish updated skills to ClawHub for OpenClaw users:

```bash
clawhub publish ./skills/project-planner --slug project-planner --name "Project Planner" --version <version>
clawhub publish ./skills/docs-sync --slug docs-sync --name "Docs Sync" --version <version>
```

Or sync all skills at once:

```bash
clawhub sync --all
```

Bump versions in `.claude-plugin/marketplace.json` and `plugins/*/. claude-plugin/plugin.json` to match.

### Branches

Never push directly to main. All changes go through PRs.
