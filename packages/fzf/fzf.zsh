# Setup fzf
# ---------
if [[ ! "$PATH" == *${HOME}/.home/packages/fzf/.fzf/bin* ]]; then
  export PATH="$PATH:${HOME}/.home/packages/fzf/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${HOME}/.home/packages/fzf/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${HOME}/.home/packages/fzf/.fzf/shell/key-bindings.zsh"

