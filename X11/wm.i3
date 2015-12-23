#!/bin/sh
mkdir -p ~/.local/log
exec i3 -c ~/.profile.d/i3/config -V >> ~/.local/log/i3.log 2>&1
