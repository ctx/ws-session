# open urxvt
# arg1: Data folder: where the last session was stored.
# Load the cwd's from the file arg1/urxvt
s_urxvt_open_session() {
  local file="$1/urxvt"
  s_restore_file $S_SHELL_HISTORY $S_SHELL_DIRS

  if [[ -f "$file" ]] ; then
    while read -r id wd ;do
      if [[ -n $id ]] ; then
        /usr/bin/urxvt -cd "$wd" & >/dev/null 2>&1
        pid="$!"
        s_reg_winid $pid $id
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
  local tmp_urxvt_file="$tmp_dir/urxvt"

  for urxvt in $urxvtids ; do
    local pid=$(xprop -id $urxvt _NET_WM_PID | cut -d " " -f 3 )
    local zshpid=$(ps --ppid $pid | grep zsh | head -1 | awk '{print $1}' )
    local cwd=$(readlink /proc/$zshpid/cwd)
    [[ $urxvt ]] && echo "$urxvt $cwd" >> "$tmp_urxvt_file"
    xdotool windowkill $urxvt
  done
  unset urxvt
}

# vim: ft=sh ts=2 et sw=2:

