#!/bin/bash

SESSIONPATH=/usr/lib/ws-session
source $HOME/.session.rc
source $SESSIONPATH/lib-wm.sh
source $SESSIONPATH/app-vim.sh

if [[ $WM == "NULL" ]] ; then 
  vim $@
  exit 0
fi

s_vim_start "$@"

# vim: ft=sh ts=2 et sw=2:
