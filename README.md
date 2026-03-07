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
| "I have an idea for X" / "Let's plan Y" | **Proposal** — design doc with phases, acceptance criteria, and a GitHub issue per phase |
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

## License

MIT
