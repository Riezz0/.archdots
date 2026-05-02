#Startups
fastfetch

# Paths
export ZSH="$HOME/.oh-my-zsh"
export PATH="$PATH:/root/.local/bin"
# Theme
ZSH_THEME="agnoster"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete autoswitch_virtualenv $plugins)

# Import
source $ZSH/oh-my-zsh.sh

# aliases
alias v="nvim"
alias ls="exa -lag --icons"
alias ga="git add ."
alias gc="git commit --allow-empty-message -m "
alias gp="git push -u origin main"


# Created by `pipx` on 2026-04-21 06:26:41
export PATH="$PATH:/home/archdev/.local/bin"
