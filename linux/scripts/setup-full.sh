#!/usr/bin/env bash
# Wire the Linux setup: install zsh (+ the bits the .zshrc needs), back up any
# existing zsh / p10k / nvim config, then symlink this repo's files into place.
# Idempotent: safe to re-run. Existing real files are moved to <file>.backup.<ts>.
set -euo pipefail

DOTFILES_DIR="${HOME}/.dotfiles"
PLATFORM_DIR="${DOTFILES_DIR}/linux"
TS="$(date +%Y%m%d%H%M%S)"

log() { printf '%s\n' "$*"; }

# --- packages: zsh, plus git/curl needed to fetch oh-my-zsh + powerlevel10k ---
install_packages() {
  if command -v zsh >/dev/null 2>&1 \
    && command -v git >/dev/null 2>&1 \
    && command -v curl >/dev/null 2>&1; then
    log "packages: zsh, git, curl already present"
    return
  fi
  log "packages: installing zsh git curl..."
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update && sudo apt-get install -y zsh git curl
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y zsh git curl
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm zsh git curl
  elif command -v zypper >/dev/null 2>&1; then
    sudo zypper install -y zsh git curl
  else
    log "packages: no known package manager (apt/dnf/pacman/zypper); install zsh git curl manually" >&2
    exit 1
  fi
}

# --- oh-my-zsh + powerlevel10k: dependencies of the symlinked .zshrc ---
install_zsh_framework() {
  if [ -d "${HOME}/.oh-my-zsh" ]; then
    log "oh-my-zsh: already present"
  else
    log "oh-my-zsh: installing (keeping our .zshrc, not switching shell)..."
    # KEEP_ZSHRC so the installer does not overwrite the .zshrc we symlink below.
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  local p10k_dir="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k"
  if [ -d "${p10k_dir}" ]; then
    log "powerlevel10k: already present"
  else
    log "powerlevel10k: cloning..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${p10k_dir}"
  fi
}

# --- backup any existing target, then symlink src -> dst ---
backup_and_link() {
  local src="$1" dst="$2"
  if [ ! -e "${src}" ]; then
    log "skip: source missing ${src}" >&2
    return
  fi
  if [ -L "${dst}" ] && [ "$(readlink "${dst}")" = "${src}" ]; then
    log "link ok: ${dst} -> ${src}"
    return
  fi
  mkdir -p "$(dirname "${dst}")"
  if [ -e "${dst}" ] || [ -L "${dst}" ]; then
    local backup="${dst}.backup.${TS}"
    log "backup: ${dst} -> ${backup}"
    mv "${dst}" "${backup}"
  fi
  ln -s "${src}" "${dst}"
  log "linked: ${dst} -> ${src}"
}

main() {
  install_packages
  install_zsh_framework

  backup_and_link "${PLATFORM_DIR}/.zshrc"       "${HOME}/.zshrc"
  backup_and_link "${PLATFORM_DIR}/.p10k.zsh"    "${HOME}/.p10k.zsh"
  backup_and_link "${PLATFORM_DIR}/.config/nvim" "${HOME}/.config/nvim"

  local zsh_bin
  zsh_bin="$(command -v zsh)"
  if [ "${SHELL:-}" != "${zsh_bin}" ]; then
    log ""
    log "note: default shell is '${SHELL:-unknown}'. To make zsh the default:"
    log "  chsh -s ${zsh_bin}"
    log "(left to you: chsh prompts for your password / needs a re-login.)"
  fi
  log ""
  log "done. open a new zsh session to load the setup."
}

main "$@"
