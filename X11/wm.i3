#!/bin/sh

# include common functions
. ~/.profile.d/common/common.sh

# create configuration
${_prfdir}/i3/mkconfig

# start window manager
exec i3 -c "${_prfdir}/i3/config.local" -V >> "${_logdir}/i3.log" 2>&1
