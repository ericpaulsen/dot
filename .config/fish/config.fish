starship init fish | source

export GOPROXY=direct

set -x GPG_TTY (tty)

alias h='cd ~'
alias l='ls -a'
alias kubectl='kubecolor'
alias kctx='kubectx'
alias k='kubectl'
alias tf='terraform'
alias du='duf'

# THEME PURE #
set fish_function_path /home/coder/.config/fish/functions/theme-pure/functions/ $fish_function_path
source /home/coder/.config/fish/functions/theme-pure/conf.d/pure.fish
fish_add_path /usr/local/opt/libpq/bin

# Generated for envman. Do not edit.
test -s "$HOME/.config/envman/load.fish"; and source "$HOME/.config/envman/load.fish"

