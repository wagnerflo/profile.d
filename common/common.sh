# -*- mode: sh -*-

#####################################################################
# common/common.sh: functionality common to multiple contexts

# include common helper functions
. ~/.profile.d/common/helper.sh

# variables
_prfdir=~/.profile.d
_logdir=~/.local/log

# force encoding
export LANG="en_US.UTF-8"
export LC_ALL="${LANG}"

# determine short and fully-qualified host name
_hostname="$(find_path inetutils-hostname hostname)"
export HOSTNAME="$("${_hostname}" -s)"
export FQHN="$("${_hostname}" -f)"

# detect and set environment if no already
if [ -z ${PROFILE_ENV+x} ]
then
    case "${FQHN}" in
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

    for _item in tmux/tmux.conf
    do
        _local=${_prfdir}/${_item}.env.local
        _custom=${_prfdir}/${_item}.env.${PROFILE_ENV}

        if [ ! -L "${_local}" ]; then
            [ -f "${_custom}" ] && \
                ln -s "$(basename ${_custom})" "${_local}" || \
                    ln -s "$(basename ${_item}.empty)" "${_local}"
        fi

        _local=${_prfdir}/${_item}.host.local
        _custom=${_prfdir}/${_item}.host.${HOSTNAME}

        if [ ! -L "${_local}" ]; then
            [ -f "${_custom}" ] && \
                ln -s "$(basename ${_custom})" "${_local}" || \
                    ln -s "$(basename ${_item}.empty)" "${_local}"
        fi
    done
fi

unset -v _hostname _item _local _custom

# create log directory
mkdir -p ${_logdir}
