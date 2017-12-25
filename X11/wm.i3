#!/bin/sh

# include common functions
. ~/.profile.d/common/common.sh

# create configuration
${_prfdir}/i3/mkconfig

# WM specific environment
export XDG_CURRENT_DESKTOP=GNOME

# start window manager
exec dbus-launch --exit-with-session i3 -c "${_prfdir}/i3/config.local" -V >> "${_logdir}/i3.log" 2>&1
