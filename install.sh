#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"

usage() {
  cat <<'EOF'
Usage:
  install.sh skill <skill-name> [--claude|--codex|--gemini|--openclaw|--all]
  install.sh templates <skill-name> [--force]
  install.sh list

Commands:
  skill       Install a skill for one or more platforms (default: Claude Code)
  templates   Copy config and issue templates to the current directory
  list        List available skills
EOF
}

list_skills() {
  echo "Available skills:"
  for dir in "$SKILLS_DIR"/*/; do
    if [ -f "$dir/SKILL.md" ]; then
      printf "  %s\n" "$(basename "$dir")"
    fi
  done
}

install_to_dir() {
  local src="$1" dest="$2" platform="$3"
  mkdir -p "$dest"
  cp -R "$src"/. "$dest"/
  echo "  $platform -> $dest"
}

install_skill() {
  local skill_name="$1"; shift
  local skill_src="$SKILLS_DIR/$skill_name"

  if [ ! -d "$skill_src" ]; then
    echo "Error: Skill '$skill_name' not found in $SKILLS_DIR/"
    list_skills
    exit 1
  fi

  local claude=false codex=false gemini=false openclaw=false
  if [ $# -eq 0 ]; then claude=true; fi

  while [ $# -gt 0 ]; do
    case "$1" in
      --claude)   claude=true ;;
      --codex)    codex=true ;;
      --gemini)   gemini=true ;;
      --openclaw) openclaw=true ;;
      --all)      claude=true; codex=true; gemini=true; openclaw=true ;;
      *) echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
  done

  echo "Installing '$skill_name'..."

  if [ "$claude" = true ]; then
    install_to_dir "$skill_src" "$HOME/.claude/skills/$skill_name" "Claude Code"
  fi
  if [ "$codex" = true ]; then
    install_to_dir "$skill_src" "${CODEX_HOME:-$HOME/.codex}/skills/$skill_name" "Codex"
  fi
  if [ "$gemini" = true ]; then
    install_to_dir "$skill_src" "$HOME/.gemini/skills/$skill_name" "Gemini CLI"
  fi
  if [ "$openclaw" = true ]; then
    install_to_dir "$skill_src" "$HOME/.openclaw/skills/$skill_name" "OpenClaw"
  fi

  echo "Done."
}

copy_if_needed() {
  local src="$1" dest="$2" force="$3"
  if [ -f "$dest" ] && [ "$force" = false ]; then
    echo "  Skipped $(basename "$src") (already exists)"
    return
  fi
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  echo "  Copied $(basename "$src") -> $dest"
}

install_templates() {
  local skill_name="$1"; shift
  local skill_src="$SKILLS_DIR/$skill_name"
  local force=false

  if [ ! -d "$skill_src" ]; then
    echo "Error: Skill '$skill_name' not found in $SKILLS_DIR/"
    exit 1
  fi

  while [ $# -gt 0 ]; do
    case "$1" in
      --force) force=true ;;
      *) echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
  done

  # Config file: <skill>.yml -> .<skill>.yml
  if [ -f "$skill_src/$skill_name.yml" ]; then
    copy_if_needed "$skill_src/$skill_name.yml" ".$skill_name.yml" "$force"
  fi

  # Issue templates: issue-templates/*.yml -> .github/ISSUE_TEMPLATE/
  for tmpl in "$skill_src"/issue-templates/*.yml; do
    [ -f "$tmpl" ] || continue
    copy_if_needed "$tmpl" ".github/ISSUE_TEMPLATE/$(basename "$tmpl")" "$force"
  done

  # Doc templates: templates/** -> docs/
  if [ -d "$skill_src/templates" ]; then
    find "$skill_src/templates" -type f | while read -r tmpl; do
      local rel="${tmpl#"$skill_src/templates/"}"
      copy_if_needed "$tmpl" "docs/$rel" "$force"
    done
  fi
}

# --- Main ---

if [ $# -lt 1 ]; then usage; exit 1; fi

case "$1" in
  skill)
    [ $# -lt 2 ] && { usage; exit 1; }
    install_skill "${@:2}"
    ;;
  templates)
    [ $# -lt 2 ] && { usage; exit 1; }
    install_templates "${@:2}"
    ;;
  list)
    list_skills
    ;;
  -h|--help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown command: $1"
    usage
    exit 1
    ;;
esac
