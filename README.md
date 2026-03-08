# Agent Skills

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-2-brightgreen)](#skills)
[![Claude Code](https://img.shields.io/badge/Claude_Code-compatible-blueviolet?logo=anthropic)](https://docs.anthropic.com/en/docs/claude-code)
[![Codex](https://img.shields.io/badge/Codex-compatible-brightgreen?logo=openai)](https://github.com/openai/codex)
[![Gemini CLI](https://img.shields.io/badge/Gemini_CLI-compatible-4285F4?logo=google)](https://github.com/google-gemini/gemini-cli)
[![OpenClaw](https://img.shields.io/badge/OpenClaw-compatible-orange)](https://github.com/openclaw/openclaw)

Reusable skills for AI coding agents — [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [Codex](https://github.com/openai/codex), [Gemini CLI](https://github.com/google-gemini/gemini-cli), and [OpenClaw](https://github.com/openclaw/openclaw).

Skills are modular instruction sets that teach your agent how your team works — your
templates, your conventions, your docs structure — so it gets it right the first time.

## Skills

| Skill | What it does |
|-------|-------------|
| [project-planner](#project-planner) | Turns ideas, bugs, and feature requests into structured GitHub issues and proposals |
| [docs-sync](#docs-sync) | Keeps docs in sync with code changes — updates, audits, and site navigation |

---

<a id="project-planner"></a>
### project-planner

**Turn vague ideas into structured, actionable project artifacts.**

You say "I have an idea for dark mode" or "search is broken on special characters" and
the skill figures out the right format, creates it in the right place, and follows your
project's conventions.

| You say... | Skill creates... |
|---|---|
| "I have an idea for X" / "Let's plan Y" | **Proposal** — design doc with phases, acceptance criteria, a tracking issue with native GitHub sub-issues per phase |
| "Add a button that does X" | **Feature issue** — focused GitHub issue with acceptance criteria |
| "X is broken when Y" | **Bug report** — GitHub issue with repro steps, expected vs actual, relevant code |

**Repo-aware** — discovers your `.github/ISSUE_TEMPLATE/` files, proposal templates,
`CLAUDE.md`/`CONTRIBUTING.md` conventions, and `.project-planner.yml` config. Works
out of the box with sensible defaults.

**Prerequisites:** Git, [GitHub CLI (`gh`)](https://cli.github.com/) authenticated via `gh auth login`

<details>
<summary>Optional per-repo config</summary>

Drop a `.project-planner.yml` at your repo root:

```yaml
project: MyProject                      # project name (used in issue titles)

proposals:
  dir: docs/proposals                   # where proposal docs live
  template: docs/proposals/TEMPLATE.md  # proposal template to follow

issues:
  labels:
    feature: enhancement                # label for feature issues
    bug: bug                            # label for bug issues
```

All fields are optional — anything you don't set gets auto-discovered or falls back to defaults.

</details>

<details>
<summary>Starter templates</summary>

If you're setting up a new repo and want issue templates and a config file to start from:

```bash
cd /path/to/your-project
/path/to/agent-skills/install.sh templates project-planner
```

Creates starter files you can customize (`.project-planner.yml`, issue templates,
proposal template). Won't overwrite existing files — use `--force` to replace them.

</details>

---

<a id="docs-sync"></a>
### docs-sync

**Your docs are always out of date. This skill fixes that.**

After a PR merges or code changes, it figures out which docs need updating and drafts
the changes.

**Three modes:**

- **Content sync** — reads a PR diff, identifies affected docs, drafts targeted updates
- **Site management** — maintains mkdocs/docusaurus/vitepress navigation and index files
- **Docs audit** — reports which docs are stale and what needs updating

| Code change | Docs updated |
|---|---|
| New UI component | Features list, architecture doc |
| Changed data model | Architecture doc |
| New keyboard shortcut | Features list |
| New API endpoint | API reference, possibly README |
| Changed build command | Contributing / conventions doc |

The skill maps each doc to a role (features, architecture, conventions, changelog, readme,
api) — auto-detected from filenames, or configured via `.docs-sync.yml`.

**Prerequisites:** Git, [GitHub CLI (`gh`)](https://cli.github.com/)

<details>
<summary>Optional per-repo config</summary>

Drop a `.docs-sync.yml` at your repo root:

```yaml
docs:
  - path: docs/features.md
    role: features

  - path: docs/architecture.md
    role: architecture

  - path: CHANGELOG.md
    role: changelog
    format: keep-a-changelog

site:
  engine: mkdocs
  config: mkdocs.yml
  auto_nav: true
```

</details>

---

## Installation

These skills work with any supported platform — install on one or all of them.

Each platform has a native install method. There's also a universal install script
that works across all of them.

### Native install

<details open>
<summary><strong>Claude Code</strong></summary>

Add the marketplace, then install one or both skills:
```bash
/plugin marketplace add chriscox/agent-skills
/plugin install project-planner@chriscox-skills
/plugin install docs-sync@chriscox-skills
```

Each skill is an independent plugin — install one, both, or neither.
Skills auto-activate based on context.

Or load from a local clone:
```bash
git clone https://github.com/chriscox/agent-skills.git
claude --plugin-dir ./agent-skills/plugins/project-planner
```

</details>

<details>
<summary><strong>Codex</strong></summary>

In any Codex session:

> Install skill from chriscox/agent-skills, path skills/&lt;skill-name&gt;

</details>

<details>
<summary><strong>Gemini CLI</strong></summary>

```bash
# install individual skills
gemini skills install https://github.com/chriscox/agent-skills.git --path skills/<skill-name>

# or link the entire repo (discovers all skills automatically)
git clone https://github.com/chriscox/agent-skills.git
gemini skills link ./agent-skills/skills
```

</details>

<details>
<summary><strong>OpenClaw</strong></summary>

```bash
clawhub install project-planner                 # install individual skills by name
clawhub install docs-sync
```

</details>

### Install script

A universal install script works across all platforms:

```bash
git clone https://github.com/chriscox/agent-skills.git
cd agent-skills
./install.sh list                               # see available skills
./install.sh skill <skill-name> --codex         # or --gemini, --openclaw, --all
```

## Why skills instead of CLAUDE.md?

You can absolutely write planning and docs-sync instructions directly in your
`CLAUDE.md` (or `AGENTS.md`, `GEMINI.md`, etc.). It works. But skills solve a
different problem — here's how they compare:

### What CLAUDE.md is great at

Your project file (`CLAUDE.md`) is the right place for things specific to *your* repo:
coding conventions, architecture decisions, build commands, tech stack choices. It's
visible, simple, and has zero dependencies.

### Where skills add value

Skills handle *workflows* — things that work the same way across every repo you touch.

**Install once, use everywhere.** A skill installed at user scope works in every repo
automatically. Writing "how to create a good proposal doc with phased issues" in
`CLAUDE.md` means copying those instructions into every repo — and updating all of
them when you improve the workflow.

**Cross-platform.** One skill definition works in Claude Code, Codex, Gemini CLI, and
OpenClaw. With project files, you'd maintain the same instructions in `CLAUDE.md` *and*
`AGENTS.md` *and* `GEMINI.md` — per repo.

**Small config replaces long instructions.** A 10-line `.project-planner.yml` replaces
pages of prompt engineering. The skill already knows how to triage ideas, structure
proposals, and file issues. You just tell it where your templates live.

**Centrally maintained.** When a skill improves — better edge-case handling, new
capabilities — you run `update` and get the improvements everywhere. With `CLAUDE.md`,
you maintain the instructions yourself and they drift over time.

**Repo-aware auto-discovery.** Skills discover your repo structure (issue templates,
docs layout, site config) automatically. In `CLAUDE.md` you'd spell out every path
and template explicitly.

### The short version

| | CLAUDE.md | Skills |
|---|---|---|
| Best for | Project-specific conventions | Cross-project workflows |
| Scope | One repo | Every repo you touch |
| Platforms | One agent | All supported agents |
| Maintenance | Manual, per repo | Central, update once |
| Config | Free-form instructions | Small YAML + auto-discovery |

They're complementary. `CLAUDE.md` tells the agent about *your project*. Skills teach
it reusable workflows that work the same way everywhere.

---

## Use cases

**Solo dev with many repos.** You work on a main project, a few side projects, some
open-source contributions. Install once at user scope — every repo gets consistent
planning and docs workflows without any per-repo setup.

**Team standardization.** Your team files issues in different formats. Some PRs update
docs, most don't. Everyone installs the same marketplace and gets the same issue
structure, the same docs-sync behavior, the same proposal format — without
maintaining a shared wiki page of "how to file a good issue."

**New repo bootstrap.** Starting a new project? `install.sh templates project-planner`
scaffolds issue templates, a proposal template, and config in seconds.
No copy-pasting from another repo.

**Multi-agent workflows.** Running an orchestrator (like OpenClaw) that spawns coding
agents? Both layers get the same skills — the orchestrator uses project-planner to
create issues, the coding agent uses docs-sync to update docs after implementing them.

**Cross-platform teams.** Some teammates prefer Claude Code, others use Codex or
Gemini CLI. Skills work identically across all of them — same behavior, same output
format, no per-tool instructions.

## License

MIT
