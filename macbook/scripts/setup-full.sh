DOTFILESDIR=${HOME}/.dotfiles

# ZSH

mv ~/.zshrc ~/.zshrc_before_dotfiles
ln -sf ${DOTFILESDIR}/.zshrc ~/.zshrc

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