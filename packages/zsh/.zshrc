source ~/.zplug/init.zsh

zplug "modules/prompt", from:prezto, frozen:1

zplug "modules/git", from:prezto, frozen:1
zplug "modules/python", from:prezto, frozen:1


zplug "lcosmin/zsh", from:github, use:"env/init.zsh"
zplug "lcosmin/zsh", from:github, use:"aliases/init.zsh"

#, use: "aliases"
#zplug "lcosmin/zsh", from:github, use: "env"

if ! zplug check; then
    zplug install
fi

zplug load --verbose
