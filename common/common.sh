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

# determine host and domain name
for _item in /etc/os-release /usr/lib/os-release; do
    if [ -e "${_item}" ]; then
        eval OS_RELEASE_$(grep ^ID "${_item}")
        break
    fi
done
case "${OS_RELEASE_ID}" in
    freebsd)
        _hostname=$( (. /etc/rc.subr; \
                      load_rc_config hostname; \
                      printf "%s" "${hostname}") )
        ;;
    void)
        _hostname=$(cat /etc/hostname)
        ;;
esac

HOSTNAME=${_hostname%%.*}

if [ "${HOSTNAME}" = "${_hostname}" ]; then
    _hostname=$(awk '/^127\.0\.0\.1/ { print $2 }' /etc/hosts)
fi

DOMAINNAME=${_hostname#*.}

# detect and set environment if not already
if [ -z "${PROFILE_ENV}" ]; then
    case "${HOSTNAME}.${DOMAINNAME}" in
        teclador.*)            PROFILE_ENV=teclador;;
        naclador.*)            PROFILE_ENV=naclador;;
        *.ub.uni-tuebingen.de) PROFILE_ENV=ubt;;
        *)                     PROFILE_ENV=unknown;;
    esac
fi

export OS_RELEASE_ID
export DOMAINNAME
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
