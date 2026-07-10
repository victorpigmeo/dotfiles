# Setup fzf
# ---------
if [[ ! "$PATH" == */home/victor/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/victor/.fzf/bin"
fi

source <(fzf --zsh)
