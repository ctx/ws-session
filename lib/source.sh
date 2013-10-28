s_source_rc() {
  if [[ -f $HOME/.ws-session.rc ]] ; then
    source $HOME/.ws-session.rc
  elif [[ -f $HOME/.config/ws-sesson/ws-session.rc ]] ; then
    source $HOME/.config/ws-sesson/ws-session.rc
  else
    echo Error session.rc not found!
    echo install it to $HOME/.ws-session.rc or $S_CONFIGPATH/ws-session.rc
  fi
}

s_source_rc

s_source() {
  if [[ -f "$S_CONFIGPAHT/$1" ]] ; then
    source "$S_CONFIGPATH/$1"
  elif [[ -f "$SESSIONPATH/$1" ]] ; then
    source "$SESSIONPATH/$1"
  else
    echo ERROR: $1 not found
    exit 1
  fi
}

# vim: ft=sh ts=2 et sw=2:

