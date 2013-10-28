s_source_rc() {
  if [[ -f $HOME/.ws-session.rc ]] ; then
    source $HOME/.ws-session.rc
  elif [[ -f $HOME/.config/ws-session/ws-session.rc ]] ; then
    source $HOME/.config/ws-session/ws-session.rc
  else
    echo Error session.rc not found!
    echo install it to $HOME/.ws-session.rc or $XDG_COFIG_HOME/ws-session/ws-session.rc
  fi
}

s_source() {
  if [[ -f "$S_CONFIG_FOLDER/$1" ]] ; then
    source "$S_CONFIG_FOLDER/$1"
  elif [[ -f "$S_ROOT_FOLDER/$1" ]] ; then
    source "$S_ROOT_FOLDER/$1"
  else
    echo ERROR: $1 not found
    exit 1
  fi
}

# vim: ft=sh ts=2 et sw=2:

