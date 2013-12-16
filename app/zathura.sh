# $1: folder with data from the last session
s_zathura_open_session() {
  local file="$1/zathura"
  if [[ -f $file ]] ;then 
    while read -r id document ; do
      [[ -n $id ]] && \
        s_run_cmd_opensession $id /usr/bin/zathura "$document" 
    done <"$file"
    unset id document
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
  s_run_cmd /usr/bin/zathura "$@"
}

# vim: ft=sh ts=2 et sw=2:
