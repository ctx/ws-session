# open urxvt
# arg1: Data folder: where the last session was stored.
# Load the cwd's from the file arg1/urxvt
s_urxvt_open_session() {
  local file="$1/urxvt"
  s_restore_file ${S_SHELL_FILES[@]}

  if [[ -f "$file" ]] ; then
    while read -r id wd ;do
      if [[ -n $id ]] ; then
        /usr/bin/urxvt -cd "$wd" & >/dev/null 2>&1
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
      xdotool key ctrl+d 1>&2
    fi >> "$tmp_dir/urxvt"
  done
}

# vim: ft=sh ts=2 et sw=2:

