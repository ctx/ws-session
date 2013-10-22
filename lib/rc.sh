if [[ -f $HOME/.session.rc ]] ; then
  source $HOME/.session.rc
elif [[ -f $HOME/.config/ws-sesson/session.rc ]] ; then
  source $HOME/.config/ws-sesson/session.rc
else
  echo Error session.rc not found!
  echo install it to $HOME/.session.rc or $XDG_CONFIG_HOME/session.rc
fi

# vim: ft=sh ts=2 et sw=2:

