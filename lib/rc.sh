if [[ -f $HOME/.ws-session.rc ]] ; then
  source $HOME/.ws-session.rc
elif [[ -f $HOME/.config/ws-sesson/ws-session.rc ]] ; then
  source $HOME/.config/ws-sesson/ws-session.rc
else
  echo Error session.rc not found!
  echo install it to $HOME/.ws-session.rc or $XDG_CONFIG_HOME/ws-session.rc
fi

# vim: ft=sh ts=2 et sw=2:

