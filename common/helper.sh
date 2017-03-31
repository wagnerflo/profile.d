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
            echo "invalid test: ${_item}"
            return 1
        fi

        eval _arg=\${${_arg}}
        if ! test -${_pri} ${_arg}; then
            echo "failed test: -${_pri} ${_arg}"
            return $(printf %d \'${_pri})
        fi
    done

    "${@}"
}

onpath () {
    which "${1}" >/dev/null 2>&1
}

find_path () {
    for _option in ${@}; do
        _option="$(which ${_option})"
        if [ $? -eq 0 ]; then
            echo ${_option}
            return
        fi
    done
}
