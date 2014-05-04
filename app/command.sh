s_command_open_session() {
  local file="$1/command"
  
  if [[ -f "$file" ]] ; then
    while read -r l ; do
      id="$(cut -f 1 <<< "$l" )"
      d="$(cut -f 2 <<< "$l" )"
      cmd="$(cut -f 3 <<< "$l" )"
      if [[ -n $id ]] ; then
        echo -e "$id\t$d\t$cmd" >> "$tmp_dir/command.tmp"
        $S_TERM -name command -cd "$d" -e "$cmd" & >/dev/null 2>&1
        pid="$!"
        s_reg_winid $pid $id
      fi
    done <"$file"
    unset l id d cmd pid
  fi
}

s_command_close_session() {
  local commandids="$1"
  local command_file="$tmp_dir/command"
  local tmp_command_file="$tmp_dir/command.tmp"

  echo -n > "$command_file"
  for id in $commandids ; do
    grep $id "$tmp_command_file" | tail -n1 >> "$command_file"
    xdotool windowkill $id
  done
  unset id

  rm "$tmp_command_file"
}

s_command_start() {

  if [[ -n $TERM ]] ; then
    winid=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $NF}')
    echo -e "$winid\t$PWD\t$@" >> "$S_TEMP_FOLDER/$S_SEL_TAG/command.tmp"
    xprop -f WM_CLASS 8s -set WM_CLASS "command" -id $winid
    "$@"
    xprop -f WM_CLASS 8s -set WM_CLASS "$S_TERM" -id $winid
    sed -i "\|${winid}|d" "$S_TEMP_FOLDER/$S_SEL_TAG/command.tmp"
  else
    echo "You cannot run terminal apps without a terminal
    If you see this you are probably on a tty.."
  fi
  unset winid
}

# vim: ft=sh ts=2 et sw=2:

