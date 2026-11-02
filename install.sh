#!/usr/bin/env bash
# Installs the skills in ./skills into Claude Code.
#   ./install.sh            personal install: ~/.claude/skills (all your projects)
#   ./install.sh /path/repo project install: /path/repo/.claude/skills (commit it to share with your team)
# Existing skills with the same folder name are NOT overwritten unless you pass FORCE=1.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ $# -ge 1 ]; then DEST="$1/.claude/skills"; else DEST="$HOME/.claude/skills"; fi
mkdir -p "$DEST"
installed=0; skipped=0
for dir in "$HERE"/skills/*/; do
  name="$(basename "$dir")"
  if [ -e "$DEST/$name" ] && [ "${FORCE:-0}" != "1" ]; then
    echo "skip   $name (already exists; FORCE=1 ./install.sh to overwrite)"; skipped=$((skipped+1)); continue
  fi
  rm -rf "$DEST/$name"; cp -R "$dir" "$DEST/$name"; echo "added  $name"; installed=$((installed+1))
done
echo "Done: $installed installed, $skipped skipped, into $DEST"
echo "Start (or restart) Claude Code and type / to see the skills, or ask: What skills are available?"
