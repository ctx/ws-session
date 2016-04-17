s_help_urxvt() {
  echo 'About ws-session app files: urxvt

Description:
    The urxvt wrapper reads the current working directories (cwd)
    for all urxvts from /proc. All cwds are stored in the file
    $S_TMP_DIR/$session/urxvt.

    Additionaly you can restore dedicated HISTORY, DIRSTACK and
    other shell files.

Usage:
    Start urxvt normally.

Configuration:
  * Add files which should get restored to the S_SHELL_FILES array
    in your ws-session.rc:

    S_SHELL_FILES( zsh_history zdirs )

  * You have to configure your SHELL to use these files:

    path_to_config="$(ws-session -p 2>/dev/null)"
    path_to_config=${path_to_config:-$HOME/.}
    export HISTFILE="${path_to_config}zsh_history"
    export DIRSTACKFILE="${path_to_config}zdirs"
    unset path_to_config
  '
}


# open urxvt
# arg1: Data directory: where the last session was stored.
# Load the cwd's from the file arg1/urxvt
s_urxvt_open_session() {
  local file="$1/urxvt"
  s_restore_file ${S_SHELL_FILES[@]}

  if [[ -f "$file" ]] ; then
    while read -r id wd ;do
      if [[ -n $id ]] ; then
        /usr/bin/urxvt -cd "$wd" & >&3 2>&3
        s_reg_winid $! $id
      fi
    done <"$file"
    unset id wd
  fi
}

# close urxvt, save working directory
# arg1: winids of all urxvts on current tag.
# Store the cwd of all urxvt's on the current tag
s_urxvt_close_session() {
  local urxvtids="$1"
  local urxvt

  echo -n > "$tmp_dir/urxvt"

  for urxvt in $urxvtids ; do
    if [[ -n $urxvt ]] ; then
      echo -n "$urxvt "
      readlink /proc/$(ps --ppid \
        $(xprop -id $urxvt _NET_WM_PID | cut -d " " -f 3) \
        | awk '/zsh/{print $1;exit;}')/cwd
      s_focus_window $urxvt
      xdotool key ctrl+d >&3 2>&3
    fi >> "$tmp_dir/urxvt"
  done
}

# vim: ft=sh ts=2 et sw=2:

