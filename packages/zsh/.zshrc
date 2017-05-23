source ~/.zplug/init.zsh

zplug "modules/prompt", from:prezto, frozen:1
zplug "modules/git", from:prezto, frozen:1
zplug "modules/python", from:prezto, frozen:1

# Prompt theme
zplug "nojhan/liquidprompt", from:github

zplug "lcosmin/zsh", from:github, use:"env/init.zsh"


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

zplug load --verbose
