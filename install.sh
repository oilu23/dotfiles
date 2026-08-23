#!/usr/bin/env bash
# Symlink dotfiles into $HOME. Safe to re-run.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DID_BACKUP=0

link() {
  local src="$DOTFILES/$1" dest="$HOME/$2"

  if [ ! -e "$src" ]; then
    echo "  skip  $2  (missing in repo)"
    return
  fi

  # Already pointing where we want it? Nothing to do.
  if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
    echo "  ok    $2"
    return
  fi

  # Something real is in the way -- move it aside, never delete.
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$BACKUP"
    mv "$dest" "$BACKUP/"
    DID_BACKUP=1
    echo "  moved $2 -> $BACKUP/"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "  link  $2"
}

echo "Installing dotfiles from $DOTFILES"
link tmux/tmux.conf .tmux.conf

# Pick up the new config if tmux is already running.
if command -v tmux >/dev/null && tmux info >/dev/null 2>&1; then
  tmux source-file "$HOME/.tmux.conf" && echo "  reloaded running tmux server"
fi

echo "Done."
[ "$DID_BACKUP" -eq 1 ] && echo "Replaced files were saved to $BACKUP"
exit 0
