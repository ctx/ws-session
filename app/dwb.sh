DWB=dwb
dwbcmd='/usr/bin/dwb -n'
dwbcmdreload="$dwbcmd -f -r default"

# open a dwb session
# $1: Data folder: where the last session was stored.
# Copy the dwb data folder arg1/dwb to tmp_dir
s_dwb_open_session() {
  if [[ -d "$1/$DWB" ]] ; then
    if ! [[  -d "$tmp_dir/$DWB" ]] ; then
      cp -R "$1/$DWB" "$tmp_dir"
    fi
    XDG_CONFIG_HOME="$tmp_dir" $dwbcmdreload & >/dev/null 2>&1
    s_reg_winid $! "$(< "$tmp_dir/$DWB/windowid")"
    unset pid
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
  local tmp_dir="$S_TEMP_FOLDER/$S_SEL_TAG" 
  if ! [[ -d $tmp_dir/$DWB ]] ; then
    mkdir "$tmp_dir/$DWB"
    find "$XDG_CONFIG_HOME/$DWB" -maxdepth 1 -mindepth 1 -not -name default \
      -exec ln -s "{}" "$tmp_dir/$DWB/" \;
    XDG_CONFIG_HOME="$tmp_dir" $dwbcmd "$@" & >/dev/null 2>&1
  else
    winid="$(s_list_app_seltag | grep $DWB | cut -f1 -d " ")"
    if [[ -n $winid ]] ; then
      #XDG_CONFIG_HOME="$tmp_dir" /usr/bin/dwbremote -i "$winid" "$@" & > /dev/null 2>&1
      s_focus_window "$winid"
      xdotool key Escape
      xdotool key O
      xdotool type "$@"
      xdotool key KP_Enter
    else
      XDG_CONFIG_HOME="$tmp_dir" $dwbcmd "$@" & >/dev/null 2>&1
    fi
  fi
}

# vim: ft=sh ts=2 et sw=2:

