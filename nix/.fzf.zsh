# Setup fzf
# ---------
if [[ ! "$PATH" == */home/victor/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/victor/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/victor/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/victor/.fzf/shell/key-bindings.zsh"
