## get top process eating memory
alias psmem='ps aux | sort -nr -k 4'
alias psmem10='ps aux | sort -nr -k 4 | head -10'

## get top process eating cpu ##
alias pscpu=' ps aux | sort -nr -k 3 '
alias pscpu10=' ps aux | sort -nr -k 3 | head -10 '

alias c='clear'

alias sday='nu aws credentials refresh'
alias srcohmy='source ~/.oh-my-zsh/custom/config.zsh'
alias srcalias='source ~/.oh-my-zsh/custom/aliases.zsh'

function gbp(){
	git checkout master
	git branch | grep -v "master" | xargs git branch -D
	git pull
}

function fh(){
	cd
	cd "$1"
}

function fnu(){
	cd ~/dev/nu/"$1"
}

function j(){
	jump "$1"
}
