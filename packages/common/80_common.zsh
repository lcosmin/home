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


#
# Common settings that I want
#
setopt sharehistory
# don't overwrite existing files when redirecting 
setopt noclobber
# record timestamps in the history file
setopt extendedhistory
setopt incappendhistory

# use fcntl for locking the history file
setopt histfcntllock

setopt nonotify

export HISTFILE="${HOME}/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000

# set a more restrictive umask
umask 077

