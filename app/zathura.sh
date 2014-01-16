# $1: folder with data from the last session
s_zathura_open_session() {
  local file="$1/zathura"
  if [[ -f $file ]] ;then 
    while read -r id document ; do
      if [[ -n $id ]] ; then
        /usr/bin/zathura "$document" & >/dev/null 2>&1
        pid="$!"
        s_reg_winid $pid $id
      fi
    done <"$file"
    unset pid id document
  fi
}

# $1: windowids of all running zathuras
# create a file containing lines: 0xoldwinid /path/to some/file.pdf
s_zathura_close_session() {
  local file="$S_TEMP_FOLDER/$S_SEL_TAG/zathura"
  local winids="$1"
  echo -n > "$file"

  for id in $winids ;  do
    echo -n "$id " >> "$file"
    xprop _NET_WM_NAME -id $id \
      | sed 's/^_NET_WM_NAME(UTF8_STRING) = \"//
             s/\"$//' >> "$file"
    xdotool windowkill $id
  done
  unset id
}

s_zathura_start() {
  /usr/bin/zathura "$@" & >/dev/null 2>&1
}

# vim: ft=sh ts=2 et sw=2:
