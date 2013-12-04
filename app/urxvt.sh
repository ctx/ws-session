# open urxvt
# arg1: Data folder: where the last session was stored.
# Load the cwd's from the file arg1/urxvt
s_urxvt_open_session() {
  s_restore_file $S_SHELL_HISTORY zdirs
  while read -r wd ;do
    s_run_cmd_opensession ${wd#* } "urxvt -cd" "${wd% *}"
  done < <(grep -v "^$" "$1/urxvt")
}

# close urxvt, save working directory
# arg1: winids of all urxvts on current tag.
# Store the cwd of all urxvt's on the current tag
s_urxvt_close_session() {
  local urxvtids="$1"
  local temp_urxvt_file="$S_TEMP_FOLDER/$S_SEL_TAG/urxvt"

  for urxvt in $urxvtids ; do
    local pid=$(xprop -id $urxvt _NET_WM_PID | cut -d " " -f 3 )
    local zshpid=$(ps --ppid $pid | grep zsh | head -1 | awk '{print $1}' )
    local cwd=$(readlink /proc/$zshpid/cwd)
    [[ $cwd ]] && echo "$cwd $urxvt" >> "$temp_urxvt_file"
    xdotool windowkill $urxvt
  done
}

# vim: ft=sh ts=2 et sw=2:

