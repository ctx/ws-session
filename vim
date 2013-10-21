#!/bin/bash

SESSIONPATH=/usr/lib/ws-session
source $HOME/.session.rc
source $SESSIONPATH/lib-wm.sh

if [[ $WM == "NULL" ]] ; then 
        vim $@
        exit 0
fi

WINID=$(xprop -root _NET_ACTIVE_WINDOW |awk '{print $NF}')
xprop -f WM_CLASS 8s -set WM_CLASS "VIM" -id $WINID

VIMINFO="$S_TEMPFOLDER/$SELTAG/viminfo"
export SELTAG=$SELTAG
vim -i $VIMINFO --servername "$SELTAG-" $@
