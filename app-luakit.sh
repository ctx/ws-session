XDGAPPLICATION=luakit
XDGCMD="luakit -U -n"
#XDGOPENARG="-u luakit://history"
XDGNEWARG="-u http://google.com"


# open a luakit session
# arg1: Data folder: where the last session was stored.
# arg2: Temporary folder: this folder will be stored by s_$app_close_session
# Copy the luakit data folder arg1/luakit to arg2
s_luakit_open_session() {
  local dir="$1"
  local tmp_dir="$2"
  cp -r $dir/$XDGAPPLICATION $tmp_dir
  {
    export XDG_DATA_HOME="$tmp_dir/$XDGAPPLICATION"
    $XDGCMD # > /dev/null 2>&1
  }&
}

# close luakit session
# arg1: Temporary folder: this folder will be stored in the end.
# Nothing to be done.
# The folder will be backed up and everything will be closed anyway.
s_luakit_close_session() {
  local tmp_dir="$1/$XDGAPPLICATION"
  xdotool windowactivate --sync $2
  xdotool type :wqall
  xdotool key KP_Enter
}

# some other functions to start luakit 
# need session.rc and lib-wm.sh

s_luakit_new_instance() {
  mkdir -p "$1"
  {
    export XDG_DATA_HOME="$1" 
    $XDGCMD "$2" > /dev/null 2>&1
  }&
}

s_luakit_focus() {
  xdotool windowactivate --sync $1
  if [ -n "$2" ] ; then 
    xdotool key t
    xdotool type "$2"
    xdotool key KP_Enter
  fi
}

s_luakit_start() {
  if [ -z "$1" ] ; then
    url="$XDGNEWARG"
  else
    url="$1"
  fi
  local dir="$S_TEMPFOLDER/$SELTAG/$XDGAPPLICATION"
  if ! [ -d "$dir" ]
  then
    s_luakit_new_instance "$dir" "$url"
  else
    winid="$(s_list_app_seltag | grep $XDGAPPLICATION | cut -f1)"
    if [ -z "$winid" ] ; then
      s_luakit_new_instance "$dir" "$url"
    else
      s_luakit_focus "$winid" "$url"
    fi
  fi

}

# vim: ft=sh ts=2 et sw=2:

