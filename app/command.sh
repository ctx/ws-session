s_help_command() {
  echo 'About ws-session app files: command

Description:
    The command wrapper writes commands and the cwd of the
    calling shell to a file.

    Be sure that you cannot lose your work when the termial
    window gets termiated.

Usage:
    ws-cmd terminal command "with quoted argument"

Examples:
    ws-cmd htop
    ws-cmd mutt
    ws-cmd man archlinux
    ws-cmd ncmpcpp -h 10.0.0.5
    ws-cmd ssh -l user 10.0.0.5 "tmux attach"

Configuration:
    Create some aliases in your shellrc:

    if ws-session -p >/dev/null ; then
      setopt complete_aliases
      alias man='ws-cmd man'
      alias htop='ws-cmd htop'
      alias mutt='ws-cmd mutt'
      alias ncmpcpp='ws-cmd ncmpcpp'
      alias tig='ws-cmd tig'
    fi

Dependencies:
    xdotool
    xprop
    '
}

s_command_open_session() {
  local file="$1/command"
  
  if [[ -f "$file" ]] ; then
    while FS="\t" read -r id d cmd ; do
      if [[ -n $id ]] ; then
        echo -e "$id\t$d\t$cmd" >> "$tmp_dir/command.tmp"
        $S_TERM -name command -cd "$d" -e "$cmd" >&3 2>&3 &
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
  local winid=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $NF}')
  echo -e "$winid\t$PWD\t$@" >> "$S_TMP_DIR/$S_SEL_TAG/command.tmp"
  xprop -f WM_CLASS 8s -set WM_CLASS "command" -id $winid
  "$@"
  xprop -f WM_CLASS 8s -set WM_CLASS "$S_TERM" -id $winid
  sed -i "\|${winid}|d" "$S_TMP_DIR/$S_SEL_TAG/command.tmp"
}

# vim: ft=sh ts=2 et sw=2:

