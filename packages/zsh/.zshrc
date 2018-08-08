
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

if ! zplug check; then
    zplug install
fi

zplug load #--verbose


SPACESHIP_PROMPT_ORDER=(
  time          # Time stampts section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  golang        # Go section
  venv          # virtualenv section
  pyenv         # Pyenv section
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
