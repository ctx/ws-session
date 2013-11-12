DWB=dwb

# open a dwb session
# arg1: Data folder: where the last session was stored.
# arg2: Temporary folder: this folder will be stored by s_$app_close_session
# Copy the dwb data folder arg1/dwb to arg2
s_dwb_open_session() {
  local dir="$1"
  local tmp_dir="$2"
  if [[ -d "$dir/$DWB" ]] ; then
    if ! [[  -d "$tmp_dir/$DWB" ]] ; then
      cp -R "$dir/$DWB" "$tmp_dir"
    fi
    s_dwb_run "$tmp_dir"
  fi
}

# close dwb session
# arg1: Temporary folder: this folder will be stored in the end.
# Nothing to be done.
# The folder will be backed up and everything will be closed anyway.
s_dwb_close_session() {
  local tmp_dir="$1/$DWB"
  s_focus_window $2
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

s_dwb_run() {
  {
    export XDG_CONFIG_HOME="$1"
    /usr/bin/dwb -n -r $S_SEL_TAG -f "$2" > /dev/null 2>&1
  }& disown
}

s_dwb_start() {
  if ! [[ -d $S_TEMP_FOLDER/$DWB ]] ; then
    mkdir $S_TEMP_FOLDER/$DWB
    for f in $(find $XDG_CONFIG_HOME/$DWB -maxdepth 1 -not -name default) ; do
      [[ $f != $XDG_CONFIG_HOME/$DWB ]] && ln -s $f $S_TEMP_FOLDER/$DWB/$(basename $f)
    done
    s_dwb_run "$S_TEMP_FOLDER/$DWB"
  else
    winid="$(s_list_app_seltag | grep $DWB | cut -f1)"
    if [[ -n $winid ]] ; then
      s_dwb_focus "$winid" "$@"
    else
      s_dwb_run "$S_TEMP_FOLDER/$DWB" "$@"
    fi
  fi
}

# vim: ft=sh ts=2 et sw=2:

