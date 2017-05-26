source ~/.zplug/init.zsh

zplug "modules/git", from:prezto, frozen:1
zplug "modules/python", from:prezto, frozen:1


#
# Load files from .zsh.d
#
if [[ -d ~/.zsh.d ]]
then
    for f in ~/.zsh.d/*
    do
	[[ -f "$f" ]] && echo "loading $f" && source "$f"
    done
fi


if ! zplug check; then
    zplug install
fi

zplug load #--verbose
