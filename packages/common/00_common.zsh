#
# Set PATH to include any bin directory in ${HOME}
#
[[ -d "${HOME}/.bin" ]] && export PATH="${PATH}:${HOME}/.bin"
[[ -d "${HOME}/bin" ]] && export PATH="${PATH}:${HOME}/bin"

#
# Aliases
#
alias insecssh='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" -o "ServerAliveInterval=60"'

# enable bracketed paste mode
alias ebrack='printf "\e[?2004h"'

# disable bracketed paste mode
alias dbrack='printf "\e[?2004l"'

