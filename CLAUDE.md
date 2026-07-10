# CLAUDE.md

Dotfiles repo. v2, built from scratch.

## Repo layout

- `macbook/` — macOS dotfiles.
- `linux/` — Linux dotfiles.
- `old/` — legacy v1 dotfiles. **Read-only. Never modify.** Reference only.

## Directory-mirrors-home rule

`macbook/` and `linux/` mirror the home directory (`~`) structure exactly.

A config that lives at `~/<path>` goes to `<platform>/<path>`.

Examples:
- Neovim (`~/.config/nvim`) → `macbook/.config/nvim`, `linux/.config/nvim`
- `~/.zshrc` → `macbook/.zshrc`
- `~/.config/alacritty/alacritty.toml` → `macbook/.config/alacritty/alacritty.toml`

Apply this for every config, both platforms.

## Rules

- **Branch before every change.** New branch off current before editing anything. Never commit straight to `main`/`master`.
- **Never touch `old/`.**
- Unsure which directory a config file belongs in? **Ask.** Do not guess placement.
- Commit/PR text: caveman style.
