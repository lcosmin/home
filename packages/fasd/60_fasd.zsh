(( $+commands[fasd] )) && eval "$(fasd --init auto)"


if ps $PPID |grep -q mc; then
_fasd_preexec () {
    fasd --proc "$(fasd --sanitize \"$1\")"
}
fi

