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

# determine host
HOSTNAME=$(cat /etc/hostname)
HOSTNAME=${HOSTNAME%%.*}

# detect and set environment if not already
if [ -z "${PROFILE_ENV}" ]; then
    case "${HOSTNAME}" in
        teclador)  PROFILE_ENV=teclador;;
        naclador)  PROFILE_ENV=naclador;;
        *)         PROFILE_ENV=unknown;;
    esac
fi

export HOSTNAME
export PROFILE_ENV

# create symlinks
if [ ${PROFILE_ENV} != "unknown" ]; then
    for _item in git/gitconfig tmux/tmux.conf; do
        _local=${_prfdir}/${_item}.local
        _custom=${_prfdir}/${_item}.${PROFILE_ENV}

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
