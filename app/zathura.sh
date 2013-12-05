# open zathura
# arg1: Data folder: where the last session was stored.
# arg2: Temporary folder: this folder will be stored by s_zathura_close_session
s_zathura_open_session() {
  while read -r line ; do
    s_run_cmd_opensession ${line%% *} /usr/bin/zathura "${line#* }" 
  done < <(grep -v "^$" "$1/zathura")
}

# create a file containing lines: 0xoldwinid /path/to/file.pdf
# close zathura
# arg1: Temporary folder: this folder will be stored in the end.
# arg2: winids of all zathuras on current tag.
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
}

# start zathura
s_zathura_start() {
  s_run_cmd /usr/bin/zathura "$@"
}

# vim: ft=sh ts=2 et sw=2:
