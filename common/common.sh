# -*- mode: sh -*-

#####################################################################
# common/common.sh: functionality common to multiple contexts

# variables
_prfdir=~/.profile.d
_logdir=~/.local/log

# detect and set environment if no already
if [ -z ${PROFILE_ENV+x} ]
then
    case "$(hostname -f)" in
        teclador.*)            PROFILE_ENV=teclador;;
        naclador.mos32.de)     PROFILE_ENV=naclador;;
        *.ub.uni-tuebingen.de) PROFILE_ENV=ubt;;
        *)                     PROFILE_ENV=unknown;;
    esac

    export PROFILE_ENV
fi

# create symlinks
if [ ${PROFILE_ENV} != "unknown" ]
then
    for _item in git/gitconfig mercurial/hgrc
    do
        _local=${_prfdir}/${_item}.local
        _custom=${_prfdir}/${_item}.${PROFILE_ENV}

        if [ ! -L "${_local}" ]; then
            [ -f "${_custom}" ] && \
                ln -s "$(basename ${_custom})" "${_local}" || \
                ln -s "$(basename ${_item}.empty)" "${_local}"
        fi
    done
fi

unset -v _item _local _custom

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
