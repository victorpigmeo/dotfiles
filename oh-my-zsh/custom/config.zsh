# BASIC CONFIGURATION
#   ------------------------------------------------------------
export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export GOPATH="${HOME}/go"

# NUCLI PATH
export NU_HOME="${HOME}/dev/nu"
export NUCLI_HOME="${NU_HOME}/nucli"
export PATH="${NUCLI_HOME}:${HOME}/dev/nu/mini-meta-repo/monocli/bin:${HOME}/sdk-flutter/bin:${GOPATH}/bin:${HOME}/Library/Android/sdk/tools/bin:${PATH}"
export FLUTTER_ROOT="${HOME}/sdk-flutter"
export MONOREPO="${HOME}/dev/nu/mini-meta-repo"

source "${HOME}/.nurc"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
