# dotfiles

Personal config, kept in sync across machines.

## Install (or update) -- one command

```sh
if [ -d ~/dotfiles ]; then git -C ~/dotfiles pull; else git clone https://github.com/oilu23/dotfiles.git ~/dotfiles; fi && ~/dotfiles/install.sh
```

Safe to paste repeatedly: it clones the first time, pulls after that, and
re-linking is a no-op.

`install.sh` symlinks the files into `$HOME`. Anything real that was already
there gets moved to `~/.dotfiles-backup/<timestamp>/` rather than deleted.

## Update an existing machine

```sh
cd ~/dotfiles && git pull && tmux source-file ~/.tmux.conf
```

Because the files are symlinks, `git pull` alone updates the config on disk --
you only need the `source-file` to make a *running* tmux server notice.

## Change a setting

Edit the file in `~/dotfiles` (not the one in `$HOME` -- it's a symlink to here),
then:

```sh
cd ~/dotfiles && git commit -am "tmux: describe the change" && git push
```

## What's in here

| Path              | Links to      | Notes |
|-------------------|---------------|-------|
| `tmux/tmux.conf`  | `~/.tmux.conf`| Scrollback tuned for touchscreen SSH clients (mouse mode, 100k history, vi copy-mode, soft-keyboard-friendly paging) |

### tmux notes

- `history-limit` applies to panes at **creation** time. After pulling a change
  to it, existing panes keep their old limit -- open a new window.
- Mouse mode means your terminal no longer handles drag-to-select. Copy with
  `v` / `y` inside copy mode, or hold Shift while dragging.
- Requires tmux >= 2.4.
