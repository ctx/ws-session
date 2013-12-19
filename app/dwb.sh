DWB=dwb
dwbcmd='/usr/bin/dwb -n -r default'

# open a dwb session
# arg1: Data folder: where the last session was stored.
# Copy the dwb data folder arg1/dwb to arg2
s_dwb_open_session() {
  local dir="$1"
  local tmp_dir="$S_TEMP_FOLDER/$S_SEL_TAG"
  if [[ -d "$dir/$DWB" ]] ; then
    if ! [[  -d "$tmp_dir/$DWB" ]] ; then
      cp -R "$dir/$DWB" "$tmp_dir"
    fi

    xch="$XDG_CONFIG_HOME"
    XDG_CONFIG_HOME="$S_TEMP_FOLDER"
    #s_run_cmd_opensession "$(cat $tmp_dir/$DWB/windowid)" "$dwbcmd $S_SEL_TAG"
    s_run_cmd_opensession "$(cat $tmp_dir/$DWB/windowid)" "$dwbcmd"
    XDG_CONFIG_HOME="$xch"
    unset xch
  fi
}

# close dwb session
# arg1: windowid
s_dwb_close_session() {
  local tmp_dir="$S_TEMP_FOLDER/$S_SEL_TAG/$DWB"
  echo $1 > "$tmp_dir/windowid"
  s_focus_window $1
  xdotool type :wq
  xdotool key KP_Enter
}

s_dwb_focus() {
  if [[ -n "$1" ]] ; then
    s_focus_window "$1"
    if [[ -n $2 ]] ; then 
      xdotool type "O$2"
      xdotool key KP_Enter
    fi
  fi
}

s_dwb_start() {
  local tmp_dir="$S_TEMP_FOLDER/$S_SEL_TAG/$DWB"
  if ! [[ -d $tmp_dir ]] ; then
    mkdir "$tmp_dir"
    for f in $(find "$XDG_CONFIG_HOME/$DWB" -maxdepth 1 -not -name default) ; do
      [[ $f != $XDG_CONFIG_HOME/$DWB ]] && ln -s "$f" "$tmp_dir/$(basename "$f")"
    done
    xch="$XDG_CONFIG_HOME"
    XDG_CONFIG_HOME="$S_TEMP_FOLDER/$S_SEL_TAG"
    #s_run_cmd "$dwbcmd $S_SEL_TAG"
    s_run_cmd "$dwbcmd"
    XDG_CONFIG_HOME="$xch"
    unset xch
  else
    winid="$(s_list_app_seltag | grep $DWB | cut -f1)"
    if [[ -n $winid ]] ; then
      s_dwb_focus "$winid" "$@"
    else
      xch="$XDG_CONFIG_HOME"
      XDG_CONFIG_HOME="$S_TEMP_FOLDER/$S_SEL_TAG"
      #s_run_cmd "$dwbcmd $S_SEL_TAG -f" "$@"
      s_run_cmd "$dwbcmd -f" "$@"
      XDG_CONFIG_HOME="$xch"
      unset xch
    fi
  fi
}

# vim: ft=sh ts=2 et sw=2:

