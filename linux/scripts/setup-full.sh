#!/usr/bin/env bash
# Wire the Linux setup: install zsh (+ the bits the .zshrc needs), install the
# Neovim config's runtime deps (nvim, ripgrep, tree-sitter CLI, JDK, ...), back
# up any existing zsh / p10k / nvim config, then symlink this repo's files in.
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

# --- neovim + its runtime deps: the config needs a recent nvim, ripgrep
# (telescope), a C toolchain + tree-sitter CLI (nvim-treesitter main branch
# builds parsers via the CLI), unzip (mason), and a JDK 21+ (jdtls). nvim and
# the CLI land where the .zshrc PATH entry expects them. Idempotent. ---
install_nvim_deps() {
  # distro packages (apt); other package managers get a manual note
  if command -v apt-get >/dev/null 2>&1; then
    log "nvim deps: installing ripgrep, fd, unzip, build-essential, JDK 21, wl-clipboard..."
    sudo apt-get update
    sudo apt-get install -y ripgrep fd-find unzip build-essential openjdk-21-jdk wl-clipboard
  else
    log "nvim deps: non-apt system; install manually: ripgrep fd unzip a C toolchain openjdk-21 wl-clipboard" >&2
  fi

  # Neovim: official tarball -> /opt/nvim-linux-x86_64 (matches the .zshrc PATH).
  if [ -x /opt/nvim-linux-x86_64/bin/nvim ]; then
    log "neovim: already at /opt/nvim-linux-x86_64"
  elif [ "$(uname -m)" != "x86_64" ]; then
    log "neovim: arch is $(uname -m), not x86_64; install nvim manually" >&2
  else
    log "neovim: downloading official tarball -> /opt/nvim-linux-x86_64..."
    curl -fsSL -o /tmp/nvim-linux-x86_64.tar.gz \
      https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf /tmp/nvim-linux-x86_64.tar.gz
    rm -f /tmp/nvim-linux-x86_64.tar.gz
  fi

  # tree-sitter CLI: prebuilt binary -> /usr/local/bin (already on PATH).
  if command -v tree-sitter >/dev/null 2>&1; then
    log "tree-sitter CLI: already present"
  elif [ "$(uname -m)" != "x86_64" ]; then
    log "tree-sitter CLI: arch is $(uname -m), not x86_64; install manually" >&2
  else
    log "tree-sitter CLI: downloading prebuilt binary -> /usr/local/bin..."
    curl -fsSL -o /tmp/tree-sitter.gz \
      https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz
    gunzip -f /tmp/tree-sitter.gz
    sudo install -m 0755 /tmp/tree-sitter /usr/local/bin/tree-sitter
    rm -f /tmp/tree-sitter
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
  install_nvim_deps

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
