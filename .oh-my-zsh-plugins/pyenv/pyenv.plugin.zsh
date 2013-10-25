
echo -n "[+] Loading pyenv..."

if [[ -d "$HOME/.pyenv" ]] 
then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"

    if [[ -x "$(which pyenv)" ]]
    then
        eval "$(pyenv init -)"
    fi

    echo "located at $PYENV_ROOT"
else
    echo "not found"
fi


