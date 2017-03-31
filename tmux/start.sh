# -*- mode: sh -*-

#####################################################################
# tmux/start.sh: start a tmux sever with default configuration

start () {
    # check if tmux is installed
    if ! command -v tmux >/dev/null; then
        return
    fi

    # check if we are running inside tmux
    if [ -n "${TMUX}" -o \
         "${TERM}" = "screen" -o \
         "${TERM}" = "screen-256color" ]; then
        return
    fi

    # check if configuration file exists
    if [ ! -f "${HOME}/.tmux.conf" ]; then
        return
    fi

    tmux start
}

start
unset -f start
