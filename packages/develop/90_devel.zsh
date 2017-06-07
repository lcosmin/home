zplug "modules/git", from:prezto, frozen:1
zplug "modules/python", from:prezto, frozen:1

# Allow git to display emojis in the log
export LESS='--raw-control-chars'

if (( $+commands[vimpager] ))
then
    export PAGER="$(which vimpager)"
fi