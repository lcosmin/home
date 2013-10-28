_ssh_add() {
    key="$1"
    [[ ! -f "$key" ]] && return

    if [[ ! -z "$(cat $key | grep 'PRIVATE KEY')" ]]
    then
        fingerprint=$(ssh-keygen -l -f "$key" | awk '{print $2}')
        if [[ -z "$(ssh-add -l | grep $fingerprint)" ]]
        then
            echo "[->] adding ssh key $key"
            ssh-add "$key"
        else
            echo "skipping key $key (already added)"
        fi
    fi
}

add_keys() {
    echo "[+] Adding SSH keys to ssh-agent..."

    for key in `ls ~/.ssh/*`
    do
        _ssh_add "$key"
    done
}

# only if SSH agent is running and shell is interactive
if [[ -S "$SSH_AUTH_SOCK" ]]
then
    if [[ -o interactive ]]
    then
        add_keys
    fi
fi
