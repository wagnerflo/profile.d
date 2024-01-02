# -*- mode: sh -*-

#####################################################################
# common/common.sh: functionality common to multiple contexts

# variables
_prfdir=~/.profile.d
_logdir=~/.local/log

# force encoding
export LANG="en_US.UTF-8"
export LC_ALL="${LANG}"

# create log directory
mkdir -p ${_logdir}
