
source ~/.zplug/init.zsh

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

zplug "modules/gpg", from:prezto, frozen:1

if ! zplug check; then
    zplug install
fi

SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  golang        # Go section
  venv          # virtualenv section
  pyenv         # Pyenv section
  line_sep      # Line break
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

zplug load --verbose

