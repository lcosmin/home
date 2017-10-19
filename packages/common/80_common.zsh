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


darwin() {
    # Enable colors and trailing slashes for ls
    alias ls="ls -G -F"
    
    # Set the LANG variable in OSX (should be disabled in iTERM, so that it doesn't set LC_CTYPE to a stupid 
    # value like "UTF8", making ssh-ing into linux box a pain in the ass due to the invalid locale - of course
    # there are other solutions too, but this seems resonably easy)
    export LANG="en_US.UTF-8"
}

linux() {
    alias ls="ls --color=auto"
}


case "$(uname -s)" in
    Darwin)
	darwin
	;;

    Linux)
	linux
	;;
	
    *)
	echo ""
	;;
esac


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

