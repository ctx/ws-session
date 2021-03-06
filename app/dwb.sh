DWB=dwb
dwbcmd='/usr/bin/dwb -n'
dwbcmdreload="$dwbcmd -f -r default"

# open a dwb session
# $1: Data directory: where the last session was stored.
# Copy the dwb data directory arg1/dwb to tmp_dir
s_dwb_open_session() {
  if [[ -d "$1/$DWB" ]] ; then
    if ! [[  -d "$tmp_dir/$DWB" ]] ; then
      cp -RP "$1/$DWB" "$tmp_dir"
      find "$XDG_CONFIG_HOME/$DWB" -maxdepth 1 -mindepth 1 -not -name default \
        -exec ln -sf "{}" "$tmp_dir/$DWB/" \;
    fi
    XDG_CONFIG_HOME="$tmp_dir" $dwbcmdreload >&3 2>&3 &
    s_reg_winid $! "$(< "$tmp_dir/$DWB/windowid")"
  fi
}

# close dwb session
# $1: windowid
s_dwb_close_session() {
  echo $1 > "$tmp_dir/$DWB/windowid"
  # XDG_CONFIG_HOME="$tmp_dir" /usr/bin/dwbremote -i $1 hook quit
  s_focus_window $1
  xdotool key Escape
  xdotool type ZZ
}

s_dwb_start() {
  if ! [[ -d $tmp_dir/$DWB ]] ; then
    mkdir "$tmp_dir/$DWB"
    find "$XDG_CONFIG_HOME/$DWB" -maxdepth 1 -mindepth 1 -not -name default \
      -exec ln -sf "{}" "$tmp_dir/$DWB/" \;
    XDG_CONFIG_HOME="$tmp_dir" $dwbcmd "$@" &
  else
    winid="$(s_list_app_seltag | awk "/$DWB/{print $1}")"
    if [[ -n $winid ]] ; then
      #XDG_CONFIG_HOME="$tmp_dir" /usr/bin/dwbremote -i "$winid" "$@" & > /dev/null 2>&1
      s_focus_window "$winid"
      xdotool key Escape
      xdotool key O
      xdotool type "$@"
      xdotool key KP_Enter
    else
      XDG_CONFIG_HOME="$tmp_dir" $dwbcmd "$@"
    fi
  fi
}

# vim: ft=sh ts=2 et sw=2:

