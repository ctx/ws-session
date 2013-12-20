s_command_open_session() {
  local file="$1/command"
  
  if [[ -f "$file" ]] ; then
    while read -r id cmd ; do
      if [[ -n $id ]] ; then
        echo "$id $cmd" >> "$S_TEMP_FOLDER/$S_SEL_TAG/command.tmp"
        s_run_cmd_opensession "$id" "$S_TERM -name command -e $cmd"
      fi
    done <"$file"
    unset id cmd
  fi
}

s_command_close_session() {
  local commandids="$1"
  local command_file="$S_TEMP_FOLDER/$S_SEL_TAG/command"
  local tmp_command_file="$S_TEMP_FOLDER/$S_SEL_TAG/command.tmp"

  echo -n > "$command_file"
  for id in $commandids ; do
    grep $id "$tmp_command_file" | tail -n1 >> "$command_file"
    xdotool windowkill $id
  done
  unset id
}

s_command_start() {
  if [[ -n $TERM ]] ; then
    winid=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $NF}')
    echo "$winid $@" >> "$S_TEMP_FOLDER/$S_SEL_TAG/command.tmp"
    xprop -f WM_CLASS 8s -set WM_CLASS "command" -id $winid
    "$@"
    xprop -f WM_CLASS 8s -set WM_CLASS "$S_TERM" -id $winid
    sed -i "\|${winid}|d" "$S_TEMP_FOLDER/$S_SEL_TAG/command.tmp"
  else
    echo you cannot run terminal apps without a terminal
  fi
  unset winid
}

# vim: ft=sh ts=2 et sw=2:

