s_command_open_session() {
  local file="$1/command"
  
  if [[ -f "$file" ]] ; then
    while FS="\t" read -r id d cmd ; do
      if [[ -n $id ]] ; then
        echo -e "$id\t$d\t$cmd" >> "$tmp_dir/command.tmp"
        $S_TERM -name command -cd "$d" -e "$cmd" >/dev/null 2>&1 &
        s_reg_winid $! $id
      fi
    done <"$file"
    unset l id d cmd
  fi
}

s_command_close_session() {
  local commandids="$1"
  local command_file="$tmp_dir/command"
  local tmp_command_file="$tmp_dir/command.tmp"

  echo -n > "$command_file"
  for id in $commandids ; do
    sed -n "/${id}/{p;q;}" "$tmp_command_file" >> "$command_file"
    xdotool windowkill $id
  done
  unset id

  rm "$tmp_command_file"
}

s_command_start() {
  winid=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $NF}')
  echo -e "$winid\t$PWD\t$@" >> "$S_TEMP_FOLDER/$S_SEL_TAG/command.tmp"
  xprop -f WM_CLASS 8s -set WM_CLASS "command" -id $winid
  "$@"
  xprop -f WM_CLASS 8s -set WM_CLASS "$S_TERM" -id $winid
  sed -i "\|${winid}|d" "$S_TEMP_FOLDER/$S_SEL_TAG/command.tmp"
  unset winid
}

# vim: ft=sh ts=2 et sw=2:

