LUAKIT=luakit
luakitcmd="/usr/bin/luakit -U"
XDGNEWARG="http://google.com"

s_luakit_open_session() {
  local dir="$1"
  local tmp_dir="$S_TEMP_FOLDER/$S_SEL_TAG"
  if [[ -d "$dir/$LUAKIT" ]] ; then
    if [[ ! -d "$tmp_dir/$LUAKIT" ]] ; then
      cp -r $dir/$LUAKIT $tmp_dir
    fi
    xdh="$XDG_DATA_HOME"
    XDG_DATA_HOME="$tmp_dir/$LUAKIT"
    $luakitcmd & >/dev/null 2>&1
    pid="$!"
    s_reg_winid "$pid" "$(cat "$XDG_DATA_HOME/windowid")"
    XDG_DATA_HOME=$xdh
    unset xdh
  fi
}

s_luakit_close_session() {
  local tmp_dir="$S_TEMP_FOLDER/$S_SEL_TAG/$LUAKIT"
  echo $1 > "$tmp_dir/windowid"
  s_focus_window $1
  xdotool type :wqall
  xdotool key KP_Enter
}

# start luakit

s_luakit_new_instance() {
  local tmp_dir="$1"
  shift
  mkdir -p "$tmp_dir"
  xdh="$XDG_DATA_HOME"
  XDG_DATA_HOME="$tmp_dir/$LUAKIT"
  $luakitcmd "$@" & >/dev/null 2>&1
  XDG_DATA_HOME=$xdh
  unset xdh
}

s_luakit_focus() {
  s_focus_window "$1"
  if [ -n "$2" ] ; then 
    xdotool key t
    xdotool type "$2"
    xdotool key KP_Enter
  fi
}

s_luakit_start() {
  if [ -n "$1" ] ; then
    local url="$1"
  fi
  local dir="$S_TEMP_FOLDER/$S_SEL_TAG/$LUAKIT"
  if ! [ -d "$dir" ]
  then
    s_luakit_new_instance "$dir" "$url"
  else
    winid="$(s_list_app_seltag | grep $LUAKIT | cut -f1 -d" ")"
    if [ -z "$winid" ] ; then
      s_luakit_new_instance "$dir" "$url"
    else
      s_luakit_focus "$winid" "$url"
    fi
    unset winid
  fi

}

# vim: ft=sh ts=2 et sw=2:

