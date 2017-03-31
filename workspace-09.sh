#!/bin/sh

i3-msg -q "\
  workspace 9: edit; \
  append_layout ${HOME}/.profile.d/workspace-09.json; \
  exec urxvt -e emacs; \
  exec urxvt -e emacs; \
  exec urxvt -e emacs; \
  exec urxvt; \
  exec urxvt; \
  exec urxvt; \
  exec urxvt; \
  exec urxvt; \
  exec urxvt; \
"
