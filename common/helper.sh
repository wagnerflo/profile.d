# -*- mode: sh -*-

#####################################################################
# common/helper.sh: helper functions

try() {
    local _tests _item _arg _pri

    _tests=${1}
    shift

    for _item in $(echo ${_tests} | sed 's/[a-zA-Z]/& /g')
    do
        _arg=$(echo ${_item} | sed -n 's/^\([0-9]\{1,\}\)\([efdx]\)$/\1/p')
        _pri=$(echo ${_item} | sed -n 's/^\([0-9]\{1,\}\)\([efdx]\)$/\2/p')

        if [ -z "${_arg}" -o -z "${_pri}" ]; then
            echo "invalid test: ${_item}" >&2
            return 1
        fi

        eval _arg=\${${_arg}}
        if ! test -${_pri} ${_arg}; then
            return $(printf %d \'${_pri})
        fi
    done

    "${@}"
}

find_path () {
    local _option

    for _option in ${@}; do
        _option="$(command -v ${_option})"
        if [ $? -eq 0 ]; then
            echo ${_option}
            return
        fi
    done
}

tattach () {
    ssh -t ${1} tmux "start \; attach -t ${2}"
}

tkeep () {
    if ! ssh ${1} tmux "start \; has-session -t ${2}"; then
        return
    fi

    while ! tattach ${1} ${2}; do
        true
    done
}

tchoose () {
    local _option

    while true
    do
        _option=$(
            ssh ${1} tmux "start \; list-sessions" 2>/dev/null | \
                awk -F : -v p="${2}" \
                    '$1 ~ p {
                       out = "'\''" $1 "'\'' ";
                       $1 = "";
                       if(index($0,"(attached)") > 0)
                           out = out "'\''(attached)'\''"
                       else
                           out = out "'\'''\''"
                       print out
                     }')
        _option=$(
            eval dialog --menu \'Choose a tmux session\' 14 40 8 \
                 $(echo ${_option}) 2>&1 >/dev/tty)

        if [ -z "${_option}" ]; then
            return
        fi
        tattach ${1} ${_option}
    done
}
