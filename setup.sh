#!/usr/bin/env bash
# Applies setup.yaml to this terminal. setup.yaml is the single source of
# truth: change what gets provisioned there, not here.
#
# Usage:
#   ./setup.sh          validate setup.yaml, then provision the terminal
#   ./setup.sh --check  only validate setup.yaml against the repository
set -euo pipefail

cd "$(dirname "$0")"

MANIFEST=setup.yaml
ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"

[ -f "$MANIFEST" ] || {
  echo "$MANIFEST not found next to setup.sh" >&2
  exit 1
}

# setup.yaml is a constrained YAML subset (top-level key holding a block list
# of plain strings) so a fresh machine can read it without yq or Python.
manifest() {
  awk -v section="$1" '
    /^[[:space:]]*#/ { next }
    /^[A-Za-z0-9_]+:/ { current = $0; sub(/:.*/, "", current); next }
    /^[[:space:]]*-[[:space:]]+/ {
      if (current == section) {
        sub(/^[[:space:]]*-[[:space:]]+/, "")
        sub(/[[:space:]]+$/, "")
        gsub(/^"|"$/, "")
        print
      }
    }
  ' "$MANIFEST"
}

arrow_src() { printf '%s\n' "${1%% -> *}"; }
arrow_dest() { printf '%s\n' "${1##* -> }"; }
expand_home() { printf '%s\n' "${1/#\~/$HOME}"; }

check_manifest() {
  local section entry src ok=0
  for section in files dirs git_clones skills; do
    while IFS= read -r entry; do
      case "$entry" in
        *" -> "*) ;;
        *)
          echo "$MANIFEST: '$entry' in '$section' is not a 'SRC -> DEST' entry" >&2
          ok=1
          continue
          ;;
      esac
      src=$(arrow_src "$entry")
      case "$section" in
        files | dirs)
          [ -e "$src" ] || {
            echo "$MANIFEST: $section entry '$src' does not exist in the repository" >&2
            ok=1
          }
          ;;
        skills)
          [ "$src" = all ] || [ -f "skills/$src/SKILL.md" ] || {
            echo "$MANIFEST: skills entry '$src' has no skills/$src/SKILL.md" >&2
            ok=1
          }
          ;;
      esac
    done < <(manifest "$section")
  done
  return "$ok"
}

install_apt_packages() {
  [ -n "$(manifest apt_packages)" ] || return 0
  sudo apt-get update
  # DEBIAN_FRONTEND: -y alone does not suppress debconf prompts, which would
  # hang unattended provisioning on a fresh machine.
  manifest apt_packages | xargs -r sudo DEBIAN_FRONTEND=noninteractive apt-get install -y
}

copy_files() {
  local entry src dest
  while IFS= read -r entry; do
    src=$(arrow_src "$entry")
    dest=$(expand_home "$(arrow_dest "$entry")")
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
  done < <(manifest files)
}

copy_dirs() {
  local entry src dest
  while IFS= read -r entry; do
    src=$(arrow_src "$entry")
    dest=$(expand_home "$(arrow_dest "$entry")")
    # Merge into the destination; `cp -r SRC DEST` would nest SRC inside an
    # already-existing DEST on re-runs.
    mkdir -p "$dest"
    cp -r "$src/." "$dest/"
  done < <(manifest dirs)
}

clone_repos() {
  local entry url dest
  while IFS= read -r entry; do
    url=$(arrow_src "$entry")
    dest=$(expand_home "$(arrow_dest "$entry")")
    [ -d "$dest" ] || git clone "$url" "$dest"
  done < <(manifest git_clones)
}

append_zshrc_sources() {
  local target line
  [ -n "$(manifest zshrc_source)" ] || return 0
  mkdir -p "$(dirname "$ZSHRC")"
  touch "$ZSHRC"
  while IFS= read -r target; do
    line="source $target"
    grep -qxF "$line" "$ZSHRC" || printf '%s\n' "$line" >>"$ZSHRC"
  done < <(manifest zshrc_source)
}

install_skills() {
  local entry name agent
  while IFS= read -r entry; do
    name=$(arrow_src "$entry")
    agent=$(arrow_dest "$entry")
    if [ "$name" = all ]; then
      gh skill install . --from-local --all --agent "$agent" --scope user --force
    else
      gh skill install . "$name" --from-local --agent "$agent" --scope user --force
    fi
  done < <(manifest skills)
}

add_claude_plugins() {
  local entry
  # The claude installer places the binary in ~/.local/bin, which is not on
  # PATH yet in this non-interactive shell (only future shells pick it up).
  export PATH="$HOME/.local/bin:$PATH"
  while IFS= read -r entry; do
    claude plugin marketplace add "$entry"
  done < <(manifest claude_marketplaces)
  while IFS= read -r entry; do
    claude plugin install "$entry"
  done < <(manifest claude_plugins)
}

install_npm_globals() {
  manifest npm_globals | xargs -r npm install -g
}

run_commands() {
  local cmd
  while IFS= read -r cmd; do
    bash -c "$cmd"
  done < <(manifest "$1")
}

check_manifest
if [ "${1:-}" = --check ]; then
  echo "$MANIFEST: OK"
  exit 0
fi

install_apt_packages
copy_files
copy_dirs
clone_repos
append_zshrc_sources
install_skills
run_commands installers
add_claude_plugins
install_npm_globals
run_commands run
