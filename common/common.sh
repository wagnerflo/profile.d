# -*- mode: sh -*-

#####################################################################
# common/common.sh: functionality common to multiple contexts


# variables
_prfdir=~/.profile.d
_logdir=~/.local/log


# detect and set environment
if [ -z ${_prfenv+x} ]; then
    _prfenv=unknown

    for script in ~/.profile.d/common/env.d/*; do
        # skip if not executable
        [ ! -x "${script}" ] && continue

        # run script, set variable if successful and exit
        if "${script}" >/dev/null 2>&1; then
            _prfenv=$(basename "${script}")
            break
        fi
    done
fi


# create log directory
mkdir -p ${_logdir}


# helper functions
testcmd() {
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
}

try() {
    local _tests
    _tests=${1}
    shift
    testcmd "${_tests}" "${@}" >/dev/null && "${@}"
}
