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