DOTFILESDIR=${HOME}/.dotfiles

# ZSH — symlink ~/.zshrc to the dotfiles zshrc (idempotent).
ZSH_SRC="${DOTFILESDIR}/macbook/.zshrc"
ZSH_DST="${HOME}/.zshrc"

if [ -L "${ZSH_DST}" ] && [ "$(readlink "${ZSH_DST}")" = "${ZSH_SRC}" ]; then
  echo "zsh: symlink already in place, nothing to do"
elif [ -e "${ZSH_DST}" ] || [ -L "${ZSH_DST}" ]; then
  ZSH_BACKUP="${ZSH_DST}.backup.$(date +%Y%m%d%H%M%S)"
  echo "zsh: backing up ${ZSH_DST} -> ${ZSH_BACKUP}"
  mv "${ZSH_DST}" "${ZSH_BACKUP}"
  ln -s "${ZSH_SRC}" "${ZSH_DST}"
  echo "zsh: linked ${ZSH_DST} -> ${ZSH_SRC}"
else
  ln -s "${ZSH_SRC}" "${ZSH_DST}"
  echo "zsh: linked ${ZSH_DST} -> ${ZSH_SRC}"
fi

# Powerlevel10k — symlink ~/.p10k.zsh to the dotfiles config (idempotent).
P10K_SRC="${DOTFILESDIR}/macbook/.p10k.zsh"
P10K_DST="${HOME}/.p10k.zsh"

if [ -L "${P10K_DST}" ] && [ "$(readlink "${P10K_DST}")" = "${P10K_SRC}" ]; then
  echo "p10k: symlink already in place, nothing to do"
elif [ -e "${P10K_DST}" ] || [ -L "${P10K_DST}" ]; then
  P10K_BACKUP="${P10K_DST}.backup.$(date +%Y%m%d%H%M%S)"
  echo "p10k: backing up ${P10K_DST} -> ${P10K_BACKUP}"
  mv "${P10K_DST}" "${P10K_BACKUP}"
  ln -s "${P10K_SRC}" "${P10K_DST}"
  echo "p10k: linked ${P10K_DST} -> ${P10K_SRC}"
else
  ln -s "${P10K_SRC}" "${P10K_DST}"
  echo "p10k: linked ${P10K_DST} -> ${P10K_SRC}"
fi

# Neovim — symlink ~/.config/nvim to the dotfiles config (idempotent).
NVIM_SRC="${DOTFILESDIR}/macbook/.config/nvim"
NVIM_DST="${HOME}/.config/nvim"

mkdir -p "${HOME}/.config"

if [ -L "${NVIM_DST}" ] && [ "$(readlink "${NVIM_DST}")" = "${NVIM_SRC}" ]; then
  echo "nvim: symlink already in place, nothing to do"
elif [ -e "${NVIM_DST}" ] || [ -L "${NVIM_DST}" ]; then
  NVIM_BACKUP="${NVIM_DST}.backup.$(date +%Y%m%d%H%M%S)"
  echo "nvim: backing up ${NVIM_DST} -> ${NVIM_BACKUP}"
  mv "${NVIM_DST}" "${NVIM_BACKUP}"
  ln -s "${NVIM_SRC}" "${NVIM_DST}"
  echo "nvim: linked ${NVIM_DST} -> ${NVIM_SRC}"
else
  ln -s "${NVIM_SRC}" "${NVIM_DST}"
  echo "nvim: linked ${NVIM_DST} -> ${NVIM_SRC}"
fi 