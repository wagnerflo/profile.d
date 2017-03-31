#!/bin/sh

i3-msg -q "\
  workspace 10: log; \
  append_layout ${HOME}/.profile.d/workspace-10.json; \
  exec urxvt -title logscan -e ssh nuc 'tail -F /var/log/all.log | stdbuf -iL -oL -eL logscan | stdbuf -iL -oL -eL grep ^\[^aPdfnrzl\]'; \
  exec urxvt; \
  exec urxvt; \
  exec urxvt; \
"
