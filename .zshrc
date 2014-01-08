
source ~/.antigen-repo/antigen.zsh

antigen use oh-my-zsh

_common() {
    export PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH

    echo "[+] Loading common settings..."
    #antigen bundle gpg-agent
    antigen bundle history

    antigen bundle zsh-users/zsh-syntax-highlighting

    # Load machine tag support
    antigen bundle ~/.oh-my-zsh-plugins/machine-tag


    # Add my SSH keys to ssh-agent
    antigen bundle ~/.oh-my-zsh-plugins/ssh-keys


    if [[ -z "$SSH_CONNECTION" ]]
    then
        # We're not running on a SSH connection, thus turn on all the fancy 256 color stuff
        # Over SSH don't do this as it confuses different SSH clients
        if [[ $TERM != "screen-256color" ]];
        then
            export TERM=xterm-256color
            alias tmux="tmux -2"
        fi
    fi
    
    # Set the PROMPT theme
    antigen-theme philips
}


_devel_common() {
    # PyENV
    antigen bundle ~/.oh-my-zsh-plugins/pyenv

    antigen bundle git
    antigen bundle git-extras
    antigen bundle pip
    antigen bundle git-flow

}


_work_common() {
    antigen bundle ~/.oh-my-zsh-work-plugins/buildfarm
    antigen bundle ~/.oh-my-zsh-work-plugins/aliases
    antigen bundle ~/.oh-my-zsh-work-plugins/env
}

_common

case "$(machine_tag)" in
    "work_desktop")
        echo "[+] Loading work settings..."
        _work_common
        
        _devel_common
        
        antigen bundle archlinux
        antigen bundle ~/.oh-my-zsh-work-plugins/proxy
        
        # Update the prompt
        if [[ ! -z "${SCHROOT_CHROOT_NAME}" ]]
        then
            export PS1="[chroot:${SCHROOT_CHROOT_NAME}] $PS1"
        else
            export PS1="[desktop] $PS1"
        fi
        ;;

    "work_macos")
        echo "[+] Loading MacOS settings..."
        _work_common
        
        _devel_common
        
        antigen bundle brew
        antigen bundle osx
        export PS1="[mac] $PS1"
        ;;

    "home")
        echo "[+] Loading home settings..."
        _devel_common
        antigen bundle archlinux
        ;;
    
    "storage")
        echo "[+] Loading storage settings..."
        ;;
    
    *)
        echo "[+] Loading default settings..."
        ;;
esac

unfunction _common
unfunction _work_common
unfunction _devel_common

antigen-apply

setopt incappendhistory
unsetopt sharehistory
