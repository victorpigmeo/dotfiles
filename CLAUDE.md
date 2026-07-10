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

- **Branch per feature.** New branch off current before starting a new logical task. Follow-up commits that continue the same in-progress work stay on that branch. Never commit straight to `main`/`master`.
- **Humans only merge PRs.** Claude never merges a PR. Claude never pushes commits directly onto a PR's target/base branch (e.g. `v2`, `main`) — only onto the feature branch. Merging is a human decision.
- **Never touch `old/`.**
- Unsure which directory a config file belongs in? **Ask.** Do not guess placement.
- Commit/PR text: caveman style.
